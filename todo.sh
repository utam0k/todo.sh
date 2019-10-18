#!/bin/bash

readonly BASE="$HOME/todo"
readonly YEAR=$(date +"%Y")
readonly MONTH=$(date +"%m")
readonly DAY=$(date +"%d")
readonly TARGET_FOLDER="$BASE/$YEAR/$MONTH/$DAY"
readonly TARGET_FILE="$TARGET_FOLDER/todo.txt"
readonly PROJECT_ROW=4

source common.sh

function _new () {
    if [ ! -e "$TARGET_FOLDER" ]; then
        mkdir -p "$TARGET_FOLDER"
    fi

    prev_target="$BASE/$(date -v -1d "+%Y/%m/%d")/todo.txt"
    if [ ! -e "$TARGET_FILE" ]; then
        touch "$TARGET_FILE"
        if [ -e "$prev_target" ]; then
            grep -e "^- (" >> "$TARGET_FILE" < "$prev_target"
        fi
    else
        echo "Error! Already exit $TARGET_FILE"
    fi
    return 0
}

function _add() {
    if command [ "$#" -ne 3 ]; then
        return 1
    fi

    # TODO: Define format function and tests.
    echo "- ($1) $(date +"%Y-%m-%d") $2 $3" >> "TARGET_FILE"
    return 0
}

function _memo() {
    todos=()
    while IFS='' read -r line; do todos+=("$line"); done < <(_ls)
    if [ "$#" -ne 1 ]; then
        _ls
        read -r n
    else
        n="$1"
    fi

    todoname=$(echo "${todos[$n]}" | awk '{print $5}')
    nvim "$TARGET_FOLDER/$todoname.md"
    return 0
}

function _open () {
    nvim  "$TARGET_FILE"
    return 0
}

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

if command [ "$#" -ge 1 ]; then
    subcommand="$1"
    shift

    case $subcommand in
        new)
            _new
            ;;
        add)
            if command [ "$#" -eq 3 ]; then
                _add "$1" "$2" "$3"
            else
                echo "add command needs 3 args."
            fi
            ;;
        open)
            _open
            ;;
        memo)
            if [ "$#" -ne 1 ]; then
                _memo
            else
                _memo "$1"
            fi
            ;;
        ls)
            while getopts "ap" OPT
            do
                case $OPT in
                    p) P_FLG=1 ;;
                    a) A_FLG=1 ;;
                    *) echo "usage: $subcommand [-p] [-a]" >&2
                       exit 1 ;;
                esac
            done
            shift $(( OPTIND - 1 ))
            _ls
            ;;
        *)
            echo "Unknown subcommand"
    esac
fi
