#!/bin/bash

# Nerd Font Material Design Icons
# (Extracted into variables so you can swap them easily if needed)
ICON_AC=""
ICON_HEART_FULL="󰣐"
ICON_HEART_HALF="󰛞"
ICON_HEART_EMPTY=""

# Store the output of the battery status command
battery_info=$(pmset -g batt)

# Check if the output contains 'AC Power'
if echo "$battery_info" | grep -q "'AC Power'"; then
    echo "$ICON_AC"
else
    # Extract just the number (remove the % sign for math)
    percentage=$(echo "$battery_info" | grep -o '[0-9]\+%' | head -1 | tr -d '%')
    
    # Calculate the hearts (Each heart is 10%)
    full_hearts=$(( percentage / 10 ))
    remainder=$(( percentage % 10 ))
    
    # If the remainder is 5 or more, add a half heart
    if [ "$remainder" -ge 5 ]; then
        half_hearts=1
    else
        half_hearts=0
    fi
    
    # The remaining slots out of 10 become empty hearts
    empty_hearts=$(( 10 - full_hearts - half_hearts ))
    
    # Initialize the empty string for the health bar
    health_bar=""
    
    # 1. Append full hearts
    for ((i=0; i<full_hearts; i++)); do
        health_bar="${health_bar}${ICON_HEART_FULL}"
    done
    
    # 2. Append half heart
    if [ "$half_hearts" -eq 1 ]; then
        health_bar="${health_bar}${ICON_HEART_HALF}"
    fi
    
    # 3. Append empty hearts
    for ((i=0; i<empty_hearts; i++)); do
        health_bar="${health_bar}${ICON_HEART_EMPTY}"
    done
    
    # Print the final health bar alongside the percentage
    echo "$health_bar"
fi
