# FireSound
*Volume control for USB Audio devices on Amazon Fire TV*

## Motivation

The [Fire TV][0] outputs the audio signal along to the video signal over
[HDMI][1] by default. Thus, if a computer monitor without speakers is used for
displaying video, there won't be any audio.
[0]: https://en.wikipedia.org/wiki/Amazon_Fire_TV
[1]: https://en.wikipedia.org/wiki/HDMI

On the other hand, the Fire TV box offers a [USB][2] port which can be used
for external audio devices, such as speakers or head phones. Luckily, the
[Android][3] based software which runs on the Fire TV ([Fire OS][4]) supports
audio output via USB with a snag: The is no user interface for volume control.
The default output of digital audio via HDMI does not need (or support?) any
volume control, i.e. mixing.
[2]: https://en.wikipedia.org/wiki/USB
[3]: https://en.wikipedia.org/wiki/Android_(operating_system)
[4]: https://en.wikipedia.org/wiki/Fire_OS

However, the underlying Android system is based on a minimal Linux which supports
audio mixing via the [tinyALSA][5] tools. Specifically, `tinymix` is used here.
[5]: https://github.com/tinyalsa/tinyalsa

## Description

The script collection at hand looks for an audio device featuring a linear
mixer control for playback volume. Additionally, it sets up a background
process which listens for input device events (e.g. from the Fire TV Remote or
another USB device) using the `getevent` builtin command. This in turn, is used
to control the audio volume.

## Requirements

* [a rooted Fire TV][20]
* [Script Manager - SManager][21]

[20]: http://www.aftvnews.com/start
[21]: https://play.google.com/store/apps/details?id=os.tools.scriptmanager

## Installation

## Licensing

It's available under the terms of the GPLv3.
Please see the included *LICENSE* file for details.

[//]: # ( vim: set ts=2 sts=2 sw=2 tw=0: )
