#!/usr/bin/env bash

rm -f www-client/google-chrome**/*ebuild
cp -r /var/db/repos/gentoo/www-client/google-chrome* www-client/

for ebuild in www-client/google-chrome**/*ebuild; do
    patch --no-backup-if-mismatch $ebuild chrome.patch
    rename -- .ebuild -r1.ebuild $ebuild
done
