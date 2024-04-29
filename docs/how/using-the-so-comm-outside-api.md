# Using the SO Comm Outside API

The [SOCommOutsideAPI](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/index.html)
can be instantiated by using the provided
[SOCommOutsideAPIBuilder](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i-builder/index.html)
class:

## Using the SOCommOutsideAPIBuilder

```kotlin
val api = SOCommOutsideAPIBuilder(this)
    .apiKey("[YOUR_API_KEY]")
    .build()
```

For this example the `this` points to an
[Android Activity](https://developer.android.com/reference/android/app/Activity),
which is an [Android Context](https://developer.android.com/reference/android/content/Context).

You have to replace the `[YOUR_API_KEY]` with your own personal API key.
The API key can be requested from Swarovski Optik. See
[Requesting an API key](../tut/requesting-an-api-key.md) for details.  The API
key is needed to authentice your applications against the device.


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
[SOCommDeviceSearcher](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-device-searcher/index.html) interface
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
        { e -> Log.e("DeviceSearcher", "Error: ${e.message}", e) }
    )

// Dispose when the search should be stopped:
disposable.dispose()
```


## Android Permissions

The library needs some [install and runtime
permissions](https://developer.android.com/guide/topics/permissions/overview)
to operate. These are already declared in the `AndroidManifest.xml` of the SO
Comm Outside API library, so you don't have to declare these in our
application's manifest yourself. They are added automatically.

The needed permissions are described in the
[connect()](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/connect.html)
method. Requesting the runtime permissions is _not_ done by the SO Comm Outside API
library. These are

* Manifest.permission.ACCESS_FINE_LOCATION
* Manifest.permission.BLUETOOTH_SCAN
* Manifest.permission.BLUETOOTH_CONNECT
* Manifest.permission.BLUETOOTH_ADVERTISE

Your application has to request them itself. See the
[example applications](../ref/example-applications.md) for details.


## Bluetooth

Additionally the user has to enable bluetooth. Checking whether Bluetooth is
enabled, can be done with Android's
[BluetoothManager](https://developer.android.com/reference/android/bluetooth/BluetoothManager).

For an example please have a look at the the
[example applications](../ref/example-applications.md), too.


## Establish a connection

Basically you can connect to a remote device using the
[connect()](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/connect.html)
method with the device name you want to connect to. Once the operation
completes, the connection has been established. Please refer to the JavaDocs of
the connect method for a detailed description as well as possible error cases.

You can disconnect anytime by calling the
[disconnect()](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/disconnect.html)
method.

```kotlin
val compositeDisposable = CompositeDisposable()

api.connect("DeviceName")
    .subscribe(
        {
            Log.d("API", "Successfully connected to the remote device")
            // now you are connected. You can use/release contexts now, and publish/subscribe topics.
            // ...
        },
        { e -> Log.e("API", "Error while connecting to remote device", e) }
    )
    .addTo(compositeDisposable)

//If you want to exit the application / want to disconnect gracefully:
api.disconnect()
    .subscribe(
        { Log.d("API", "Successfully disconnected from the remote device") },
        { e -> Log.e("API", "Error while disconnecting from the remote device", e) }
    )
    .addTo(compositeDisposable)
```

The [connectionState](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/connection-state.html)
will emit a new item any time the connection state changes, so you can
subscribe to that to be informed of any connection state changes.

(In more detail, the implementation of
the [connectionState](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/connection-state.html)
Observable is done using `BehaviorRelay`s, which means that when subscribing to it, the current
state is emitted nearly instantly for each subscriber. So it is safe and legit to use that with
the `blockingFirst` or `firstOrError` operators.)

The permissions need to be granted before calling `connect()` or
otherwise the `connect()` method will error with a
[PermissionNotGrantedException](../reference/SOBase/com.swarovskioptik.exception/-permission-not-granted-exception/index.html).
See the previous sections.


## Use & Release contexts

The topics you want to publish/subscribe to are grouped in different _contexts_ (the class is named
[SO Context](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-s-o-context/index.html)
easily distinguishable with the Android Context). A context defines a set of topics which can either
be subscribed or published to. Furthermore, a context defines which type of connection the topics
within that topic require.

Therefore, to be able to publish or subscribe to topics, you need to use the respective context
first.

To use a context, call
the [use()](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/use.html) method.
This method returns a Completable which completes once the initialization of
the [SO Context](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-s-o-context/index.html) has
been done.

```kotlin
// after `api.connect()` has completed

api.use(SomePredefinedContext)
    .subscribe(
        {
            // This signals, that the context has been successfully initialized.
            // now you can publish / subscribe topics of the context.
            // The subscription emitted by use here also emits all items which are emitted
            // on any topic of the given context.
            Log.d("API", "context 'SomePredefinedContext' is now in use")
        },
        { e -> Log.e("API", "Error while using the context", e) }
    )
    .addTo(compositeDisposable)
```

If you don't need a context anymore (in other words: don't need the context's topics subscriptions
anymore), you should release a context again. You should not hold context in use if you don't need
them.

To release a context, call the
[release()](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/release.html)
method with the context which should be released.

```kotlin
// after `api.connect()` has completed and a context has been used (`api.use()`) which contains the given topic
api.release(TestTopics.SomeTopic)
    .subscribe(
        { Log.d("API", "Successfully released the given context") },
        { e -> Log.e("API", "Error while releasing", e) }
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
to [publish](../reference/SDK/com.swarovskioptik.comm/-base-s-o-comm-outside-a-p-i/publish-topic.html)
them on a given [Topic](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-topic/index.html)
, and to receive messages of a given type, you need
to [subscribe](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/subscribe-topic.html)
a given [Topic](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-topic/index.html).

Topics are (predefined) classes (objects) that implement
the [TopicIn](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-topic-in/index.html)
or [TopicOut](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-topic-out/index.html)
interface, depending on whether they are topics to be subscribed or topics to be published. Each
topic can either be a topic that can be published from the outside, or can be subscribed from the
outside, but not both.

To publish values on a topic (send them to the remote device), call
the [publishTopic()](../reference/SDK/com.swarovskioptik.comm/-base-s-o-comm-outside-a-p-i/publish-topic.html)
method. Pass
the [TopicIn](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-topic-in/index.html) to send
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
        { Log.d("API", "Successfully published to the remote device") },
        { e -> Log.e("API", "Error while publishing", e) }
    )
    .addTo(compositeDisposable)
```

To subscribe to a topic (receive values from the remote device), call
the [subscribeTopic()](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/subscribe-topic.html)
method. The returned observable will emit all items received from the remote device de-serialized to
the original type again. The type of item which is emitted by the subscription is defined by the
given [TopicOut](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-topic-out/index.html).

Note that in order to be able to publish or subscribe to a topic, at least one context must be in
use which includes the given topic. Otherwise, the methods will emit an error.

```kotlin
// after `api.connect()` has completed and a context has been used (`api.use()`) which contains the
// given topic (and its `Initialized` item has been emitted)
api.subscribeTopic(Topics.SomeTopic)
    .subscribe(
        { item -> Log.d("API", "SomeTopic emitted an item: $item") },
        { e -> Log.e("API", "Error during subscription", e) }
    )
    .addTo(compositeDisposable)
```
