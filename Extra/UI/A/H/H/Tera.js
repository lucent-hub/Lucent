#!/bin/bash
# Fake Hacker PKG Tool (Help Only)

GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
NC="\033[0m"

COMMAND="$1"

if [ -z "$COMMAND" ]; then
    echo -e "${YELLOW}Usage:${NC} pkg help"
    exit 1
fi

case "$COMMAND" in
    help)
        echo -e "${BLUE}Fake PKG Hacker Tool - Available Commands:${NC}"
        echo -e "  ${GREEN}pkg tera${NC}      - Launch the Tera exploit module"
        echo -e "  ${GREEN}pkg scan${NC}      - Scan for vulnerabilities"
        echo -e "  ${GREEN}pkg exploit${NC}   - Inject fake payload"
        echo -e "  ${GREEN}pkg update${NC}    - Update the hacker database"
        echo -e "  ${GREEN}pkg dox <target>${NC} - Fake dox simulation"
        ;;
    *)
        echo -e "${YELLOW}Usage:${NC} pkg help"
        ;;
esac
