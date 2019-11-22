#!/bin/bash

function _diff() {
    check_is_exit_file "$TARGET_FILE"

    while getopts "y:m:d:" opts
    do
        case $opts in
            y) require_year=$OPTARG ;;
            m) require_month=$OPTARG ;;
            d) require_day=$OPTARG ;;
            *) echo "usage: diff [-y year] [-m month] [-d day]"
               exit 1 ;;
        esac
    done
    shift $((OPTIND - 1))

    if [ "$require_year" ]; then
        prev_year="$BASE_FOLDER/$require_year"
    else
        prev_year=$(find "$BASE_FOLDER" -maxdepth 1 ! -wholename "$BASE_FOLDER" | sort -nr | head -n1 | tail -n1)
    fi
    if [ "$require_month" ]; then
        prev_month="$prev_year/$require_month"
    else
        prev_month=$(find "$prev_year" -maxdepth 1 ! -wholename "$prev_year" | sort -nr | head -n1 | tail -n1)
    fi
    if [ "$require_day" ]; then
        prev_day="$prev_month/$require_day"
    else
        prev_day=$(find "$prev_month" -maxdepth 1 ! -wholename "$prev_month" | sort -nr | head -n2 | tail -n1)
    fi
    prev_target="$prev_day/todo.txt"
    check_is_exit_file "$prev_target"

    local todos=() prev_todos=()
    while IFS='' read -r line; do todos+=("$line"); done < <(sort -k 2 < "$TARGET_FILE")
    while IFS='' read -r line; do prev_todos+=("$line"); done < <(sort -k 2 < "$prev_target")

    local intersection=() diff=()
    while IFS='' read -r line; do intersection+=("$line"); done < <(for item in "${todos[@]}" "${prev_todos[@]}"; do echo "$item"; done | sort | uniq -d)
    while IFS='' read -r line; do diff+=("$line"); done < <(for item in "${todos[@]}" "${intersection[@]}"; do echo "$item"; done | sort | uniq -u)

    for t in "${diff[@]}"; do printf "%s\n" "$t"; done

    return 0
}
