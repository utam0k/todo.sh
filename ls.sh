#!/bin/bash

function _ls () {
    todos=()
    if [ "$A_FLG" ]; then
        # TODO: -ap
        while IFS='' read -r line; do todos+=("$line"); done < <(sort -k 2 < "$TARGET_FILE")
    else
        while IFS='' read -r line; do todos+=("$line"); done < <(grep "$TARGET_FILE" -e "^- *" | sort -k 2)
    fi

    if [ "$P_FLG" ]; then
        prevParent=""
        projects=()
        # shellcheck disable=SC2086
        while IFS='' read -r line; do projects+=("$line"); done < <(grep "$TARGET_FILE" -e "^- *" | awk '{ print $'${PROJECT_ROW}' }' | sort | uniq)
        for proj in "${projects[@]}"; do
            if include_subproject "$proj" > /dev/null; then
                parent=$(echo "$proj" | cut -d '+' -f 1)
                sub=$(echo "$proj" | cut -d '+' -f 2)
                if [ "$prevParent" == "" ]; then
                    echo "$parent"
                elif [ "$prevParent" != "$parent" ]; then
                    echo "$parent"
                fi
                echo "  $sub"
                for t in "${todos[@]}"; do
                    if echo "$t" | grep -e "^-.*$parent+$sub" > /dev/null; then
                        echo "    $t"
                    fi
                done
            else
                echo "$proj"
                for t in "${todos[@]}"; do
                    # shellcheck disable=SC2086
                    if [ "$(echo "$t" | grep -e "^- *" | awk '{ print $'${PROJECT_ROW}' }')" == "$proj" ]; then
                        echo "  $t"
                    fi
                done
            fi
            prevParent="$parent"
        done
    else
        for (( i=0; i<${#todos[@]}; i++ )) do
            echo "$i ${todos[$i]}"
        done
    fi
    return 0
}

