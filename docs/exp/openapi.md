# OpenAPI

The OpenAPI is provided by the OpenAPI Inside App. The logo of the OpenAPI is

![OpenAPI symbol](../img/openapi.svg)

A user has to select the OpenAPI App on the selection wheel.  Otherwise the
contexts are not available and the outside app cannot uses the contexts. If the
app is selected on the selection wheel, but the contexts are not available, the
user may has to press the power button. The contexts are only provided when the
screen is turned on.

## Available Contexts

When the OpenAPI Inside App is selected on the selection wheel the following
contexts are available and can be used with the API key:

* [OpenAPIContext       ](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-s-o-context/-open-a-p-i-context/index.html)
* [OpenAPIContextBLE    ](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-s-o-context/-open-a-p-i-context-b-l-e/index.html)
* [SystemContext        ](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-s-o-context/-system-context/index.html)
* [PicturePreviewContext](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-s-o-context/-picture-preview-context/index.html)
* [PictureContext       ](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-s-o-context/-picture-context/index.html)
* [VideoPreviewContext  ](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-s-o-context/-video-preview-context/index.html)
* [VideoContext         ](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-s-o-context/-video-context/index.html)
* [LiveStreamContext    ](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-s-o-context/-live-stream-context/index.html)


## OpenAPI Inside App selected

When no client is connected to the OpenAPI Inside App, the app shows the text
*Please Connect* on the AX Visio.

If your app has successfully used to the
[OpenAPIContext](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-s-o-context/-open-a-p-i-context/index.html)
or the
[OpenAPIContextBLE](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-s-o-context/-open-a-p-i-context-b-l-e/index.html)
the screen is not turned off automatically anymore. The screen and device stays
awake as long as your app uses these contexts.

You should either use the OpenAPIConext or the OpenAPIContextBLE. Using both
contexts at the same time, is an error and shows a warning in the InsideApp UI.

## Changes of the selection wheel

Your app must observe the [availableContexts](../reference/SDK/com.swarovskioptik.comm/-s-o-comm-outside-a-p-i/available-contexts.html).
The OpenAPI context may be withdrawn at any time. E.g. in the following cases

* The user selects a different App on the selection wheel
* The user presses the power button and the screen turns off
* The InsideApp crashes

In these cases the Outside App should notify the user and wait for the OpenAPI
contexts. If they become available again, it can reuse the context.

If the Outside App unuses the OpenAPI context or the OpenAPI Inside App
withdraws the contexts, the OpenAPI Inside App resets all internal state. E.g.
the Outside App must reregister all
[KeyListeners](../reference/SharedDefinitions/com.swarovskioptik.comm.definition.topic/-register-key-listener/index.html)
or
[KeyACtionProcedures](../reference/SharedDefinitions/com.swarovskioptik.comm.definition.topic/-configure-key-action-procedure/index.html),
when it uses the OpenAPI context again.


## KeyListener

The AX Visio has three different keys or buttons: The power button, the scroll button and the release button.
See [AX Visio > Buttons](../exp/ax-visio.md#buttons) for details.

In the OpenAPI these three different keys and two states are represented as the string constants:

* `OK_KEY_HALF`
* `OK_KEY_FULL`
* `POWER_KEY`
* `SCROLL_KEY`

The OpenAPI allows to register a [KeyListeners](../reference/SharedDefinitions/com.swarovskioptik.comm.definition.topic/-register-key-listener/index.html)
to detect the key press and key release event. This works on all keys and
states, except the power key. The power key is documented in the OpenAPI, but
it's exclusively used by the device to turn on or off the screen and to power
off the device.

A KeyListener is specific to a single key. If you want to listen on more keys
you have to register multiple listeners.

There is no usage counter on the KeyListeners. If the outside app registers a
listener for a single key two or more times, a single unregister call is
sufficient to unregister the listener.

## KeyActionProcedure

The Outside App can configure different
[KeyActionProcedure](../reference/SharedDefinitions/com.swarovskioptik.comm.definition.topic/-configure-key-action-procedure/index.html).
These are predefined actions for the keys on the AX Visio. E.g. to take a picture or to start and stop a video recording.
All available actions are documented here:
[ConfigureKeyActionProcedure.Params](../reference/SharedDefinitions/com.swarovskioptik.comm.definition.topic/-configure-key-action-procedure/-params/index.html)

A KeyActionProcedure consists of the actual procedure, the key and the action. The action is the direction of the key press, either down or up.

For a given (key, action) combination only a single procedure can be configured. If you configure another procedure for the same (key, action) combination it replaces the previous one.

To deconfigure a procedure, use the empty string as the procedure name.


## RenderText and RenderPixelGraphic

The OpenAPI allows the Outside Apps to display text and PNG on the AX Visio.

### RenderText

The outside app can draw one lined text strings on the AX Visio with the
[RenderText](../reference/SharedDefinitions/com.swarovskioptik.comm.definition.topic/-render-text/index.html)
topic.  The position on the screen is specified in a normal x,y coordinate
system. To calculate the middle of the screen or the bottom half of the screen,
you have to first query the screen resolution using the
[GetDisplayResolution](../reference/SharedDefinitions/com.swarovskioptik.comm.definition.topic/-get-display-resolution/index.html)
topic.

The outside app can draw up to five different text strings at the same time on
the AX Visio. If the outside app sends more than five text strings to the AX
Visio, the oldest text is removed. It's a first-in-first-out queue.

### RenderPixelGraphic

The Outside App can also draw arbitrary graphics on the AX Visio using the
[RenderPixelGraphic](../reference/SharedDefinitions/com.swarovskioptik.comm.definition.topic/-render-pixel-graphic/index.html)
topic. There are two graphics slot in the AX Visio. One slot
for a rotated image and one slot for a non-rotated image.

If the Outside App sends a new graphic before the duration of the old graphic
is elapsed, the new graphic replaces the old one.

The Outside App's image is not scaled. It's drawn at the same size on the
AX Visio. The current drawable resolution of the AX Visio display is 1366x768.
Furthermore the image is drawn at the center of the AX Visio screen, which is the
important visual view area for a user. So the image does not have to be the
same resolution as the AX Visio screen. It can be smaller and only cover the area
that the Outside App wants to draw in the center of the view. The border of the
screen is hard to see and recognizable by the user.

The image can be grayscale. It should mostly only use white and transparency.
Black is not visible on the display. RGB images work technically, too, but are
shown as grayscale on the monochrome AX Visio display.

## MediaClient

Try to avoid using the PictureTopics or the VideoTopics directly. It's
recommend to use the [MediaClient](../reference/MediaClient/index.html)
library.

It will handle the download of pictures and vidoes for you. It also writes the files to a shared storage, so multiple different apps can use them.

## LiveStreamContext

The AX Visio can provide a RTSP video stream which can be received by the Outside App, e.g. with the Android MediaPlayer.

The Outside App can activate the [LiveStreamContext](../reference/SharedDefinitions/com.swarovskioptik.comm.definition/-s-o-context/-live-stream-context/index.html)
with the OpenAPI
[StartLiveVideoStreaming](../reference/SharedDefinitions/com.swarovskioptik.comm.definition.topic/-start-live-video-streaming/index.html) topic
and stop it with
[StopLiveVideoStreaming](../reference/SharedDefinitions/com.swarovskioptik.comm.definition.topic/-stop-live-video-streaming/index.html) topic.

When the Outside App starts to use the LiveStreamContext, the Video stream and
RSTP server is started on the AX Visio. After using the context, the Outside
app can subscribe to the
[LiveStreamStatus](../reference/SharedDefinitions/com.swarovskioptik.comm.definition.topic/-live-stream-status/index.html)
to receive the details about the video stream.

While handling this topic, the Outside App should take care of the following points:

* Check for the URL value `RTSP URL NOT AVAILABLE` or non-valid RTSP URLs. The
  AX Visio sends it when there is no RTSP server running anymore.
* This topic is also send when a client connects and disconnect. See field
  `activeClients`. It changes regularly. So if the Outside App restarts the
  stream on every topic change, it creates  a endless feedback loop, because
  the field `activeClients` changes when the client itself connects and
  disconnects.

If you want to change the resolution of the RTSP video stream, you can use the topic
[SetLiveStreamSettings](../reference/SharedDefinitions/com.swarovskioptik.comm.definition.topic/-set-live-stream-settings/index.html).
The currently only available resolutions are

* `640x480`
* `1280x720`
* `1920x1080`
