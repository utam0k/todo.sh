#!/bin/bash

function tab() {
    printf "  "
    return 0
}

function search_todos_from_project() {
    local proj="$1"
    shift $(( OPTIND - 1 ))
    local todos=("$@")
    local index=0
    local output=""
    for t in "${todos[@]}"; do
        if [ "$(extract_project "$t")" == "$proj" ]; then
            output+="$index "
        fi
        index=$((index + 1))
    done

    printf "%b" "$output"
    return 0
}

function _ls () {
    while getopts "ap" OPT
    do
        case $OPT in
            p) P_FLG=1 ;;
            a) A_FLG=1 ;;
            *) echo "usage: ls [-p] [-a]" >&2
                exit 1 ;;
        esac
    done
    shift $(( OPTIND - 1 ))
    check_is_exit_file "$TARGET_FILE"

    todos=()
    output=""
    if [ "$A_FLG" ]; then
        if [ "$P_FLG" ]; then
            sort_key="4,4"
        else
            sort_key="2"
        fi
        while IFS='' read -r line; do todos+=("$line"); done < <(sort -k "$sort_key" < "$TARGET_FILE")
    else
        while IFS='' read -r line; do todos+=("$line"); done < <(grep "$TARGET_FILE" -e "^- *" | sort -k 4,4)
    fi

    if [ "$P_FLG" ]; then
        prev_parent=""
        pos=0
        projects=(); while IFS='' read -r line; do projects+=("$line"); done < <(extract_projects "${todos[@]}" | sort | uniq)
        for proj in "${projects[@]}"; do
            remainders=("${todos[@]:$pos}")
            if include_subproject "$proj" > /dev/null; then
                parent=$(echo "$proj" | cut -d '+' -f 1)
                sub=$(echo "$proj" | cut -d '+' -f 2)
                if [ "$prev_parent" == "" ] || [ "$prev_parent" != "$parent" ]; then
                    output+="$parent\n"
                fi
                output+="$(tab)$sub\n"
                indexs=$(search_todos_from_project "$parent+$sub" "${remainders[@]}")
            else
                output+="$proj\n"
                indexs=$(search_todos_from_project "$proj" "${remainders[@]}")
            fi
            num=$(printf "%s" "$indexs" | wc -w)
            for index in $indexs; do
                output+="$(tab)$(tab)${remainders[$index]}\n"
            done
            pos=$((pos + num))
            prev_parent="$parent"
        done
        printf "%b" "$output"
    else
        len=${#todos[@]}
        digits=${#len}
        for (( i=0; i<${#todos[@]}; i++ )) do
            output+="$(printf "%0${digits}d %s" "$i" "${todos[$i]}")\n"
        done
        printf "%b" "$output"
    fi
    return 0
}

