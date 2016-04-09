#!/system/bin/sh
# listen_fireremote.sh
#
# Copyright (c) 2016 Ingo Bressler (dev@ingobressler.net)
#
# This file is part of the FireSound scripts,
# licensed under the terms of the GPLv3.

# adjusts the volume at a button press event of the fire tv remote

VOL_UP_KEY="KEY_UP"
VOL_DOWN_KEY="KEY_DOWN"
MODIFIER_KEY="KEY_MENU"
DEVICE_NAME="Fire TV Remote"
EVENTPATTERN='KEY_.+[[:space:]]+(UP|DOWN)'

# internal variable holds the current state of the modifier key
MODIFIER=''

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
  echo "  current MODIFIER: '$MODIFIER'"
  [ -z "$MODIFIER" ] && return # abort if modifier button is not pressed
  [ "$STATE" = "UP" ] && return # act only on button down press
  case "$KEY" in
    "$VOL_UP_KEY")   echo ' -> increase'; adjust_volume + 3;;
    "$VOL_DOWN_KEY") echo ' -> decrease'; adjust_volume - 3;;
  esac
}

# directory of this script (and where dependent scripts are expected)
PCKGDIR="${0%/*}"
source "$PCKGDIR"/launcher.sh

# vim: set ts=2 sts=2 sw=2 tw=0:
