#!/bin/bash
# Tera dox v0.01 - CLI for Termux

TITLE="Tera dox v0.01"
REPO_URL="https://raw.githubusercontent.com/lucent-hub/Lucent/main/Extra/UI/A/H/H/Tera.js"
FILE_NAME="Tera.js"

# Function to print a box banner
echo_box() {
    echo "╔════════════════════════════════╗"
    echo "║$(printf ' %-30s ║' "$1")"
    echo "╚════════════════════════════════╝"
}

COMMAND=$1

case "$COMMAND" in
    help)
        echo_box "$TITLE"
        echo
        echo "Commands:"
        echo "  help   ~ Shows this help menu"
        echo "  fetch  ~ Downloads $FILE_NAME, lists it, then prompts for deletion"
        echo "More commands coming soon ..."
        ;;
    fetch)
        echo_box "Fetching $FILE_NAME"
        echo "Downloading from GitHub..."
        wget -q --show-progress -O "$FILE_NAME" "$REPO_URL"

        if [ $? -eq 0 ]; then
            echo "✔ $FILE_NAME downloaded successfully!"
            ls -l "$FILE_NAME"

            # Prompt before deleting
            read -p "Do you want to delete $FILE_NAME? (y/n): " choice
            if [[ "$choice" == [Yy] ]]; then
                rm "$FILE_NAME"
                echo "$FILE_NAME has been deleted."
            else
                echo "$FILE_NAME was not deleted."
            fi
        else
            echo "✖ Failed to download $FILE_NAME."
        fi
        ;;
    *)
        echo_box "Unknown Command"
        echo "Unknown command: $COMMAND"
        echo "Try: ter help"
        ;;
esac

exit 0
                
