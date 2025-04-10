#!/bin/bash

check=false
if [ "$1" == "check" ]; then
  check=true
fi

# If the module is activated or deactivated
status="deactivated"

# Get all keyboard input identifiers and store them in an array
keyboard_ids=($(swaymsg -t get_inputs | jq -r '.[] | select(.type == "keyboard") | .identifier'))

# Loop through the array of keyboard ids and toggle their events if not in check mode
if [ "$check" == "false" ]; then
  for id in "${keyboard_ids[@]}"; do
      swaymsg input "$id" events toggle
  done
fi

# Now check if any of the keyboards is deactivated
for id in "${keyboard_ids[@]}"; do
  event_status=$(swaymsg -t get_inputs | jq -r --arg id "$id" '.[] | select(.identifier == $id) | .libinput.send_events')

  if [ "$event_status" = "disabled" ]; then
    status="activated"
    break
  fi
done

echo "{\"class\": \"$status\", \"alt\": \"$status\"}"
