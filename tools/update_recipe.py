#! /usr/bin/env python
import argparse
import hashlib
import json
import re
from urllib.request import urlretrieve, urlopen

import jinja2
import yaml


def update_version(lines, version):
    """ Update the text of a conda recipe to a given version. """
    quoted_version = '"' + version + '"'
    set_version_pattern = '(?<=set version = ).*(?= %})'
    lines = [re.sub(set_version_pattern, quoted_version, l) for l in lines]
    return lines


def hash_from_download(recipe_dict, hash_type):
    """ Download the file and calculate the hash """
    source_url = recipe_source['url']
    source_filename = recipe_source['fn']
    urlretrieve(source_url, source_filename)
    with open(source_filename, 'rb') as f:
        data = f.read()
    if hash_type == 'md5':
        hash_value = hashlib.md5(data).hexdigest()
    else:
        hash_value = hashlib.sha256(data).hexdigest()
    return hash_value


def hash_from_pypi(package_name, release, filename, hash_type):
    """ Obtain a hash from PyPI. """
    url = 'https://pypi.org/pypi/' + package_name + '/json'
    response = urlopen(url)
    package_info = json.loads(response.read().decode('utf8'))
    release_info = package_info['releases'][release]
    entry = [e for e in release_info if e['filename'] == filename][0]
    if len(entry) == 0:
        raise ValueError('No matching packages found on PyPI')
    hash_value = entry['digests'][hash_type]
    return hash_value


def find_hash(lines):
    """ Find the hash type and value for a conda recipe. """
    # detemine the hash type from the rendered recipe
    recipe_text = ''.join(lines)
    recipe_dict = yaml.load(jinja2.Template(recipe_text).render())
    recipe_source = recipe_dict['source']
    if 'md5' in recipe_source:
        hash_type = 'md5'
    elif 'sha256' in recipe_source:
        hash_type = 'sha256'
    else:
        raise ValueError("Unknown hash type", recipe_source)
    package_name = recipe_dict['package']['name']
    release = str(recipe_dict['package']['version'])
    filename = recipe_dict['source']['url'].split('/')[-1]
    hash_value = hash_from_pypi(package_name, release, filename, hash_type)
    return hash_type, hash_value


def update_hash(lines, hash_type, hash_value):
    """ Update the md5/sha256 hash of a conda recipe. """
    # replace jinja templated hash
    quoted_hash = '"' + hash_value + '"'
    pattern = '(?<=set hash_val = ).*(?= %})'
    lines = [re.sub(pattern, quoted_hash, l) for l in lines]
    pattern = '(?<=set hash = ).*(?= %})'
    lines = [re.sub(pattern, quoted_hash, l) for l in lines]
    if hash_type == 'sha256':
        pattern = '(?<=set sha256 = ).*(?= %})'
        lines = [re.sub(pattern, quoted_hash, l) for l in lines]
    if hash_type == 'md5':
        pattern = '(?<=set md5 = ).*(?= %})'
        lines = [re.sub(pattern, quoted_hash, l) for l in lines]
    # replace yaml hash values
    if hash_type == 'sha256':
        pattern = '(?<=sha256: )[0-9A-Fa-f]+'
        lines = [re.sub(pattern, hash_value, l) for l in lines]
    if hash_type == 'md5':
        pattern = '(?<=md5: )[0-9A-Fa-f]+'
        lines = [re.sub(pattern, hash_value, l) for l in lines]
    return lines


def update_recipe(meta_filename, version):
    """ Update a conda recipe to a given version. """
    with open(meta_filename) as f:
        lines = f.readlines()
    lines = update_version(lines, version)
    hash_type, hash_value = find_hash(lines)
    lines = update_hash(lines, hash_type, hash_value)
    with open(meta_filename, 'wb') as f:
        f.write(''.join(lines).encode('utf8'))
    print("Updated", meta_filename, "to version", version)
    return


def parse_arguments():
    parser = argparse.ArgumentParser(
        description="Update a conda recipe to a given version")
    parser.add_argument(
        'meta_filename', help="path to the recipe's meta.yaml files.")
    parser.add_argument(
        'version', help="version to update the recipe to.")
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_arguments()
    update_recipe(args.meta_filename, args.version)
