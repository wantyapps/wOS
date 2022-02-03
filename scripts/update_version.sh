#!/bin/bash

VERSION=$(grep '^VERSION[[:space:]]*=' ../../Makefile|tr -d 'VERSION= ')
PATCHLEVEL=$(grep '^PATCHLEVEL[[:space:]]*=' ../../Makefile|tr -d 'PATCHLEVEL= ')
SUBLEVEL=$(grep '^SUBLEVEL[[:space:]]*=' ../../Makefile|tr -d 'SUBLEVEL= ')
EXTRAVERSION=$(grep '^EXTRAVERSION[[:space:]]*=' ../../Makefile|tr -d 'EXTRAVERSION= ')

FULL_VERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL$EXTRAVERSION"

echo "wOS version $VERSION.$PATCHLEVEL.$SUBLEVEL$EXTRAVERSION"

read -ep "Autoag? [y/n]:" autotag

if [ "$autotag" == "y" ]; then 
	git tag -as "v$FULL_VERSION"
fi
