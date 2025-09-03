#!/bin/bash

# PKG Help Simulator - No downloads

show_help() {
    echo "------------------"
    echo "      PKG Help"
    echo "------------------"
    echo "help      - Show this help message"
    echo "list      - Show mock installed packages"
    echo "hi        - Say hello"
    echo "------------------"
}

list_mock() {
    echo "Installed packages (mock):"
    echo "- Python.gitignore"
    echo "- Uhm... A"
    echo "- ExamplePackage"
}

COMMAND="$1"

case "$COMMAND" in
    help|--help|-h)
        show_help
        ;;
    list)
        list_mock
        ;;
    hi)
        echo "Hello! 👋 Welcome to PKG Simulator."
        ;;
    *)
        echo "Unknown command: $COMMAND"
        echo "Type 'pkg help' for available commands."
        ;;
esac
