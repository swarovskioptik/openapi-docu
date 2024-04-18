# How to add the SO Comm SDK

This tutorial will walk you trough the necessary steps to add the *SO Comm SDK*
to your Android Application.  As an alternative you can also look at one of the
[example applications](../ref/example-applications.md).

## Warning

**Warning**: This content is not yet updated. The explanations and code examples do not yet reflect
the recommend and working way to add the *SO Comm SDK* to your application.

A working example and the currently recommend reference can be found in the
[example applications](../ref/example-applications.md).

## Include the Library - for Groovy DSL

If you want to include the SDK using the gradle, you need to configure a new
repository to fetch the SDK from.  This can best be done in your root projects
`settings.gradle` file to add the repository for all your modules:

```groovy
dependencyResolutionManagement {
    [...]
    repositories {
        [...]
        maven { url "https://repo.swarovskioptik.com/repository/maven-swarovski-optik/" }
    }
}
```

After the repository has been added, you can add the dependency like any other gradle/maven
dependency in your module/app level `build.gradle` file:

```groovy
implementation "com.swarovskioptik.comm:SOCommOutsideAPI:[CURRENT_LIBRARY_VERSION]"
```

Replace the term `[CURRENT_LIBRARY_VERSION]` with the current library version.
See for [Releases of the SO Comm SDK](../ref/releases.md) for details.


## Build an API instance

The [SOCommOutsideAPI](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/index.html)
can be instantiated by using the provided
[SOCommOutsideAPIBuilder](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i-builder/index.html)
class:

```kotlin
val api = SOCommOutsideAPIBuilder(this)
    .apiKey("[YOUR_API_KEY]")
    .build()
```

