#!/system/bin/sh
# listen_fireremote.sh
#
# Copyright (c) 2016 Ingo Bressler (dev@ingobressler.net)
#
# This file is part of the FireSound scripts,
# licensed under the terms of the GPLv3.

# adjusts the volume at a button press event of the fire tv remote

source set_volume.sh
source get_events.sh

init_volume_control
echo "Determined control values '$CONTROLS'"

VOL_UP_KEY="KEY_UP"
VOL_DOWN_KEY="KEY_DOWN"
MODIFIER_KEY="KEY_MENU"
MODIFIER='' # holds the current state of the modifier key
handle_event()
{
  # get the matched line for each event as argument
  local KEYEVENT="$1"
  local KEY="$(echo "$KEYEVENT" | grep -oE 'KEY_[A-Z]+')"
  local STATE="$(echo "$KEYEVENT" | grep -oE '[A-Z]+$')"
  echo "$KEY ($STATE)"
  # do something if the left button is pressed
  if [ "$KEY" = "$MODIFIER_KEY" ]; then
    if [ "$STATE" = "DOWN" ]; then
      MODIFIER=on
    elif [ "$STATE" = "UP" ]; then
      MODIFIER=''
    fi
  fi
  [ -z "$MODIFIER" ] && return # abort if modifier button is not pressed
  [ "$STATE" = "UP" ] && return # act only on button down press
  case "$KEY" in
    "$VOL_UP_KEY")   echo UP;   adjust_volume + 3;;
    "$VOL_DOWN_KEY") echo DOWN; adjust_volume - 3;;
  esac
}

get_events "$(get_eventfile "Fire TV Remote")" \
           'KEY_.+[[:space:]]+(UP|DOWN)' \
           handle_event

exit 0
