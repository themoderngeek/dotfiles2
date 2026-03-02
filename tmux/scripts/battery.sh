#!/bin/bash

# Store the output of the battery status command
battery_info=$(pmset -g batt)

# Check if the output contains 'AC Power'
if echo "$battery_info" | grep -q "'AC Power'"; then
    # Print a Nerd Font lightning bolt icon (fa-bolt)
    echo "󰚥"
else
    # Extract the percentage using grep (looks for numbers followed by %)
    percentage=$(echo "$battery_info" | grep -o '[0-9]\+%' | head -1)
    
    # Print the percentage alongside a Nerd Font heart icon (fa-heart)
    echo "$percentage "
fi
