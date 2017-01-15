#! /usr/bin/env python
""" Find conda packages which are out of date compared to PyPI. """

import argparse
import json
import xmlrpc.client as xmlrpclib

import conda.api as api

try:
    from packaging.version import parse as parse_version
except ImportError:
    from pip._vendor.packaging.version import parse as parse_version


def find_latest_pypi_version(client, package_name):
    """
    Return the latest non-prerelease from PyPI.

    None is returned if there are no releases or the package does not exist on
    PyPI.
    """
    all_releases = client.package_releases(package_name, True)
    versions = [parse_version(s) for s in all_releases]
    filtered = [v for v in versions if not v.is_prerelease]
    if len(filtered) == 0:
        return None
    return max(filtered)


def find_latest_conda_version(index, package_name):
    """ Return the latest version of a package from a conda channel index. """
    valid = [v for v in index.values() if v['name'] == package_name]
    versions = [parse_version(v['version']) for v in valid]
    return max(versions)


def parse_arguments():
    """ Parse command line arguments. """
    parser = argparse.ArgumentParser(
        description="Find conda packages which are out of date with PyPI")
    parser.add_argument(
        'packages', nargs='*',
        help=('Name of packages to check, leave blank to check all packages '
              'on the channel'))
    parser.add_argument(
        '--skip', '-s', action='store', help=(
            'file containing list of packages to skip when checking against '
            'PyPI'))
    parser.add_argument(
        '--verb', '-v', action='store_true', help='verbose output')
    parser.add_argument(
        '--channel', '-c', action='store', default='rpi',
        help='Conda channel to check.  Default is rpi')
    parser.add_argument(
        '--json', action='store', help='Save outdated packages to json file.')
    return parser.parse_args()


def find_outdated_packages(index, package_names, verbose):
    """ Return a list of out-of-date packages. """
    client = xmlrpclib.ServerProxy('https://pypi.python.org/pypi')

    outdated_packages = []
    for package_name in sorted(package_names):
        pypi_latest_version = find_latest_pypi_version(client, package_name)
        conda_latest_version = find_latest_conda_version(index, package_name)

        if pypi_latest_version is None:
            if verbose:
                print(package_name, "not found on PyPI or does",
                      "not have any non-prerelease versions")
            continue

        if pypi_latest_version > conda_latest_version:
            print(package_name, "appears out of date", pypi_latest_version,
                  'vs', conda_latest_version)
            pkg = {'name': package_name,
                   'pypi_version': pypi_latest_version.base_version,
                   'conda_version': conda_latest_version.base_version}
            outdated_packages.append(pkg)

        elif verbose:
            print(package_name, "appears up to date")

    return outdated_packages


def main():
    args = parse_arguments()

    # determine package names to check
    index = api.get_index(
        channel_urls=[args.channel], prepend=False, use_cache=False)
    package_names = set(args.packages)
    if len(package_names) == 0:  # no package names given on command line
        package_names = {v['name'] for k, v in index.items()}

    # remove skipped packages
    if args.skip is not None:
        with open(args.skip) as f:
            pkgs_to_skip = [line.strip() for line in f]
        package_names = [p for p in package_names if p not in pkgs_to_skip]

    outdated_packages = find_outdated_packages(index, package_names, args.verb)

    # save outdated_packages to json formatted file is specified
    if args.json is not None:
        with open(args.json, 'w') as f:
            json.dump(outdated_packages, f)


if __name__ == "__main__":
    main()
