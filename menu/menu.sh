#!/bin/bash

# Color Definitions
clear
y='\033[1;33m' # Yellow
z="\033[96m" # Cyan
RED='\033[0;31m'
NC='\033[0m' # No Color
green='\033[0;32m'
Blue="\033[0;34m"
purple="\033[1;95m"
grenbo="\e[92;1m"
gray="\e[1;30m"
white='\033[1;37m'
bold="\033[1m"
BG="\e[48;5;235m"
blink="\033[5m"
orange="\033[38;5;214m"
maroon="\033[38;5;124m"

# Fetch System Information
get_ram_info() {
    ram_info=$(free -m | awk 'NR==2{print $2,$3}')
    tram=$(echo "$ram_info" | awk '{print $1}')
    uram=$(echo "$ram_info" | awk '{print $2}')
    mem_used=$(printf "%.2f%%" "$(free | awk '/Mem/{printf $3/$2*100}')")
}

get_cpu_usage() {
    cpu_usage=$(top -bn1 | awk '/Cpu/ {print 100 - $8}')
    cpu_usage=$(printf "%.2f%%" "$cpu_usage")
}

get_vps_info() {
    domain=$(cat /etc/xray/domain 2>/dev/null || echo "Not Set")
    uptime=$(uptime -p | cut -d " " -f 2-10)
    ipvps=$(curl -s ifconfig.me)
    loc=$(curl -sS "https://api.country.is/${ipvps}" | jq -r '.country')
    loc=${loc:-Unknown}
    os_name=$(hostnamectl | grep "Operating System" | cut -d ' ' -f5-)
    date_vps=$(date +'%Y-%m-%d')
    time_vps=$(date +"%H:%M:%S")
}

# ASCII Art for Ubuntu and Debian
ubuntu_ascii() {
    echo -e "${purple}"
    echo -e "           _"
    echo -e "       ---${y}(_)${NC}${purple}"
    echo -e "   _/  ---  \\"
    echo -e "  (_) |   |"
    echo -e "    \\  --- _/"
    echo -e "       ---${z}(_)${NC}${purple}"
    echo -e "${NC}"
}

debian_ascii() {
    echo -e "${maroon}"
    echo -e "       _______"
    echo -e "    .-'${orange}       '-.${maroon}"
    echo -e "   /${orange}     Debian   \\${maroon}"
    echo -e "  |                 |"
    echo -e "   \\               /"
    echo -e "    '-._______.-'"
    echo -e "${NC}"
}

# Display Banner with Multiple Containers
show_banner() {
    clear
    get_vps_info
    get_ram_info
    get_cpu_usage

    echo -e "${white}${bold}${BG}╭━━━━━━━━━━━━━━━━━━━━━━ BANNER 1 ━━━━━━━━━━━━━━━━━━━━━━━╮${NC}"
    echo -e "${white}${bold}┃${NC} ${green}Operating System${NC}: $os_name                                 ${white}${bold}┃${NC}"
    echo -e "${white}${bold}${BG}╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯${NC}"

    echo -e "${white}${bold}${BG}╭━━━━━━━━━━━━━━━━━━━━━━ BANNER 2 ━━━━━━━━━━━━━━━━━━━━━━━╮${NC}"
    echo -e "${white}${bold}┃${NC} ${z}Ubuntu ASCII Art:${NC}"
    ubuntu_ascii
    echo -e "${white}${bold}┃${NC} ${z}Debian ASCII Art:${NC}"
    debian_ascii
    echo -e "${white}${bold}${BG}╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯${NC}"

    echo -e "${white}${bold}${BG}╭━━━━━━━━━━━━━━━━━━━━━━ BANNER 3 ━━━━━━━━━━━━━━━━━━━━━━━╮${NC}"
    echo -e "${white}${bold}┃${NC} ${z}MENU OPTIONS${NC}:"
    echo -e "${white}${bold}┃${NC} ${z}[1]${NC} ${green}SSH Menu${NC}              ${z}[5]${NC} ${green}Settings${NC}        ${white}${bold}┃${NC}"
    echo -e "${white}${bold}┃${NC} ${z}[2]${NC} ${green}Vmess Menu${NC}            ${z}[6]${NC} ${green}Services Status${NC} ${white}${bold}┃${NC}"
    echo -e "${white}${bold}┃${NC} ${z}[3]${NC} ${green}Trojan Menu${NC}           ${z}[7]${NC} ${green}Clear RAM Cache${NC} ${white}${bold}┃${NC}"
    echo -e "${white}${bold}┃${NC} ${z}[4]${NC} ${green}Shadowsocks Menu${NC}      ${z}[8]${NC} ${green}Reboot VPS${NC}     ${white}${bold}┃${NC}"
    echo -e "${white}${bold}┃${NC} ${z}[0]${blink}${RED}Exit Menu${NC}                                 ${white}${bold}┃${NC}"
    echo -e "${white}${bold}${BG}╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯${NC}"

    echo -e "${white}${bold}${BG}╭━━━━━━━━━━━━━━━━━━━━━━ BANNER 4 ━━━━━━━━━━━━━━━━━━━━━━━╮${NC}"
    echo -e "${white}${bold}┃${NC} ${green}CPU Usage${NC}:    $cpu_usage                              ${white}${bold}┃${NC}"
    echo -e "${white}${bold}┃${NC} ${green}RAM Usage${NC}:    $uram MB / $tram MB (${mem_used})          ${white}${bold}┃${NC}"
    echo -e "${white}${bold}${BG}╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯${NC}"

    echo -e "${white}${bold}${BG}╭━━━━━━━━━━━━━━━━━━━━━━ BANNER 5 ━━━━━━━━━━━━━━━━━━━━━━━╮${NC}"
    echo -e "${white}${bold}┃${NC} ${green}VPS Details${NC}:"
    echo -e "${white}${bold}┃${NC} ${green}Domain${NC}:      $domain"
    echo -e "${white}${bold}┃${NC} ${green}Public IP${NC}:   $ipvps"
    echo -e "${white}${bold}┃${NC} ${green}Location${NC}:    $loc"
    echo -e "${white}${bold}┃${NC} ${green}Uptime${NC}:      $uptime"
    echo -e "${white}${bold}┃${NC} ${green}Date${NC}:        $date_vps"
    echo -e "${white}${bold}┃${NC} ${green}Time${NC}:        $time_vps"
    echo -e "${white}${bold}${BG}╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯${NC}"
}

# Display Menu
show_menu() {
    show_banner
    echo
    echo -ne "${z}Select an option:${NC} "
    read -r opt
    echo
    case $opt in
        1) clear ; m-sshovpn ;;
        2) clear ; m-vmess ;;
        3) clear ; m-trojan ;;
        4) clear ; m-ssws ;;
        5) clear ; m-system ;;
        6) clear ; running ;;
        7) clear ; clearcache ;;
        8) clear ; /sbin/reboot ;;
        0) echo -e "${RED}Exiting script... Goodbye!${NC}" && exit ;;
        *) echo -e "${RED}Invalid selection! Try again.${NC}" && sleep 2 ;;
    esac
}

# Main Loop
while true; do
    show_menu
done
