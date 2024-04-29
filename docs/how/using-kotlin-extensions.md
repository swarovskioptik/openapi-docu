# Using Kotlin extensions

The SDK is based on RxJava 2. If your app is based on Kotlin Coroutines / Flow,
wrapper for APIs that provide the functionality using suspending functions and
Flows are available as:

* [FlowSOCommOutsideAPIWrapper](../reference/FlowSOCommOutsideAPIWrapper/com.swarovskioptik.comm.sdk.wrapper.flow/index.html)
  for [SOCommOutsideAPI](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/index.html)
* [FlowSOCommMediaClientWrapper](../reference/FlowSOCommMediaClientWrapper/com.swarovskioptik.comm.media.wrapper.flow/index.html)
  for [SOCommMediaClient](../reference/MediaClient/com.swarovskioptik.comm.media/-s-o-comm-media-client/index.html)

In each case, build the SDK as stated above with the respective builder, and use the extension
function `.asFlowApi()` that will return a respective coroutine / flow instance.

You can add these libraries to your `build.gradle` like

```groovy
dependencies {
    implementation "com.swarovskioptik.comm::FlowSOCommMediaClientWrapper:[CURRENT_LIBRARY_VERSION]"
    implementation "com.swarovskioptik.comm::FlowSOCommOutsideAPIWrapper:[CURRENT_LIBRARY_VERSION]"
    [...]
}
```

Replace the term `[CURRENT_LIBRARY_VERSION]` with the current library version.
See for [Releases of the SOComm SDK](../ref/releases.md) for details.
