#!/bin/bash

function _new () {
    if [ -e "$TARGET_FILE" ]; then
        echo "$(warn) Already exit $TARGET_FILE" >&2
        return 1
    fi

    if [ ! -e "$BASE_FOLDER" ]; then
        # TODO: Firt init
        mkdir -p "$BASE_FOLDER"
    else
        latest_year=$(find "$BASE_FOLDER" -maxdepth 1 ! -wholename "$BASE_FOLDER" | sort -nr | head -n1)
        latest_month=$(find "$latest_year" -maxdepth 1 ! -wholename "$latest_year" | sort -nr | head -n1)
        latest_day=$(find "$latest_month" -maxdepth 1 ! -wholename "$latest_month" | sort -nr | head -n1)
        prev_target="$latest_day/todo.txt"
        mkdir -p "$TARGET_FOLDER"
    fi

    touch "$TARGET_FILE"
    if [ -e "$prev_target" ]; then
        grep -e "^- (" >> "$TARGET_FILE" < "$prev_target"
    fi
    return 0
}
