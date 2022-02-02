#!/bin/sh
# I basically stole this script from torvalds/linux

LF='
'

if test -d .git -o -f .git &&
	VN=$(git describe --abbrev=4 HEAD 2>/dev/null) &&
	case "$VN" in
	*$LF*) (exit 1) ;;
	v[0-9]*)
		git update-index -q --refresh
		test -z "$(git diff-index --name-only HEAD --)" ||
		VN="$VN-dirty" ;;
	esac
then
	VN=$(echo "$VN" | sed -e 's/-/./g');
else
	eval $(grep '^VERSION[[:space:]]*=' Makefile|tr -d ' ')
	eval $(grep '^PATCHLEVEL[[:space:]]*=' Makefile|tr -d ' ')
	eval $(grep '^SUBLEVEL[[:space:]]*=' Makefile|tr -d ' ')
	eval $(grep '^EXTRAVERSION[[:space:]]*=' Makefile|tr -d ' ')

	VN="v${VERSION}.${PATCHLEVEL}.${SUBLEVEL}${EXTRAVERSION}"
fi

VN=$(expr "$VN" : v*'\(.*\)')

git tag -as "v$VN"
