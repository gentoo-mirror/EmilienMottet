#!/usr/bin/env bash

files="www-client/google-chrome**/*ebuild"
regex="-r([0-9]+)"
i="1"

rm -f www-client/google-chrome**/*ebuild
cp -r /var/db/repos/gentoo/www-client/google-chrome* www-client/

for ebuild in $files; do
    pattern=".ebuild"
    patch --no-backup-if-mismatch $ebuild chrome.patch

    if [[ $ebuild =~ $regex ]];
    then
        i="${BASH_REMATCH[1]}"
        pattern="-r${i}${pattern}"
        ((i=i+1))
    fi
    rename -- $pattern -r${i}.ebuild $ebuild
done

for ebuild in $files; do
    ebuild $ebuild digest && sudo ebuild $ebuild clean merge
done
