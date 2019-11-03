#!/bin/bash

function _new () {
    if [ -e "$TARGET_FILE" ]; then
        echo "$(warn) Already exit $TARGET_FILE" >&2
        return 1
    fi

    latest_year=$(find "$BASE" -maxdepth 1 ! -wholename "$BASE" | sort -nr | head -n1)
    latest_month=$(find "$latest_year" -maxdepth 1 ! -wholename "$latest_year" | sort -nr | head -n1)
    latest_day=$(find "$latest_month" -maxdepth 1 ! -wholename "$latest_month" | sort -nr | head -n1)
    prev_target="$latest_day/todo.txt"

    if [ ! -e "$TARGET_FOLDER" ]; then
        mkdir -p "$TARGET_FOLDER"
    fi

    touch "$TARGET_FILE"
    if [ -e "$prev_target" ]; then
        grep -e "^- (" >> "$TARGET_FILE" < "$prev_target"
    fi
    return 0
}
