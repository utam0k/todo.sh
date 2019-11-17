#!/bin/bash

function _diff() {
    check_is_exit_file "$TARGET_FILE"

    prev_year=$(find "$BASE_FOLDER" -maxdepth 1 ! -wholename "$BASE_FOLDER" | sort -nr | head -n1 | tail -n1)
    prev_month=$(find "$prev_year" -maxdepth 1 ! -wholename "$prev_year" | sort -nr | head -n1 | tail -n1)
    prev_day=$(find "$prev_month" -maxdepth 1 ! -wholename "$prev_month" | sort -nr | head -n2 | tail -n1)
    prev_target="$prev_day/todo.txt"

    todos=()
    prev_todos=()
    while IFS='' read -r line; do todos+=("$line"); done < <(sort -k 2 < "$TARGET_FILE")
    while IFS='' read -r line; do prev_todos+=("$line"); done < <(sort -k 2 < "$prev_target")

    diff=()
    for prev_t in "${prev_todos[@]}"; do
        skip=
        for t in "${todos[@]}"; do
            [[ "$prev_t" == "$t" ]] && { skip=1; break; }
        done
        [[ -n $skip ]] || diff+=("$t")
    done

    for t in "${diff[@]}"; do printf "%s\n" "$t"; done

    return 0
}
