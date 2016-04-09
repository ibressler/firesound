#!/system/bin/sh
# get_events.sh 
#
# Copyright (c) 2016 Ingo Bressler (dev@ingobressler.net)
#
# This file is part of the FireSound scripts,
# licensed under the terms of the GPLv3.

# listens for output of the getevent command
# for a given event device file in /dev/input

STDBUF="$PCKGDIR/stdbuf.so"
#STDBUF="/data/media/0/tools/firesound/stdbuf.so"
DEVPATH='/dev/input'

GETEVENT=getevent
if ! $GETEVENT -p > /dev/null 2>&1; then
  echo "$GETEVENT was not found! aborting."
  exit 1
fi

if [ ! -f "$STDBUF" ]; then
  echo "Binary '$STDBUF' was not found! aborting."
  exit 1
fi

get_eventfile()
{
  [ -z "$1" ] && return
  echo "$(getevent -p \
          | grep -B1 -i "$1" \
          | grep -oE "$DEVPATH/event[0-9]+")"
}

get_events()
{
  local FILE="$(get_eventfile "$1")"
  [ ! -e "$FILE" ] && return
  local FILTER="$2"
  local HANDLER="$3"
  LD_PRELOAD="$STDBUF" getevent -l "$FILE" 2> /dev/null |
  LD_PRELOAD="$STDBUF" grep -oE "$FILTER" 2> /dev/null |
  while read event; do
    "$HANDLER" "$event"
  done
}

