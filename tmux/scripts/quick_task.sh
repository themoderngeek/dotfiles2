#!/bin/bash

# Quick Task — create a new task in an Obsidian Area or the Areas Inbox

AREAS_DIR="/Users/marktaylor/Documents/Mark-Projects/02 - Areas"

# Catppuccin Mocha colors
RESET="\033[0m"
BOLD="\033[1m"
GREEN="\033[38;2;166;227;161m"
PINK="\033[38;2;245;194;231m"
LAVENDER="\033[38;2;180;190;254m"
SKY="\033[38;2;137;220;235m"
TEXT="\033[38;2;205;214;244m"
SUBTEXT="\033[38;2;166;173;200m"
OVERLAY="\033[38;2;108;112;134m"
RED="\033[38;2;243;139;168m"
YELLOW="\033[38;2;249;226;175m"
PEACH="\033[38;2;250;179;135m"

ICON_TASK="󰄵"
ICON_CHECK="󰄬"
ICON_WRITE="󰏫"

echo ""
echo -e "  ${LAVENDER}${BOLD}${ICON_TASK}  Quick Task${RESET}"
echo -e "  ${OVERLAY}────────────────────────────${RESET}"
echo ""

# Prompt for title
echo -ne "  ${SKY}${ICON_WRITE}  Title: ${RESET}"
read -r TITLE

if [ -z "$TITLE" ]; then
    echo -e "\n  ${RED}No title provided. Exiting.${RESET}\n"
    exit 1
fi

# Build area list
AREAS=()
while IFS= read -r dir; do
    AREAS+=("$(basename "$dir")")
done < <(find "$AREAS_DIR" -mindepth 1 -maxdepth 1 -type d ! -name "Inbox" | sort)

# Display areas
echo ""
echo -e "  ${LAVENDER}${BOLD}  Areas:${RESET}"
echo -e "  ${OVERLAY}  0) ${SUBTEXT}Inbox (no area)${RESET}"
for i in "${!AREAS[@]}"; do
    echo -e "  ${OVERLAY}  $((i + 1))) ${TEXT}${AREAS[$i]}${RESET}"
done
echo ""
echo -ne "  ${SKY}   Area: ${RESET}${SUBTEXT}(number, default 0) ${RESET}"
read -r AREA_CHOICE

AREA_CHOICE=${AREA_CHOICE:-0}

if [ "$AREA_CHOICE" -eq 0 ] 2>/dev/null; then
    TARGET_DIR="${AREAS_DIR}/Inbox"
    AREA_VALUE=""
else
    IDX=$((AREA_CHOICE - 1))
    if [ "$IDX" -ge 0 ] && [ "$IDX" -lt "${#AREAS[@]}" ]; then
        TARGET_DIR="${AREAS_DIR}/${AREAS[$IDX]}"
        AREA_VALUE="${AREAS[$IDX]}"
    else
        echo -e "\n  ${RED}Invalid selection. Exiting.${RESET}\n"
        exit 1
    fi
fi

# Prompt for priority
echo ""
echo -e "  ${LAVENDER}${BOLD}  Priority:${RESET}"
echo -e "  ${OVERLAY}  1) ${TEXT}Low${RESET}"
echo -e "  ${OVERLAY}  2) ${PEACH}Medium${RESET}"
echo -e "  ${OVERLAY}  3) ${RED}High${RESET}"
echo ""
echo -ne "  ${SKY}   Priority: ${RESET}${SUBTEXT}(number, default 2) ${RESET}"
read -r PRIORITY_CHOICE

case "${PRIORITY_CHOICE:-2}" in
    1) PRIORITY="Low" ;;
    3) PRIORITY="High" ;;
    *) PRIORITY="Medium" ;;
esac

# Prompt for due date
echo ""
echo -ne "  ${SKY}   Due date: ${RESET}${SUBTEXT}(YYYY-MM-DD, optional) ${RESET}"
read -r DUE_INPUT

DUE_VALUE=""
if [ -n "$DUE_INPUT" ]; then
    DUE_VALUE="${DUE_INPUT}T00:00:00"
fi

# Prompt for description
echo -ne "  ${SKY}   Description: ${RESET}${SUBTEXT}(optional) ${RESET}"
read -r DESCRIPTION

# Build area frontmatter
AREA_YAML=""
if [ -n "$AREA_VALUE" ]; then
    AREA_YAML=$'\n  - '"${AREA_VALUE}"
fi

FILENAME="${TITLE}.md"
FILEPATH="${TARGET_DIR}/${FILENAME}"

if [ -f "$FILEPATH" ]; then
    echo -e "\n  ${RED}A task with that title already exists.${RESET}\n"
    exit 1
fi

cat > "$FILEPATH" << EOF
---
Type:
  - Task
Status:
  - To Do
Priority:
  - ${PRIORITY}
Due: ${DUE_VALUE}
tags:
Cover:
Description: ${DESCRIPTION}
Topics:
Parent:
Project:
Area:${AREA_YAML}
---
EOF

echo ""
echo -e "  ${GREEN}${ICON_CHECK}  Task created: ${TEXT}${FILENAME}${RESET}"
echo -e "  ${SUBTEXT}  Priority: ${PEACH}${PRIORITY}${RESET}"
[ -n "$DUE_VALUE" ] && echo -e "  ${SUBTEXT}  Due: ${YELLOW}${DUE_INPUT}${RESET}"
if [ -n "$AREA_VALUE" ]; then
    echo -e "  ${SUBTEXT}  Area: ${LAVENDER}${AREA_VALUE}${RESET}"
else
    echo -e "  ${SUBTEXT}  Area: ${OVERLAY}Inbox${RESET}"
fi
echo -e "  ${SUBTEXT}  ${OVERLAY}${FILEPATH}${RESET}"
echo ""