For this example the `this` points to an
[Android Activity](https://developer.android.com/reference/android/app/Activity),
which is an [Android Context](https://developer.android.com/reference/android/content/Context).

You have to replace the `[YOUR_API_KEY]` with your own personal API key.
The API key can be requested from Swarovski Optik, e.g.
[How to request an API Key](how-to-request-an-api-key.md) for details.

The API key is needed to authentice your applications against the device.

## Logging

You can configure debug, warning and error logs, too. For example you could log error logs in
production to e.g. Crashlytics, and warning logs in debug builds to the logcat. The debug-logs are
quite verbose and we recommend to only enable them if you are experiencing any troubles.

In practice it has been best to filter the debug logs in debug builds to only include the ones
tagged with `SDK`:

```kotlin
val api = SOCommOutsideAPIBuilder(this)
    .apiKey("[YOUR_API_KEY]")
    .debugLogs { tag, message ->
        if (BuildConfig.DEBUG) {
            Log.d(tag, message)
        }
    }
    .warningLogs { tag, message ->
        if (BuildConfig.DEBUG) {
            Log.w(tag, message)
        }
    }
    .errorLogs { tag, message -> Log.e(tag, message) }
    .build()
```

## Basic Usage

The API interface is developed using [RxJava2](https://github.com/ReactiveX/RxJava), so the API is
written for full RxJava2 support. If you're not familiar with `Completable`s and `Observable`s,
please refer to the [RxJava](https://github.com/ReactiveX/RxJava) documentation first. What is here
described as "calling a method" implies that the method is called, and the returned Completable or
Observable is subscribed to. Please also be aware of disposing your subscriptions accordingly.

The following sections should give a broad overview of the functionality of the API. For details on
specific calls, please refer to their JavaDocs.

## Search for a device

If you don't know the name of the device and want to search for nearby devices,
the SDK provides a
[`SOCommDeviceSearcher`](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-device-searcher/index.html) interface
that can be used to get a live list of devices found nearby:

```kotlin
// Create an instance using the create method
val deviceSearcher = SOCommDeviceSearcher.create(this)

// Subscribing to the returned Observable will start the search and will emit a list of all found devices with live updates:
val disposable = deviceSearcher.search()
    .subscribe(
        { foundDevices ->
            Log.d("DeviceSearcher", "List has been updated:")
            foundDevices.forEach { foundDevice ->
                Log.d("DeviceSearcher", "Found device $foundDevice")
            }
        },
        { throwable -> Log.e("DeviceSearcher", "Error: ${throwable.message}") }
    )

// Dispose when the search should be stopped:
disposable.dispose()
```

## Establish a connection

Basically you can connect to a remote device using the
[`connect()`](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/connect.html)
method with the device name you want to connect to. Once the operation
completes, the connection has been established. Please refer to the JavaDocs of
the connect method for a detailed description as well as possible error cases.

You can disconnect anytime by calling the
[`disconnect()`](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/disconnect.html)
method.

```kotlin
api.connect("DeviceName")
    .subscribe(
        {
            Log.d("API", "Successfully connected to the remote device")
            // now you are connected. You can use/release contexts now, and publish/subscribe topics.
            // ...
        },
        { Log.e("API", "Error while connecting to remote device") }
    )
    .addTo(compositeDisposable)

//If you want to exit the application / want to disconnect gracefully:
api.disconnect()
    .subscribe(
        onComplete = { Log.d("API", "Successfully disconnected from the remote device") },
        onError = { Log.e("API", "Error while disconnecting from the remote device") }
    )
    .addTo(compositeDisposable)
```

The [`connectionState`](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/connection-state.html)
will emit a new item any time the connection state changes, so you can
subscribe to that to be informed of any connection state changes.

(In more detail, the implementation of
the [`connectionState`](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/connection-state.html)
Observable is done using `BehaviorRelay`s, which means that when subscribing to it, the current
state is emitted nearly instantly for each subscriber. So it is safe and legit to use that with
the `blockingFirst` or `firstOrError` operators.)

The SDK needs some permissions (which are all declared and explained in the JavaDoc of
the [`connect()`](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/connect.html)
method). The permissions need to be granted before calling `connect()` or
otherwise the `connect()` method will error with a
[`PermissionNotGrantedException`](../reference/SOBase/com.swarovskioptik.exception/-permission-not-granted-exception/index.html).
Only RuntimePermission which needs to be requested from the user beforehand is
the `ACCESS_FINE_LOCATION` permission, all other permissions are non-dangerous
permissions and already declared in the libraries Manifest.

## Use & Release contexts

The topics you want to publish/subscribe to are grouped in different _contexts_ (the class is named
[`SOContext`](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-s-o-context/index.html)
easily distinguishable with the Android Context). A context defines a set of topics which can either
be subscribed or published to. Furthermore, a context defines which type of connection the topics
within that topic require.

Therefore, to be able to publish or subscribe to topics, you need to use the respective context
first.

To use a context, call
the [`use()`](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/use.html) method.
This method returns a Completable which completes once the initialization of
the [`SOContext`](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-s-o-context/index.html) has
been done.

```kotlin
// after `api.connect()` has completed

api.use(SomePredefinedContext)
    .subscribe(
        onComplete = {
            // This signals, that the context has been successfully initialized.
            // now you can publish / subscribe topics of the context.
            // The subscription emitted by use here also emits all items which are emitted
            // on any topic of the given context.
            Log.d("API", "context 'SomePredefinedContext' is now in use")
        },
        onError = { Log.e("API", "Error while using the context") }
    )
    .addTo(compositeDisposable)
```

If you don't need a context anymore (in other words: don't need the context's topics subscriptions
anymore), you should release a context again. You should not hold context in use if you don't need
them.

To release a context, call the
[`release()`](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/release.html)
method with the context which should be released.

```kotlin
// after `api.connect()` has completed and a context has been used (`api.use()`) which contains the given topic
api.release(TestTopics.SomeTopic)
    .subscribe(
        onComplete = { Log.d("API", "Successfully released the given context") },
        onError = { Log.e("API", "Error while releasing") }
    )
    .addTo(compositeDisposable)
```

On a more detailed note:
The purpose of contexts is at one hand to protect certain functionalities / topics with the given
API-key, but on the other hand also to distinguish over which connection type (BLE or WIFI) the
given topics can / should be transmitted. Therefore, using a context which has the connection-type
WIFI declared will result in a wifi connection attempt, and releasing such a context may result in a
wifi disconnect event. As WIFI usage may introduce a lower battery life expectancy of the remote
device, such contexts should only be used if needed, and be released when no longer needed.

## Publish & Subscribe

The actual communication is implemented using a publish-subscribe messaging pattern (somewhat
similar to what MQTT implements). So to send messages, you need
to [`publish`](../reference/SDK/com.swarovskioptik.comm/-base-s-o-comm-outside-a-p-i/publish-topic.html)
them on a given [`Topic`](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-topic/index.html)
, and to receive messages of a given type, you need
to [`subscribe`](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/subscribe-topic.html)
a given [`Topic`](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-topic/index.html).

Topics are (predefined) classes (objects) that implement
the [`TopicIn`](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-topic-in/index.html)
or [`TopicOut`](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-topic-out/index.html)
interface, depending on whether they are topics to be subscribed or topics to be published. Each
topic can either be a topic that can be published from the outside, or can be subscribed from the
outside, but not both.

To publish values on a topic (send them to the remote device), call
the [`publishTopic()`](../reference/SDK/com.swarovskioptik.comm/-base-s-o-comm-outside-a-p-i/publish-topic.html)
method. Pass
the [`TopicIn`](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-topic-in/index.html) to send
the value on as well as the value to be sent here. The type of the data to be emitted is defined by
the given `TopicIn`.

Each `TopicIn` has its own serializer, which will serialize the given value and
send it to the remote device. The returned completable will complete once the
value has been sent (this is not in sync to when the value will be received on
the other end).

```kotlin
// after `api.connect()` has completed and a context has been used (`api.use()` has completed) which contains the given topic.
api.publishTopic(Topics.SomeTopic, "Some value")
    .subscribe(
        onComplete = { Log.d("API", "Successfully published to the remote device") },
        onError = { Log.e("API", "Error while publishing") }
    )
    .addTo(compositeDisposable)
```

To subscribe to a topic (receive values from the remote device), call
the [`subscribeTopic()`](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/subscribe-topic.html)
method. The returned observable will emit all items received from the remote device de-serialized to
the original type again. The type of item which is emitted by the subscription is defined by the
given [`TopicOut`](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-topic-out/index.html).

Note that in order to be able to publish or subscribe to a topic, at least one context must be in
use which includes the given topic. Otherwise, the methods will emit an error.

```kotlin
// after `api.connect()` has completed and a context has been used (`api.use()`) which contains the
// given topic (and its `Initialized` item has been emitted)
api.subscribeTopic(Topics.SomeTopic)
    .subscribe(
        onNext = { item -> Log.d("API", "SomeTopic emitted an item: $item") },
        onError = { Log.e("API", "Error during subscription") }
    )
    .addTo(compositeDisposable)
```

## Full code example

An exemplary full usage example can be seen below.

_Please note_ that this is a minimal working example, and that your use-case will most likely be
that the connection to the remote device is established while the user is within your app, and that
you will use contexts for a longer time period than for just publishing one item and subscribing
until one item has been received.

```kotlin
// create an instance of the SOCommOutsideAPI using your application context (activity context works as well), and your API key)
val api = SOCommOutsideAPIBuilder(context)
    .apiKey("[YOUR_API_KEY]")
    .warningLogs { tag, message ->
        if (BuildConfig.DEBUG) {
            Log.w(tag, message)
        }
    }
    .errorLogs { tag, message ->
        //You may want to log errors also in release builds.
        Crashlytics.logException(RuntimeException("$tag: $message"))
    }
    .build()

api.connect("AX_Visio")
    .andThen(
        // use a context and wait for it to be initialized
        api.use(SOContext.DistanceEstimation)
    )
    .andThen(
        // publish an item to the topic `TestTopics.Switch` (with the value "true").
        // The type of the value is predefined by the topic.
        api.publishTopic(TestTopics.Switch, true)
    )
    .andThen(
        api.subscribeTopic(Topics.DistanceEstimation)
            .firstOrError()
            .doOnSuccess { distanceEstimationItem ->
                Log.d(
                    "DistanceEstimation",
                    "received distance estimation: ${distanceEstimationItem.distance} ${distanceEstimationItem.unit.name}"
                )
            }
            .ignoreElement()
    )
    .andThen(
        // when done using the context, release it again
        api.release(SOContext.DistanceEstimation)
    )
    .andThen(
        //when done with the connection to the remote device, disconnect
        api.disconnect()
    )
```
