#!/bin/bash

url=$(git remote get-url origin)

if [[ $url == git@* ]]; then
	url="${url#git@}"
	url="${url/:/\/}"
	url="https://$url"

	xdg-open $url
else
	echo "This repository is not using an SSH remote (git@...)"
fi

exit 0
