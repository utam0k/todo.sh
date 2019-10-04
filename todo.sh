#!/bin/bash

readonly BASE="$HOME/todo"
readonly YEAR=$(date +"%Y")
readonly TODAY=$(date +"%m-%d")
readonly WORKSPACE=$BASE/$YEAR
readonly PROJECT_ROW=4

function _new () {
    latest=$(ls $WORKSPACE | head)
    if [ ! -e $WORKSPACE ]; then
        mkdir -p $WORKSPACE
    fi

    if [ ! -e $WORKSPACE/$TODAY ]; then
        if [ ! -e $latest ]; then
            cat $WORKSPACE/$latest | grep -e "^- (" > $WORKSPACE/$TODAY
        else
            touch $WORKSPACE/$TODAY
        fi
    else
        echo "Error! Already exit $TODAY."
    fi
    return 0
}

function _add() {
    return 0
}

function _open () {
    nvim  $WORKSPACE/$TODAY
    return 0
}

function _ls () {
    IFS=$'\n'
    if [ $A_FLG ]; then
        # TODO: -ap
        todos=$(cat $WORKSPACE/$TODAY | sort -k 2)
    else
        todos=$(grep $WORKSPACE/$TODAY -e "^- *" | sort -k 2)
    fi
    if [ $P_FLG ]; then
        prevParent=""
        projects=$(grep $WORKSPACE/$TODAY -e "^- *" | awk '{ print $'${PROJECT_ROW}' }' | sort | uniq)
        for proj in $projects; do
            if echo $proj | grep "\+" > /dev/null; then
                parent=$(echo $proj | cut -d '+' -f 1)
                sub=$(echo $proj | cut -d '+' -f 2)
                if [ "$prevParent" == "" ]; then
                    echo $parent
                elif [ "$prevParent" != "$parent" ]; then
                    echo $parent
                fi
                echo "  $sub"
                for t in $todos; do
                    if echo "$t" | grep -e "^-.*$parent+$sub" > /dev/null; then
                        echo "    $t"
                    fi
                done
                prevParent=$parent
            else
                echo $proj
                for t in $todos; do
                    if echo $t | grep -e "^-.*$proj" > /dev/null; then
                        echo "  $t"
                    fi
                done
            fi
        done
    else
        for t in $todos; do
            echo $t
        done
    fi
    return 0
}

subcommand=$1
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
                p) P_FLG=1
                    ;;
                a) A_FLG=1
                    ;;
            esac
        done
        shift $(( $OPTIND - 1 ))
        _ls
        ;;
    *)
        echo "Unknown subcommand"
esac
