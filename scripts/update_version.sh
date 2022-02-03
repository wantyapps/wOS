#!/bin/bash

root=$(git rev-parse --show-toplevel)
VERSION=$(grep '^VERSION[[:space:]]*=' ${root}/Makefile|tr -d 'VERSION= ')
PATCHLEVEL=$(grep '^PATCHLEVEL[[:space:]]*=' ${root}/Makefile|tr -d 'PATCHLEVEL= ')
SUBLEVEL=$(grep '^SUBLEVEL[[:space:]]*=' ${root}/Makefile|tr -d 'SUBLEVEL= ')
EXTRAVERSION=$(grep '^EXTRAVERSION[[:space:]]*=' ${root}/Makefile|tr -d 'EXTRAVERSION= ')

FULL_VERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL$EXTRAVERSION"

echo "wOS version $VERSION.$PATCHLEVEL.$SUBLEVEL$EXTRAVERSION"

read -ep "Autoag? [y/n]:" autotag

if [ "$autotag" == "y" ]; then 
	git tag -as "v$FULL_VERSION"
fi
