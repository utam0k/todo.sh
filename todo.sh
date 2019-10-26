#!/bin/bash

readonly BASE="$HOME/todo"
readonly YEAR=$(date +"%Y")
readonly MONTH=$(date +"%m")
readonly DAY=$(date +"%d")
readonly TARGET_FOLDER="$BASE/$YEAR/$MONTH/$DAY"
readonly TARGET_FILE="$TARGET_FOLDER/todo.txt"
readonly PROJECT_ROW=4

source common.sh
source new.sh
source open.sh
source add.sh
source memo.sh
source ls.sh

if command [ "$#" -ge 1 ]; then
    subcommand="$1"
    shift

    case $subcommand in
        new) _new ;;
        add)
            if command [ "$#" -eq 3 ]; then
                _add "$1" "$2" "$3"
            else
                echo "add command needs 3 args."
            fi
            ;;
        open) _open ;;
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
        *) echo "Unknown subcommand" ;;
    esac
fi
