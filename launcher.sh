#!/system/bin/sh
# common startup code for each event listener,
# finally called by 'source' command

STARTUPDELAY=10

launch_listener()
{
  # check for package started in /data/media/* path
  local PREFIX='/data/media'
  if ! echo "$PCKGDIR" | grep -q "^$PREFIX/"; then
    echo "Please start this script from within '$PREFIX/*'! aborting."
    exit 1
  fi
  echo -n "Waiting ${STARTUPDELAY}sec to let devices settle ... "
  sleep "$STARTUPDELAY"
  echo "done."
  source "$PCKGDIR"/set_volume.sh
  source "$PCKGDIR"/get_events.sh

  init_volume_control
  echo "Determined control values '$CONTROLS'"

  get_events "$DEVICE_NAME" "$EVENTPATTERN" handle_event
}

if [ -z "$1" ]; then
  # no argument, we got called from on boot-up probably
  # disable output, run in background
  launch_listener > /dev/null &
else
  # with argument, keep output enabled and in foreground
  launch_listener
fi

# vim: set ts=2 sts=2 sw=2 tw=0:
