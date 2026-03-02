#!/bin/bash

# Store the output of the battery status command
battery_info=$(pmset -g batt)
# Extract the percentage using grep (looks for numbers followed by %)
percentage=$(echo "$battery_info" | grep -o '[0-9]\+%' | head -1)

# Check if the output contains 'AC Power'
if echo "$battery_info" | grep -q "'AC Power'"; then
    # Print a Nerd Font lightning bolt icon (fa-bolt)
    if [[ -z "${percentage}" ]]; then
        echo "100% 󰚥"
    else
        echo "$percentage 󰚥"
    fi
else

    # Print the percentage alongside a Nerd Font heart icon (fa-heart)
    echo "$percentage "
fi
