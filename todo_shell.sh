#!/bin/sh

# default parameters
# -----------------------------------------------------------------------------
TODO_ROOT="$HOME/bin"
TODO="$TODO_ROOT/todo.sh -d $HOME/.todo.cfg"
CLEAR="clear"
prompt="todo> "

opts=$@

# prints prompt
function print_prompt (){
    printf "$prompt"
}
# main loop
# -----------------------------------------------------------------------------
print_prompt
while read line; do
    if [ $line == "quit" ]; then
        exit 0
    elif [ $line == "clear" ]; then
        $CLEAR
        print_prompt
        continue
    fi

    $TODO $line
    print_prompt
done < "${1:-/dev/stdin}"


