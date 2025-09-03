#!/bin/bash

# Colors
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
MAGENTA="\033[0;35m"
NC="\033[0m"

COMMAND="$1"

# Big ASCII Banner
BANNER="${MAGENTA}
                                                                           
                                                                           
TTTTTTTTTTTTTTTTTTTTTTT                                                    
T:::::::::::::::::::::T                                                    
T:::::::::::::::::::::T                                                    
T:::::TT:::::::TT:::::T                                                    
TTTTTT  T:::::T  TTTTTTeeeeeeeeeeee    rrrrr   rrrrrrrrr   aaaaaaaaaaaaa   
        T:::::T      ee::::::::::::ee  r::::rrr:::::::::r  a::::::::::::a  
        T:::::T     e::::::eeeee:::::eer:::::::::::::::::r aaaaaaaaa:::::a 
        T:::::T    e::::::e     e:::::err::::::rrrrr::::::r         a::::a 
        T:::::T    e:::::::eeeee::::::e r:::::r     r:::::r  aaaaaaa:::::a 
        T:::::T    e:::::::::::::::::e  r:::::r     rrrrrrraa::::::::::::a 
        T:::::T    e::::::eeeeeeeeeee   r:::::r           a::::aaaa::::::a 
        T:::::T    e:::::::e            r:::::r          a::::a    a:::::a 
      TT:::::::TT  e::::::::e           r:::::r          a::::a    a:::::a 
      T:::::::::T   e::::::::eeeeeeee   r:::::r          a:::::aaaa::::::a 
      T:::::::::T    ee:::::::::::::e   r:::::r           a::::::::::aa:::a
      TTTTTTTTTTT      eeeeeeeeeeeeee   rrrrrrr            aaaaaaaaaa  aaaa
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           
${NC}"

if [ -z "$COMMAND" ]; then
    echo -e "${YELLOW}Usage:${NC} pkg help"
    exit 1
fi

case "$COMMAND" in
    help)
        echo -e "$BANNER"
        echo -e "${CYAN}TERA - https://discord.gg/cSMhTqRNXR:${NC}\n"
        echo -e "  ${GREEN}pkg help${NC}        - find cmds"
        echo -e "\n${YELLOW}Tip:${NC} wsg here my tools"
        ;;
    *)
        echo -e "${RED}Unknown command:${NC} $COMMAND"
        echo -e "${YELLOW}Usage:${NC} pkg help"
        ;;
esac
