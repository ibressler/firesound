#!/system/bin/sh
# common startup code for each event listener,
# finally called by 'source' command

launch_listener()
{
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