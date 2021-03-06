#!/system/bin/sh
# listen_soundbar.sh
#
# Copyright (c) 2016 Ingo Bressler (dev@ingobressler.net)
#
# This file is part of the FireSound scripts,
# licensed under the terms of the GPLv3.

# adjusts the volume at a wheel event of the Dell AC511 sound bar

DEVICE_NAME="SoundBar"
EVENTPATTERN='KEY_.+[[:space:]]+DOWN'

handle_event()
{
  # get the matched line for each event as argument
  local KEYEVENT="$1"
  local ACTION="$(echo "$KEYEVENT" | grep -oE 'VOLUME(UP|DOWN)')"
  echo "  action: '$ACTION'"
  case "$ACTION" in
    VOLUMEUP)   adjust_volume + 3;;
    VOLUMEDOWN) adjust_volume - 3;;
  esac
}

# directory of this script (and where dependent scripts are expected)
PCKGDIR="${0%/*}"
source "$PCKGDIR"/launcher.sh

# vim: set ts=2 sts=2 sw=2 tw=0:
