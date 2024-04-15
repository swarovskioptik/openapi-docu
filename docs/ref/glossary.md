# Glossary

This page is a glossary. It should give a short explanation of all terms used
in the context of the OpenAPI for the AX Visio.


## OpenAPI

The term OpenAPI is an umbrella term to sum up all things that are needed to
build third party applications that can connect to an AX Visio binocular and
use the exposed functionalities. E.g. it describes the OpenAPI Inside
Application, the OpenAPI contexts, the topics exposed for the OpenAPI contexts,
the OpenAPI documentation, the SO Comm SDK, the SO Comm Outside API Library, ...

## SO Comm SDK

The SO Comm SDK is a set of libraries that can be included in Android
applications. These allow to connect to an AX Visio and perform various
actions. See [Intro > SO Comm SDK](../intro/so-comm-sdk.md) for details.

## SO Comm Outside API

The SO Comm Outside API is the main Java/Kotlin library to connect to an AX
Visio. It handles the connection, usage of SO Contexts and publishing and
subscribing to topics.  Its API reference can be found here:
[SOCommOutsideAPI](../reference/SDK/com.swarovskioptik.comm/index.html)

## SO Context

A [SO Context](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-s-o-context/index.html)
contains a set of communication endpoints that are, from a usage
point of view, related to each other, have similar needs for communication
bandwidth and access control requirements. On Swarovski Optik devices
SO Contexts can be provided by applications or system services, which might be
used by several applications. On smartphones apps can use a SO Context, when it
is provided by a Swarovski Optik device and the app has access to it.

All SO Contexts that are exposed for the OpenAPI are listed here:
[OpenAPI > Available Contexts](../intro/openapi.md#available-contexts)

## Use or release a context

Once the application established a connection with the AX Visio, you can
[use](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/use.html)
a specific SO Context. This allows your application to use the functionality
provided by the context. If your application is finished, you can also
[release](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/release.html)
the context again.

## Topics

Topics are unique paths to functionality and very similar to MQTT topics. They
are bundled inside a specific SO Context. Topics are characterized as either
*in* or *out* topics.
[TopicIns](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-topic-in/index.html)
allow you to communicate from the smartphone to the AX Visio.
[TopicOuts](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-topic-out/index.html)
allow to communicate from the AX Visio to the smartphone.

## Publish or subscribe a topic

After connecting with the SO Comm Outside API library to the AX Visio and using
a SO Context, you can start using topics.
You can
[publish](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/publish-topic.html)
on a *in* topic and
[subscribe](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/subscribe-topic.html)
to an *out* topic.

## OpenAPI Contexts

This name stands for the special `OpenAPIContext` and the `OpenAPIContextBLE`
and the additional contexts that are available for third party apps that are
using the OpenAPI.  The full list of contexts is available at [Introduction -
OpenAPI](../intro/openapi.md).

## Inside vs Outside Applications

Inside applications run on the AX Visio binocular and can be activated by
rotating the mode selection wheel. Outside Applications run on the users
smartphone and connect via the SO Comm SDK to the binocular.

## SO Comm MediaClient

The [SO Comm MediaClient](../reference/MediaClient/index.html),
or short MediaClient,  is an additional library for picture and video handling
_around_ the SO Comm Outside API. It should be used instead of manually
downloading picture or video data from the AX Visio.
