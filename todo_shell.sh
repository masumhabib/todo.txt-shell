#!/bin/sh

# -----------------------------------------------------------------------------
#    A simple "shell" for Gina Trapani's todo.txt-cli
#    Copyright (C) 2016 K M Masum Habib <masumhabib.com>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License version 2
#    as published by the Free Software Foundation.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
# -----------------------------------------------------------------------------

# default parameters
# -----------------------------------------------------------------------------
DEFAULT_TODO_SHELL_CFG_FILE="$HOME/.todo_shell.cfg"

DEFAULT_TODO_ROOT="\$HOME/bin"
DEFAULT_TODO_CFG="\$HOME/.todo.cfg"
DEFAULT_PROMPT="todo> "

VERSION="1.1.0"

# prints prompt
# -----------------------------------------------------------------------------
function print_prompt (){
    printf "$PROMPT"
}

# parse options
# -----------------------------------------------------------------------------
function parse_args {
    while getopts ":d:v" option
    do
        case $option in
            'd')
                # config file path
                todo_shell_cfg_file=$OPTARG
                ;;
            'v')
                echo "todo.txt shell v$VERSION"
                exit 0
                ;;
        esac
    done
    shift $(($OPTIND - 1))
}

# Read config
# -----------------------------------------------------------------------------
function read_config {
    local config_file=$1

    prompt=$DEFAULT_PROMPT
    todo_root=$DEFAULT_TODO_ROOT
    todo_cfg=$DEFAULT_TODO_CFG

    if [[ -f $config_file ]]; then
        source $config_file
        [[ ! -z $PROMPT ]] && prompt=$PROMPT
        [[ ! -z $TODO_ROOT ]] && todo_root=$TODO_ROOT
        [[ ! -z $TODO_CFG ]] && todo_cfg=$TODO_CFG
    fi
    
    todo_exe="$todo_root/todo.sh"
}

# Write default config
# -----------------------------------------------------------------------------
function write_default_config {
    local config_file=$1

    echo "# Prompt of the shell" > $config_file
    echo "PROMPT=\"$DEFAULT_PROMPT \"" >> $config_file
    echo "# Directory where todo.sh file is located" >> $config_file
    echo "TODO_ROOT=\"$DEFAULT_TODO_ROOT\"" >> $config_file
    echo "# todo.sh config file location" >> $config_file
    echo "TODO_CFG=\"$DEFAULT_TODO_CFG\"" >> $config_file
}

function loop {
    print_prompt
    while read -e line; do
        len=${#line}
        if [[ $len -le 0 ]]; then
            print_prompt
            continue
        fi
    
        cmd=${line%% *}
        if [[ $cmd == "q" || $cmd == "quit" || $cmd == "exit" ]]; then
            exit 0
        elif [[ $cmd == "clear" ]]; then
            $CLEAR
            print_prompt
            continue
        fi
    
        $TODO $line 
        print_prompt
    done < "${1:-/dev/stdin}"
}


# main
# -----------------------------------------------------------------------------
todo_shell_cfg_file=$DEFAULT_TODO_SHELL_CFG_FILE

parse_args $@

read_config $todo_shell_cfg_file

if [[ ! -f $todo_shell_cfg_file && $todo_shell_cfg_file == "$DEFAULT_TODO_SHELL_CFG_FILE" ]]; then 
    write_default_config $todo_shell_cfg_file
fi

if [[ ! -e $todo_exe ]]; then
    echo "Could not find $todo_exe. If you have installed in somewhere else, modify $todo_shell_cfg_file."
    exit 1
fi

TODO="$todo_root/todo.sh -d $todo_cfg"
CLEAR="clear"


# main loop
loop


