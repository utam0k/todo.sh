#!/bin/bash

readonly BASE="$HOME/todo"
readonly YEAR=$(date +"%Y")
readonly TODAY=$(date +"%m-%d")
readonly WORKSPACE=$BASE/$YEAR
readonly PROJECT_ROW=4

source common.sh

function _new () {
    if [ ! -e "$WORKSPACE" ]; then
        mkdir -p "$WORKSPACE"
    fi

    latest=$(find "$WORKSPACE" -maxdepth 1 ! -wholename "$WORKSPACE" | sort -nr | head -n1)
    if [ ! -e "$WORKSPACE/$TODAY" ]; then
        touch "$WORKSPACE/$TODAY"
        if [ -e "$latest" ]; then
            grep -e "^- (" >> "$WORKSPACE/$TODAY" < "$latest"
        fi
    else
        echo "Error! Already exit $WORKSPACE/$TODAY"
    fi
    return 0
}

function _add() {
    return 0
}

function _open () {
    nvim  "$WORKSPACE/$TODAY"
    return 0
}

function _ls () {
    IFS=$'\n'
    if [ "$A_FLG" ]; then
        # TODO: -ap
        todos=$(sort -k 2 < "$WORKSPACE/$TODAY")
    else
        todos=$(grep "$WORKSPACE/$TODAY" -e "^- *" | sort -k 2)
    fi
    if [ "$P_FLG" ]; then
        prevParent=""
        projects=$(grep "$WORKSPACE/$TODAY" -e "^- *" | awk '{ print $'${PROJECT_ROW}' }' | sort | uniq)
        for proj in $projects; do
            if include_subproject $proj > 0; then
                parent=$(echo "$proj" | cut -d '+' -f 1)
                sub=$(echo "$proj" | cut -d '+' -f 2)
                if [ "$prevParent" == "" ]; then
                    echo "$parent"
                elif [ "$prevParent" != "$parent" ]; then
                    echo "$parent"
                fi
                echo "  $sub"
                for t in $todos; do
                    if echo "$t" | grep -e "^-.*$parent+$sub" > /dev/null; then
                        echo "    $t"
                    fi
                done
            else
                echo "$proj"
                for t in $todos; do
                    if [ "$(echo "$t" | grep -e "^- *" | awk '{ print $'${PROJECT_ROW}' }')" == "$proj" ]; then
                        echo "  $t"
                    fi
                done
            fi
            prevParent="$proj"
        done
    else
        for t in $todos; do
            echo "$t"
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
            _add
            ;;
        open)
            _open
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
