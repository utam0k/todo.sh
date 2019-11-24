#!/bin/bash

function _diff() {
    local end_target start_date
    if [ "$#" -eq 1 ]; then
        start_date=$(date -j -f "%Y-%m-%d" "$1" "+%Y/%m/%d")
        start_target="$BASE_FOLDER/$start_date/todo.txt"
        end_target="$TARGET_FILE"
    elif [ "$#" -eq 2 ]; then
        start_date=$(date -j -f "%Y-%m-%d" "$1" "+%Y/%m/%d")
        end_date=$(date -j -f "%Y-%m-%d" "$2" "+%Y/%m/%d")
        start_target="$BASE_FOLDER/$start_date/todo.txt"
        end_target="$BASE_FOLDER/$end_date/todo.txt"
    else
        start_year=$(find "$BASE_FOLDER" -maxdepth 1 ! -wholename "$BASE_FOLDER" | sort -nr | head -n1 | tail -n1)
        start_month=$(find "$start_year" -maxdepth 1 ! -wholename "$start_year" | sort -nr | head -n1 | tail -n1)
        start_day=$(find "$start_month" -maxdepth 1 ! -wholename "$start_month" | sort -nr | head -n2 | tail -n1)
        start_date=${start_day#$BASE_FOLDER/}
        end_date=$(date +'%Y/%m/%d')
        start_target="$start_day/todo.txt"
        end_target=$TARGET_FILE
    fi
    check_is_exit_file "$start_target"
    check_is_exit_file "$end_target"
    printf "%s...%s\n" "$start_date" "$end_date" >&2

    local todos=() start_todos=()
    while IFS='' read -r line; do todos+=("$line"); done < <(sort -k 2 < "$end_target")
    while IFS='' read -r line; do start_todos+=("$line"); done < <(sort -k 2 < "$start_target")

    local intersection=() diff=()
    while IFS='' read -r line; do intersection+=("$line"); done < <(for item in "${todos[@]}" "${start_todos[@]}"; do echo "$item"; done | sort | uniq -d)
    while IFS='' read -r line; do diff+=("$line"); done < <(for item in "${todos[@]}" "${intersection[@]}"; do echo "$item"; done | sort | uniq -u)

    for t in "${diff[@]}"; do printf "%s\n" "$t"; done

    return 0
}
