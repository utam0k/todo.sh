#!/bin/bash

readonly BUILD_FILE="$1"
already_sourced=()

shopt -s expand_aliases
if sed --version 2>/dev/null | grep -q GNU; then
  alias sedi='sed -i '
else
  alias sedi='sed -i "" '
fi

function replace () {
    target_lines=()
    while IFS='' read -r line; do target_lines+=("$line"); done < <(grep -n source "$BUILD_FILE")
    if [ ${#target_lines[@]} -eq 0 ]; then
        echo "Concat finished." >&2
    else
        line="${target_lines[0]}"
        n=$(echo "$line" | cut -d : -f 1)
        file=$(echo "$line" | cut -d : -f 2 | awk '{print $2}')
        for already_file in "${already_sourced[@]}"; do
            if [[ "$already_file" = "$file" ]]; then
                echo "[Warn] Already sourced $file." >&2
                sedi -e "$(( n ))d" "$BUILD_FILE"
                replace
                return 0
            fi
        done

        if [ ! -e "$file" ]; then
            echo "[Error!] Not found $file." >&2
            return 1
        fi
        sedi -e "$(( n ))d" -e "$(( n - 1 ))r $file" "$BUILD_FILE"
        already_sourced+=("$file")
        replace
    fi
}

cp todo.sh "$BUILD_FILE"
replace
