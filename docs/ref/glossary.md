# Glossary

This page is a glossary. It should give a short explanation of all terms used
in the context of the OpenAPI for the AX Visio.


## OpenAPI

The term OpenAPI is an umbrella term to sum up all things that are needed to
build third party applications that can connect to an AX Visio binocular and
use the exposed functionalities. E.g. it describes the OpenAPI Inside
Application, the OpenAPI contexts, the topics exposed for the OpenAPI contexts,
the OpenAPI documentation, ...

## SO Comm SDK

The SO Comm SDK is a set of libraries that can be included in Android
applications. These allow to connect to an AX Visio and perform various
actions. See [Intro > SO Comm SDK](../intro/so-comm-sdk.md) for details.

## SO Comm Outside API

The SO Comm Outside API is the main Java/kotlin library to connect to an AX
Visio. It handles the connection, usage of SOContexts and publishing and
subscribing to topics.  Its API reference can be found here:
[SOCommOutsideAPI](../reference/SDK/com.swarovskioptik.comm/index.html)

## SOContext

A SOContext contains a set of communication endpoints that are, from a usage
point of view, related to each other, have similar needs for communication
bandwidth and access control requirements. On Swarovski Optik devices
SOContexts can be provided by applications or system services, which might be
used by several applications. On smartphones apps can use a SOContext, when it
is provided by a Swarovski Optik device and the app has access to it.

All SOContexts that are exposed for the OpenAPI are listed here:
[OpenAPI > Available Contexts](../intro/openapi.md#available-contexts)

## Use or release a context

tdb

## Topics

tdb

## Publish or subscribe a topic

tbd

## OpenAPI Contexts

This name stands for the special `OpenAPIContext` and the `OpenAPIContextBLE`
and the additional contexts that are available for third party apps that are
using the OpenAPI.  The full list of contexts is available at [Introduction -
OpenAPI](../intro/openapi.md).

## Inside vs Outside Applications:

Inside applications run on the AX Visio binocular and can be activated by
rotating the mode selection wheel. Outside Applications run on the users
smartphone and connect via the `SO Comm SDK` to the binocular.
