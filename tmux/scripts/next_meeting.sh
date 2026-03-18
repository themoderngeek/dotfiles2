#!/bin/bash

# Nerd Font Icons
ICON_CALENDAR="󰃰"
ICON_FOCUS="󱠡"

MAX_TITLE_LENGTH=20
POPUP_STATE_FILE="/tmp/tmux_meeting_popup_shown"

# Get the next event today using icalBuddy
# -n: only future events, -li 1: limit to 1, -nc: no calendar names
# -nrd: no relative dates, -ea: exclude all-day events
# -b "": no bullet prefix, -iep "title,datetime": include only title and datetime
# -po "title,datetime": property order, -df "": no date format (just time)
next_event=$(icalBuddy -n -li 1 -nc -nrd -ea -b "" -iep "title,datetime" -po "title,datetime" -df "" -tf "%H:%M" eventsToday 2>/dev/null)

# If no events, show focus icon
if [ -z "$next_event" ]; then
    echo "$ICON_FOCUS"
    exit 0
fi

# Parse icalBuddy output - first line is title, second line has the time range
title=$(echo "$next_event" | head -1 | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
time_line=$(echo "$next_event" | tail -1 | sed 's/^[[:space:]]*//')

# Extract start time (format: HH:MM - HH:MM)
start_time=$(echo "$time_line" | grep -o '^[0-9]\{2\}:[0-9]\{2\}')

if [ -z "$start_time" ]; then
    echo "$ICON_FOCUS"
    exit 0
fi

# Calculate minutes until meeting
start_hour=${start_time%%:*}
start_min=${start_time##*:}
now_epoch=$(date +%s)
start_epoch=$(date -j -f "%H:%M" "$start_time" +%s 2>/dev/null)

if [ -z "$start_epoch" ]; then
    echo "$ICON_FOCUS"
    exit 0
fi

diff_min=$(( (start_epoch - now_epoch) / 60 ))

# Show a tmux popup 10 minutes before the meeting
# Use a state file keyed by meeting title+time to only show once per meeting
popup_key="${title}_${start_time}"
popup_shown=""
if [ -f "$POPUP_STATE_FILE" ]; then
    popup_shown=$(cat "$POPUP_STATE_FILE")
fi

if [ "$diff_min" -ge 0 ] && [ "$diff_min" -le 10 ] && [ "$popup_shown" != "$popup_key" ]; then
    echo "$popup_key" > "$POPUP_STATE_FILE"

    # Get full event details for the popup
    full_event=$(icalBuddy -n -li 1 -nc -nrd -ea -b "" -iep "title,datetime,location,notes" -po "title,datetime,location,notes" -df "" -tf "%H:%M" eventsToday 2>/dev/null)

    end_time=$(echo "$time_line" | grep -o '[0-9]\{2\}:[0-9]\{2\}$')
    location=$(echo "$full_event" | sed -n '3p' | sed 's/^[[:space:]]*//')
    notes=$(echo "$full_event" | sed -n '4p' | sed 's/^[[:space:]]*//')

    popup_text="$ICON_CALENDAR  $title\n\n"
    popup_text+="  Time: ${start_time}"
    [ -n "$end_time" ] && popup_text+=" - ${end_time}"
    popup_text+="\n"
    [ -n "$location" ] && popup_text+="  Location: ${location}\n"
    [ -n "$notes" ] && popup_text+="  Notes: ${notes}\n"
    popup_text+="\n  Starting in ${diff_min} minutes"

    tmux display-popup -w 50% -h 40% -S "fg=#b4befe" -s "bg=#1e1e2e,fg=#cdd6f4" -T " Upcoming Meeting " \
        "printf '${popup_text}'; read -n 1 -s -r -p ''" &
fi

# Format relative time
if [ "$diff_min" -le 0 ]; then
    relative="now"
elif [ "$diff_min" -lt 60 ]; then
    relative="in ${diff_min}m"
else
    hours=$(( diff_min / 60 ))
    mins=$(( diff_min % 60 ))
    if [ "$mins" -eq 0 ]; then
        relative="in ${hours}h"
    else
        relative="in ${hours}h ${mins}m"
    fi
fi

# Truncate long titles
if [ ${#title} -gt $MAX_TITLE_LENGTH ]; then
    title="${title:0:$((MAX_TITLE_LENGTH - 1))}…"
fi

echo "$ICON_CALENDAR $title $relative"
