#!/bin/sh


# -----------------------------------------------------------------------------
#    A simple "shell" for Gina Trapani's todo.txt-cli
#    Copyright (C) 2015 K M Masum Habib <masumhabib.com>
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
TODO_SHELL_CFG="$HOME/.todo_shell.cfg"
TODO_ROOT="$HOME/bin"
TODO_CFG="$HOME/.todo.cfg"
PROMPT="todo> "

# Read config
[[ -f $TODO_SHELL_CFG ]] && source $TODO_SHELL_CFG

# Globals
# -----------------------------------------------------------------------------
TODO="$TODO_ROOT/todo.sh -d $TODO_CFG"
CLEAR="clear"

# prints prompt
function print_prompt (){
    printf "$PROMPT"
}

# main
# -----------------------------------------------------------------------------
opts=$@
print_prompt
while read line; do
    cmd=${line%% *}
    if [ $cmd == "quit" ]; then
        exit 0
    elif [ $cmd == "clear" ]; then
        $CLEAR
        print_prompt
        continue
    fi

    $TODO $line
    print_prompt
done < "${1:-/dev/stdin}"


