#!/bin/bash

# Mini Tera interpreter
while true; do
    # Prompt
    read -p "ter " cmd args

    if [ "$cmd $args" == "ter help" ]; then
        echo "╔════════════════════════════════╗"
        echo "║        Tera dox v0.01         ║"
        echo "╚════════════════════════════════╝"
        echo
        echo "Ter help ~ shows tera help commands"
        echo "More coming soon ..."
    elif [ "$cmd" == "exit" ]; then
        echo "Exiting Tera..."
        break
    else
        echo "Unknown command: $cmd $args"
        echo "Type 'ter help' for commands or 'exit' to quit"
    fi
done
