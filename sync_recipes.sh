#!/bin/bash

CF_ROOT="../conda-forge"
RECIPE_DIR="$(pwd)/recipes"
GIT_ARGS="-q"

sync_recipe() {
	recipe=$1

	mkdir -p ${CF_ROOT}
	pushd ${CF_ROOT} >/dev/null 2>&1

	feedstock_dir=${recipe}-feedstock
	if [ ! -d ${feedstock_dir} ]; then
		feedstock=https://github.com/conda-forge/${feedstock_dir}.git
		git ls-remote "$feedstock" &>-
		if [ "$?" -ne 0 ]; then
			echo "[ERROR] conda-forge repo '$feedstock' doesn't exist"
			exit 1
		else
			git clone $feedstock ${GIT_ARGS}
		fi
	fi
	cd ${feedstock_dir}
	git checkout master ${GIT_ARGS}
	git fetch origin ${GIT_ARGS}
	git reset --hard origin/master ${GIT_ARGS}

	if [ ! -d ${RECIPE_DIR}/${recipe}/ ]; then
		echo "[INFO] Directory for recipe ${recipe} doesn't exist. Creating. "
		mkdir -p ${RECIPE_DIR}/${recipe}/
	fi
	echo "[INFO] Copying recipe to ${RECIPE_DIR}/${recipe}/"
	cp -r recipe/* ${RECIPE_DIR}/${recipe}/

	popd >/dev/null 2>&1
}

usage() {
	echo
	echo "Usage: $0 package1 [package2 package3 ...]"
	echo "Sync recipe(s) with a conda-forge feedstock"
	echo "'$0 all' will sync all recipes"
}

if [[ $# -lt 1 ]]; then
	usage
	exit 1
fi

if [[ $1 == "all" ]]; then
	for recipe_dir in $(ls -d ${RECIPE_DIR}/*/); do
		recipe=$(basename $recipe_dir)
		echo "[INFO] Syncing $recipe recipe with conda-forge"
		sync_recipe $recipe
	done

else
	for recipe in "$@"; do
		echo "[INFO] Syncing $recipe recipe with conda-forge"
		sync_recipe $recipe
	done
fi
