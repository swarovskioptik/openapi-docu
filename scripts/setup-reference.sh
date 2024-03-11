#!/bin/bash

set -e
set -x

SDK_DIR=../falke-sdk-android


(cd $SDK_DIR && ./gradlew clean)
(cd $SDK_DIR && ./gradlew dokkaHtmlMultiModule)

rm -rf docs/reference

cp -r $SDK_DIR/build/dokka/htmlMultiModule/ docs/reference

echo Finished!
