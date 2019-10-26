#!/bin/bash

aleready_sourced=()
case "${OSTYPE}" in
    freebsd*|darwin*) sed_i_option="-i """ ;;
    linux*) sed_i_option="-i" ;;
esac

function replace () {
    target_lines=()
    while IFS='' read -r line; do target_lines+=("$line"); done < <(grep -n source tmp.sh)
    if [ ${#target_lines[@]} -eq 0 ]; then
        echo "Concat finished." >&2
    else
        line="${target_lines[0]}"
        n=$(echo "$line" | cut -d : -f 1)
        file=$(echo "$line" | cut -d : -f 2 | awk '{print $2}')
        if [[ " ${aleready_sourced[@]} " =~ " ${file} " ]]; then
            echo "[Warn] Already sourced $file." >&2
            sed "$sed_i_option" -e "$(( n ))d" tmp.sh
            replace
            return 0
        fi

        if [ ! -e "$file" ]; then
            echo "[Error!] Not found $file." >&2
            return 1
        fi
        sed "$sed_i_option" -e "$(( n ))d" -e "$(( n - 1 ))r $file" tmp.sh
        aleready_sourced+=("$file")
        replace
    fi
}

cp todo.sh tmp.sh
replace
