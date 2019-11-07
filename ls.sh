#!/bin/bash

function tab() {
    printf "  "
    return 0
}

function _ls () {
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
        prevParent=""
        pos=0
        projects=()
        # shellcheck disable=SC2086
        while IFS='' read -r line; do projects+=("$line"); done < <(printf "%s\n" "${todos[@]}" | awk '{ print $'${PROJECT_ROW}' }' | sort | uniq)
        for proj in "${projects[@]}"; do
            remainders=("${todos[@]:$pos}")
            if include_subproject "$proj" > /dev/null; then
                parent=$(echo "$proj" | cut -d '+' -f 1)
                sub=$(echo "$proj" | cut -d '+' -f 2)
                if [ "$prevParent" == "" ]; then
                    output+="$parent\n"
                elif [ "$prevParent" != "$parent" ]; then
                    output+="$parent\n"
                fi
                output+="$(tab)$sub\n"
                for t in "${remainders[@]}"; do
                    if [ "$(echo "$t" | awk '{ print $'${PROJECT_ROW}' }')" == "$parent+$sub" ]; then
                        pos=$((pos + 1))
                        output+="$(tab)$(tab)$t\n"
                    fi
                done
            else
                output+="$proj\n"
                for t in "${remainders[@]}"; do
                    # shellcheck disable=SC2086
                    if [ "$(echo "$t" | awk '{ print $'${PROJECT_ROW}' }')" == "$proj" ]; then
                        pos=$((pos + 1))
                        output+="$(tab)$t\n"
                    fi
                done
            fi
            prevParent="$parent"
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

