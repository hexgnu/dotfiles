#!/usr/bin/env bash

# Get the current default sink
current_sink=$(pactl info | grep 'Default Sink' | sed 's/Default Sink: //')

# List all available sinks and their IDs
readarray -t sink_names < <(pactl list short sinks | awk '{print $2}')

# Find the index of the current sink
current_index=-1
for i in "${!sink_names[@]}"; do
    if [[ "${sink_names[i]}" == "$current_sink" ]]; then
        current_index=$i
        break
    fi
done

# Calculate the next sink index (wrap around)
next_index=$(( (current_index + 1) % ${#sink_names[@]} ))

# Set the next sink as the default

pactl set-default-sink "${sink_names[next_index]}"

# Optional: Notify user of the switch
notify-send "Audio Output" "Switched to: ${sink_names[next_index]}"
