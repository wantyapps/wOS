#!/bin/bash
exec 1>&2 # Redirect output
exec < /dev/tty # Enable user input


root=$(git rev-parse --show-toplevel)
VERSION=$(grep '^VERSION[[:space:]]*=' ${root}/Makefile|tr -d 'VERSION= ')
PATCHLEVEL=$(grep '^PATCHLEVEL[[:space:]]*=' ${root}/Makefile|tr -d 'PATCHLEVEL= ')
SUBLEVEL=$(grep '^SUBLEVEL[[:space:]]*=' ${root}/Makefile|tr -d 'SUBLEVEL= ')
EXTRAVERSION=$(grep '^EXTRAVERSION[[:space:]]*=' ${root}/Makefile|tr -d 'EXTRAVERSION= ')
NAME=$(grep '^NAME[[:space:]]*=' ${root}/Makefile|tr -d 'NAME= ')

KERNELVERSION=$(grep '^int VERSION' ${root}/kernel/kernelversion.h|tr -d ' ')
KERNELPATCHLEVEL=$(grep '^int PATCHLEVEL' ${root}/kernel/kernelversion.h|tr -d ' ')
KERNELSUBLEVEL=$(grep '^int SUBLEVEL' ${root}/kernel/kernelversion.h|tr -d ' ')
KERNELEXTRAVERSION=$(grep '^char EXTRAVERSION' ${root}/kernel/kernelversion.h|tr -d ' ')
KERNELNAME=$(grep '^char NAME' ${root}/kernel/kernelversion.h|tr -d ' ')

FULL_VERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL$EXTRAVERSION"
KERNELFULL_VERSION="$KERNELVERSION.$KERNELPATCHLEVEL.$KERNELSUBLEVEL$KERNELEXTRAVERSION"

echo "wOS version $FULL_VERSION ($NAME)"
# echo "wOS kernel version $KERNELFULL_VERSION ($KERNELNAME)"

# if [ ! "$FULL_VERSION" == "$KERNELFULL_VERSION" ]; then
# 	echo "kernel/version.h version does not match Makefile version"
# 	exit 1
# fi

# echo "wOS version $FULL_VERSION ($NAME)"
# echo "wOS kernel version $KERNELFULL_VERSION ($KERNELNAME)"

read -ep "Are you sure kernel/kernelversion.h and Makefile versions match? [y/n]:" versionyn
if [ "$versionyn" != "y" ]; then
	exit 1
fi
read -ep "Autotag? [y/n]:" autotag
read -ep "Message: " message

if [ "$autotag" == "y" ]; then 
	git tag -as "v$FULL_VERSION" -m "$message"
fi
