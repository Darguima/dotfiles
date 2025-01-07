#!/bin/bash

# In case of multiple headphones, choose by my preference
choose_headphones() {
    # To get all the sinks and ports names > pactl list sinks
    sorted_headphones=(
        "bluez_output.74_2A_8A_D2_4D_03.a2dp-sink"
        "bluez_output.C8_2B_6B_0F_55_68.1"
        "Microsoft_LifeChat_LX-3000-00"
    )

    available_sinks=($(pactl list sinks short | awk '{print $2}'))

    # Return variable
    ChoosenHeadphone=""

    for cur_headphone in "${sorted_headphones[@]}"; do
        for cur_sink in "${available_sinks[@]}"; do
            if [[ $cur_sink == *"$cur_headphone"* ]]; then
                ChoosenHeadphone="$cur_sink"
                return 0
            fi
        done
    done
}

# change_output <sink> <port>
change_output() {
    # Change Sink
    sink=$1
    if [ -n "$sink" ]; then
        pactl set-default-sink "$sink" || echo "Failed to change sink to $sink"
    else
        return 1
    fi

    # Change Sink Port
    port=$2
    if [ -n "$port" ]; then
        pactl set-sink-port "$sink" "$port" || echo "Failed to change port to $port"
    fi
}

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <speakers|headphones>"
    exit 1
fi

device=$1

# To get all the sinks and ports names > pactl list sinks
if [ "$device" == "speakers" ]; then
    change_output "alsa_output.pci-0000_09_00.4.analog-stereo" "analog-output-lineout"
elif [ "$device" == "headphones" ]; then
    choose_headphones # Will return in ChoosenHeadphone variable
    change_output "$ChoosenHeadphone"
else
    echo "Invalid device. Please choose 'speakers' or 'headphones'."
    exit 1
fi

echo "PipeWire output changed to $device."
