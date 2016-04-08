#!/system/bin/sh
# listen_soundbar.sh
#
# Copyright (c) 2016 Ingo Bressler (dev@ingobressler.net)
#
# This file is part of the FireSound scripts,
# licensed under the terms of the GPLv3.

# adjusts the volume at a wheel event of the Dell AC511 sound bar

source set_volume.sh
source get_events.sh

init_volume_control
echo "Determined control values '$CONTROLS'"

handle_event()
{
  # get the matched line for each event as argument
  local KEYEVENT="$1"
  local ACTION="$(echo "$KEYEVENT" | grep -oE 'VOLUME(UP|DOWN)')"
  case "$ACTION" in
    VOLUMEUP)   echo UP;   adjust_volume + 3;;
    VOLUMEDOWN) echo DOWN; adjust_volume - 3;;
  esac
}

get_events "$(get_eventfile "soundbar")" \
           'KEY_.+[[:space:]]+DOWN' \
           handle_event

exit 0
