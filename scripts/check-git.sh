#!/bin/bash

git=$(find "$PROJECTS_DIR" -mindepth 1 -maxdepth 5 -name ".git")

for i in $git; do
	cd "$i/.."
	echo "$(pwd ..)"

	git -c color.ui=always fetch | sed 's/^/    /'
	git -c color.ui=always pull | sed 's/^/    /'
	git -c color.ui=always status -suno | sed 's/^/    /'
done
