#!/system/bin/sh
# set_volume.sh
#
# Copyright (c) 2016 Ingo Bressler (dev@ingobressler.net)
#
# This file is part of the FireSound scripts,
# licensed under the terms of the GPLv3.

# volume control based on tinyalsa (tinymix):
# looks for cards in /proc/asound/card* having mixer controls
# with 'playback' & 'volume' in the name and a value range

TINYMIX=tinymix
if ! $TINYMIX > /dev/null 2>&1; then
  echo "$TINYMIX was not found! aborting."
  exit 1
fi

set_volume()
{
  local VALUE="$(echo "$1" | grep -oE '[0-9]+')"
  if echo "$1" | grep -q '^\+'; then
    # given value starts with +
    adjust_volume + $VALUE
  elif echo "$1" | grep -q '^\-'; then
    # given value starts with -
    adjust_volume - $VALUE
  elif [ ! -z "$VALUE" ]; then
    adjust_volume = $VALUE
  else
    usage
  fi
}

usage ()
{
  echo "Please provide a percentage between 0 and 100 or a step up/down:"
  echo "USAGE: $CMD <volume percentage>"
  echo "       $CMD +<step>"
  echo "       $CMD -<step>"
  exit 1
}

get_controls()
{
  # get all relevant cards instead, not only playback
  for CARD in $(cd /proc/asound; ls -d card* | grep -o '[0-9]'); do
    [ -z "$CARD" ] && continue
    # use only mixer controls with 'playback'&'volume' in the name
    # alternatively, check for mixer controls with a 'range'
    local MIXERCTRL="$($TINYMIX -D $CARD | grep -i playback | grep -i volume | grep -o '^[0-9]')"
    [ -z "$MIXERCTRL" ] && continue
    local RANGESTR="$($TINYMIX -D $CARD $MIXERCTRL | grep -Eo '[0-9]+->[0-9]+')"
    [ -z "$RANGESTR" ] && continue
    local MIN="$(echo $RANGESTR | grep -oE '^[0-9]+')"
    local MAX="$(echo $RANGESTR | grep -oE '[0-9]+$')"
    echo "$CARD:$MIXERCTRL:$MIN:$MAX"
  done
  # another one for testing multiples
  # echo "2:6:1:49"
}

init_volume_control()
{
  CONTROLS="$(get_controls)" # get available controls once
  if [ -z "$CONTROLS" ]; then
    echo "No useable volume controls found! aborting."
    exit 1
  fi
  adjust_volume = 20 # set initial volume to 20%
}

adjust_volume()
{
  local OP="$1"
  # given percentage by command line argument
  local PERCENT="$2"
  if [ -z "$PERCENT" ] || [ "$PERCENT" -lt 0 ] || [ "$PERCENT" -gt 100 ]; then
    usage
  fi
  for ctrl in $CONTROLS; do
    # split mixer info values
    local IFS=':'
    set -A tuple $ctrl
    local CARD="${tuple[0]}"
    local MIXERCTRL="${tuple[1]}"
    local MIN="${tuple[2]}"
    local MAX="${tuple[3]}"
    local RANGE="$(($MAX-$MIN))"
    local VALUE="$(($RANGE*$PERCENT/100))"
    local CURRENT="$($TINYMIX -D $CARD $MIXERCTRL \
                     | grep -oE ': [0-9]+' | grep -oE '[0-9]+')"
    case "$OP" in
      =) $TINYMIX -D $CARD $MIXERCTRL $VALUE;;
      +) $TINYMIX -D $CARD $MIXERCTRL $(($CURRENT+$VALUE));;
      -) $TINYMIX -D $CARD $MIXERCTRL $(($CURRENT-$VALUE));;
    esac
    $TINYMIX -D $CARD $MIXERCTRL
  done
}

CMD="$0"
if [ ! -z "$@" ]; then
  # there were arguments, do something actually
  # otherwise, got source'd elsewhere
  init_volume_control
  set_volume $@
  exit 0
fi

# vim: set ts=2 sts=2 sw=2 tw=0:
