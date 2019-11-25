#!/bin/bash
set -e

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

    all=$(find "$BASE_FOLDER" -name "todo.txt" | sort -rM )
    start_n=$(echo "$all" | grep -n "$start_target" | awk '{print $1}' | cut -d':' -f 1 | head)
    end_n=$(echo "$all" | grep -n "$end_target" | awk '{print $1}' | cut -d':' -f 1 | head)

    local intersection=() diff=()
    for i in $(seq $((end_n+1)) $start_n); do
        local before_todos=() after_todos=()
        before=$(find "$BASE_FOLDER" -name "todo.txt" | sort -rM | head -n$i | tail -n1)
        after=$(find "$BASE_FOLDER" -name "todo.txt" | sort -rM | head -n$((i+1)) | tail -n1)
        while IFS='' read -r line; do before_todos+=("$line"); done < <(sort -k 2 < "$before")
        while IFS='' read -r line; do after_todos+=("$line"); done < <(sort -k 2 < "$after")

        intersection=()
        while IFS='' read -r line; do intersection+=("$line"); done < <(for item in "${before_todos[@]}" "${after_todos[@]}"; do echo "$item"; done | sort | uniq -d)
        while IFS='' read -r line; do diff+=("$line"); done < <(for item in "${before_todos[@]}" "${intersection[@]}"; do echo "$item"; done | sort | uniq -u)
    done

    for t in "${diff[@]}"; do printf "%s\n" "$t"; done | sort -k 4 | uniq

    return 0
}
