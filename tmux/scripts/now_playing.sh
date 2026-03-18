#!/bin/bash

# Nerd Font Icons
ICON_MUSIC="󰎈"
ICON_PAUSED="󰏤"

MAX_TRACK_LENGTH=25
MAX_ARTIST_LENGTH=15

# Check if Music app is running
if ! pgrep -x "Music" > /dev/null 2>&1; then
    exit 0
fi

# Get player state
state=$(osascript -e 'tell application "Music" to get player state' 2>/dev/null)

if [ "$state" = "paused" ]; then
    echo "$ICON_PAUSED"
    exit 0
elif [ "$state" != "playing" ]; then
    exit 0
fi

# Get track info
track=$(osascript -e 'tell application "Music" to get name of current track' 2>/dev/null)
artist=$(osascript -e 'tell application "Music" to get artist of current track' 2>/dev/null)

if [ -z "$track" ]; then
    exit 0
fi

# Truncate long names
if [ ${#track} -gt $MAX_TRACK_LENGTH ]; then
    track="${track:0:$((MAX_TRACK_LENGTH - 1))}…"
fi
if [ ${#artist} -gt $MAX_ARTIST_LENGTH ]; then
    artist="${artist:0:$((MAX_ARTIST_LENGTH - 1))}…"
fi

if [ -n "$artist" ]; then
    echo "$ICON_MUSIC $track ($artist)"
else
    echo "$ICON_MUSIC $track"
fi
