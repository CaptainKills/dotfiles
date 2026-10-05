#!/bin/bash

git=$(find "$PROJECTS_DIR" -mindepth 1 -maxdepth 5 -name ".git")

for i in $git; do
	cd "$i/.."
	echo "$(pwd ..)"

	git status -suno
done
