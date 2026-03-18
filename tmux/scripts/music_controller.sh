#!/bin/bash

# Catppuccin Mocha colors via ANSI escapes
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
GREEN="\033[38;2;166;227;161m"
PINK="\033[38;2;245;194;231m"
LAVENDER="\033[38;2;180;190;254m"
SKY="\033[38;2;137;220;235m"
TEXT="\033[38;2;205;214;244m"
SUBTEXT="\033[38;2;166;173;200m"
OVERLAY="\033[38;2;108;112;134m"

# Nerd Font Icons
ICON_PLAY="󰐊"
ICON_PAUSE="󰏤"
ICON_PREV="󰒮"
ICON_NEXT="󰒭"
ICON_VOL_UP="󰕾"
ICON_VOL_DOWN="󰖀"
ICON_MUSIC="󰎈"

get_state() {
    osascript -e 'tell application "Music" to get player state' 2>/dev/null
}

get_track() {
    osascript -e 'tell application "Music" to get name of current track' 2>/dev/null
}

get_artist() {
    osascript -e 'tell application "Music" to get artist of current track' 2>/dev/null
}

get_album() {
    osascript -e 'tell application "Music" to get album of current track' 2>/dev/null
}

get_position() {
    osascript -e 'tell application "Music" to get player position' 2>/dev/null | cut -d. -f1
}

get_duration() {
    osascript -e 'tell application "Music" to get duration of current track' 2>/dev/null | cut -d. -f1
}

get_volume() {
    osascript -e 'tell application "Music" to get sound volume' 2>/dev/null
}

format_time() {
    local secs=$1
    [ -z "$secs" ] && echo "0:00" && return
    printf "%d:%02d" $((secs / 60)) $((secs % 60))
}

draw_progress() {
    local pos=$1
    local dur=$2
    local width=30

    if [ -z "$dur" ] || [ "$dur" -eq 0 ]; then
        printf '%0.s─' $(seq 1 $width)
        return
    fi

    local filled=$(( (pos * width) / dur ))
    [ "$filled" -gt "$width" ] && filled=$width
    local empty=$(( width - filled ))

    local bar=""
    for ((i=0; i<filled; i++)); do bar+="━"; done
    bar+="╸"
    for ((i=0; i<empty; i++)); do bar+="─"; done
    echo "$bar"
}

CLR="\033[K"

render() {
    # Move cursor to top-left and overwrite in place instead of clearing
    printf "\033[H"
    local state=$(get_state)

    if [ "$state" != "playing" ] && [ "$state" != "paused" ]; then
        echo -e "${CLR}"
        echo -e "${OVERLAY}  ${ICON_MUSIC}  No track loaded${RESET}${CLR}"
        echo -e "${CLR}"
        echo -e "${DIM}  [q] quit${RESET}${CLR}"
        # Clear any remaining lines from a previous longer render
        echo -e "${CLR}\n${CLR}\n${CLR}\n${CLR}\n${CLR}"
        return
    fi

    local track=$(get_track)
    local artist=$(get_artist)
    local album=$(get_album)
    local pos=$(get_position)
    local dur=$(get_duration)
    local vol=$(get_volume)

    local state_icon="$ICON_PLAY"
    [ "$state" = "paused" ] && state_icon="$ICON_PAUSE"

    local progress=$(draw_progress "$pos" "$dur")
    local pos_fmt=$(format_time "$pos")
    local dur_fmt=$(format_time "$dur")

    echo -e "${CLR}"
    echo -e "  ${GREEN}${BOLD}${ICON_MUSIC}  ${track}${RESET}${CLR}"
    echo -e "  ${PINK}${artist}${RESET}${SUBTEXT} - ${album}${RESET}${CLR}"
    echo -e "${CLR}"
    echo -e "  ${LAVENDER}${state_icon}${RESET}  ${OVERLAY}${progress}${RESET}  ${SKY}${pos_fmt} / ${dur_fmt}${RESET}${CLR}"
    echo -e "${CLR}"
    echo -e "  ${TEXT}${ICON_VOL_DOWN} ${vol}% ${ICON_VOL_UP}${RESET}${CLR}"
    echo -e "${CLR}"
    echo -e "  ${DIM}[h]${RESET} ${SUBTEXT}prev${RESET}  ${DIM}[space]${RESET} ${SUBTEXT}play/pause${RESET}  ${DIM}[l]${RESET} ${SUBTEXT}next${RESET}  ${DIM}[+/-]${RESET} ${SUBTEXT}vol${RESET}  ${DIM}[q]${RESET} ${SUBTEXT}quit${RESET}${CLR}"
}

# Hide cursor and setup terminal
tput civis
stty -echo 2>/dev/null
trap 'tput cnorm; stty echo 2>/dev/null; exit' EXIT INT TERM

clear
render

while true; do
    # Read a single character with 1 second timeout for refreshing
    if IFS= read -rsn1 -t 1 key; then
        case "$key" in
            ' ')
                osascript -e 'tell application "Music" to playpause' 2>/dev/null
                ;;
            h)
                osascript -e 'tell application "Music" to previous track' 2>/dev/null
                sleep 0.3
                ;;
            l)
                osascript -e 'tell application "Music" to next track' 2>/dev/null
                sleep 0.3
                ;;
            +|=)
                vol=$(get_volume)
                new_vol=$((vol + 10))
                [ "$new_vol" -gt 100 ] && new_vol=100
                osascript -e "tell application \"Music\" to set sound volume to $new_vol" 2>/dev/null
                ;;
            -)
                vol=$(get_volume)
                new_vol=$((vol - 10))
                [ "$new_vol" -lt 0 ] && new_vol=0
                osascript -e "tell application \"Music\" to set sound volume to $new_vol" 2>/dev/null
                ;;
            q)
                exit 0
                ;;
        esac
    fi
    render
done
