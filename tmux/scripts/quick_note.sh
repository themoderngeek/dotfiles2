#!/bin/bash

# Quick Note — create a new note in the Obsidian Resources Inbox

VAULT_INBOX="/Users/marktaylor/Documents/Mark-Projects/03 - Resources/Inbox"

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

ICON_NOTE="󰎞"
ICON_CHECK="󰄬"
ICON_WRITE="󰏫"

TODAY=$(date +%Y-%m-%d)

echo ""
echo -e "  ${LAVENDER}${BOLD}${ICON_NOTE}  Quick Note${RESET}"
echo -e "  ${OVERLAY}────────────────────────────${RESET}"
echo ""

# Prompt for title
echo -ne "  ${SKY}${ICON_WRITE}  Title: ${RESET}"
read -r TITLE

if [ -z "$TITLE" ]; then
    echo -e "\n  ${RED}No title provided. Exiting.${RESET}\n"
    exit 1
fi

FILENAME="${TITLE}.md"
FILEPATH="${VAULT_INBOX}/${FILENAME}"

if [ -f "$FILEPATH" ]; then
    echo -e "\n  ${RED}A note with that title already exists.${RESET}\n"
    exit 1
fi

# Prompt for tags (optional)
echo -ne "  ${SKY}   Tags: ${RESET}${SUBTEXT}(comma-separated, optional) ${RESET}"
read -r TAGS_INPUT

# Prompt for body
echo -e "  ${SKY}   Body: ${RESET}${SUBTEXT}(enter text, empty line to finish)${RESET}"
BODY=""
while IFS= read -r LINE; do
    [ -z "$LINE" ] && break
    [ -n "$BODY" ] && BODY+=$'\n'
    BODY+="$LINE"
done

# Build tags array for frontmatter
TAGS_YAML=""
if [ -n "$TAGS_INPUT" ]; then
    TAGS_YAML=$'\ntags:'
    IFS=',' read -ra TAG_ARRAY <<< "$TAGS_INPUT"
    for TAG in "${TAG_ARRAY[@]}"; do
        TAG=$(echo "$TAG" | xargs)
        TAGS_YAML+=$'\n  - "'"$TAG"'"'
    done
fi

# Write the note
cat > "$FILEPATH" << EOF
---
title: "${TITLE}"
created: ${TODAY}${TAGS_YAML}
---

${BODY}
EOF

echo ""
echo -e "  ${GREEN}${ICON_CHECK}  Note created: ${TEXT}${FILENAME}${RESET}"
echo -e "  ${SUBTEXT}${FILEPATH}${RESET}"
echo ""
