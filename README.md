# FireSound
*Volume control for USB Audio devices on Amazon Fire TV*

## Motivation

The [Fire TV][0] outputs the audio signal along to the video signal over
[HDMI][1] by default. Therefore, if a display is used which does not support
audio over HDMI, such as a computer monitor, there won't be any sound.
[0]: https://en.wikipedia.org/wiki/Amazon_Fire_TV
[1]: https://en.wikipedia.org/wiki/HDMI

On the other hand, the Fire TV box offers a [USB][2] port which can be used
for external audio devices, such as speakers or head phones. Luckily, the
[Android][3] based software which runs on the Fire TV ([Fire OS][4]) supports
audio output via USB, but with a snag: The is no user interface for volume
control.
The default output of digital audio via HDMI does not need (or support?) any
volume control, respectively mixing.
[2]: https://en.wikipedia.org/wiki/USB
[3]: https://en.wikipedia.org/wiki/Android_(operating_system)
[4]: https://en.wikipedia.org/wiki/Fire_OS

## Description

There is one script `listen_fireremote.sh` which listens for Fire TV Remote
events. Button presses of *UP* or *DOWN* while holding the *MENU* button
increases or decreases the volume.

Another script `listen_soundbar.sh` listens for wheel events of the
[Dell AC511 SoundBar][10] in order to increase or decrease the volume.

Currently, volume control is supported for USB audio devices only.
HDMI is not supported because the author does not have access to an HDMI
receiver with audio support for testing.

This volume control is carried out on a rather low level of the system and
is expected to work everywhere, across all apps.

[10]: http://accessories.dell.com/sna/productdetail.aspx?sku=318-2885

## Requirements

* [a rooted Fire TV][20]
* [Script Manager - SManager][21] app

[20]: http://www.aftvnews.com/start
[21]: https://play.google.com/store/apps/details?id=os.tools.scriptmanager

## Disclaimer

As usual, please be careful: these scripts run as root with nearly maximum
privileges and thus might break your Fire TV! They work for the author but
might fail elsewhere. Make sure to review the code before running it.

## Installation

1. Get the latest release package **LINK**.
2. Extract it to a path somewhere in `/data/media/0` on your Fire TV box.
3. Set up one or both of the event listening scripts to be started at boot
   time with superuser permissions as shown below:

![listening Fire TV Remote set up][31]

![listening SoundBar wheel set up][32]

[31]: https://raw.githubusercontent.com/ibressler/firesound/master/doc/listen_fireremote_800.png
[32]: https://raw.githubusercontent.com/ibressler/firesound/master/doc/listen_soundbar_800.png

## Implementation

The underlying Android system is based on a minimal Linux which
supports audio mixing via the [tinyALSA][5] tools.
Specifically on Android, `tinymix` can be used for this purpose.
[5]: https://github.com/tinyalsa/tinyalsa

The script collection at hand uses the `tinymix` program to find an audio
device which provides a linear playback volume mixer control.

Additionally, it sets up a background process querying the `getevent` builtin
command for certain user input events, for example from the Fire TV Remote or
another USB device.
This in turn, is used to control the initially determined playback volume via
`tinymix`.

## Licensing

This tool is available under the terms of the GPLv3.
Please see the included *LICENSE* file for details.

[//]: # ( vim: set ts=2 sts=2 sw=2 tw=0: )
