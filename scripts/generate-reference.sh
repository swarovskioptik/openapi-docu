#!/bin/bash

# This scipts generates the API Reference of the *SO Comm SDK* for the Outside
# app development.  There is internal documentation on how to use the script to
# update the html/css/js files for the API reference.
#
# In short, this script requires that you check out the internal
# 'falke-sdk-android' repo algonside this repo, the 'openapi-docu' repo, and
# then execute it.

set -e
set -x

SDK_DIR=../falke-sdk-android

# Checks
if ! test -f scripts/generate-reference.sh; then
	echo ERROR: The script must be executed in the root dir of the 'openapi-docu' repo! >&2
	exit 1
fi
if ! test -d $SDK_DIR; then
	echo ERROR: SDK_DIR directory "$SDK_DIR" does not exist! >&2
	exit 1
fi


(cd $SDK_DIR && ./gradlew clean)
(cd $SDK_DIR && ./gradlew dokkaHtmlMultiModule)

rm -rf docs/reference

cp -r $SDK_DIR/build/dokka/htmlMultiModule/ docs/reference

echo Finished!
