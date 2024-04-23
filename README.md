# Swarovski Optik OpenAPI Documentation

This repo hosts the raw files for the Swarovski Optik OpenAPI documentation.
It's published on the webpage:
[Swarovski Optik OpenAPI Documentation](https://swarovskioptik.github.io/openapi-docu/)


## How to test locally

The documentation is build with [mkdocs](https://www.mkdocs.org/). To
test/deploy/work locally you first have to install mkdocs. See
[Getting Started with MkDocs](https://www.mkdocs.org/getting-started/) for
details.

After that just execute

    $ mkdocs serve

on the commandline and open the displayed link in the browser.


## How to update the API reference

To build the API reference, execute

    $ scripts/generate-reference.sh

NOTE: This requires a patched `falke-sdk-android` repo at the correct location.
Please have a look at the internal doku.


## How to deploy

To deploy the documentation including the API reference, just execute

    $ mkdocs gh-deploy

This will build the final HTML files and pushes them to the `gh-pages` branch
to github.


## Open Issues

References/Links to RxJava are not set/resolved in the API reference.

References/Links to Kotlin
[Flows](https://kotlinlang.org/api/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.flow/-flow/)
are not resolved.
