#!/bin/bash

readonly BASE="$HOME/todo"
readonly YEAR=$(date +"%Y")
readonly TODAY=$(date +"%m-%d")
readonly WORKSPACE=$BASE/$YEAR

function _new () {
    LATEST=$(ls $WORKSPACE | head)
    if [ ! -e $WORKSPACE ]; then
        mkdir -p $WORKSPACE
    fi

    if [ ! -e $WORKSPACE/$TODAY ]; then
        if [ ! -e $LATEST ]; then
            cp $WORKSPACE/$LATEST $WORKSPACE/$TODAY
        else
            touch $WORKSPACE/$TODAY
        fi
    else
        echo "Error! Already exit $TODAY."
    fi
    return 0
}

function _open () {
    nvim  $WORKSPACE/$TODAY
    return 0
}

function _ls () {
    IFS=$'\n'
    todos=$(grep $WORKSPACE/$TODAY -e "^- *")
    if [ $P_FLG ]; then
        projects=$(grep $WORKSPACE/$TODAY -e "^- *" | awk '{ print $5 }' | sort | uniq )
        for pro in $projects; do
            echo "$pro"
            for t in $todos; do
                echo $t | grep -e "^-.*$pro"
            done
        done
        return 0
    fi

    for t in $todos; do
        echo $t
    done
    return 0
}

subcommand=$1
shift

case $subcommand in
    new)
        _new
        ;;
    open)
        _open
        ;;
    ls)
        while getopts "p" OPT
        do
            case $OPT in
                p) P_FLG=1
            esac
        done
        shift $(( $OPTIND - 1 ))
        _ls
        ;;
    *)
        echo "Unknown subcommand"
esac
