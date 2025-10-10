#!/bin/bash
# CYBERPUNK TOpPLUG STORE PANEL — 2025 Terminal Edition ⚡

# ===================== COLORS =====================
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
white='\033[1;37m'
bold='\033[1m'
blink='\033[5m'
reset='\033[0m'

# Neon cycling effect (color switcher)
colors=($red $yellow $green $blue $purple $cyan $white)

function neon() {
    local text="$1"
    for color in "${colors[@]}"; do
        echo -ne "${color}${bold}${text}${reset}\r"
        sleep 0.07
    done
    echo -ne "${white}${bold}${text}${reset}\n"
}

# ===================== SYSTEM INFO =====================
OS=$(hostnamectl | grep "Operating System" | cut -d ' ' -f5-)
DISTRO=$(grep -w ID /etc/os-release | cut -d= -f2 | tr -d '"')
CORE=$(nproc)
RAM_TOTAL=$(free -m | awk 'NR==2{print $2}')
RAM_USED=$(free -m | awk 'NR==2{print $3}')
UPTIME=$(uptime -p | cut -d " " -f 2-10)
DOMAIN=$(cat /etc/xray/domain 2>/dev/null || echo "Not Set")
IP=$(curl -s ifconfig.me)
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10)
CITY=$(curl -s ipinfo.io/city)
DATE=$(date +"%d/%m/%Y")
TIME=$(date +"%H:%M:%S")

# ===================== SERVICE STATUS =====================
check_service() {
    systemctl is-active --quiet "$1" && echo -e "${green}${blink}⛷️🛰️🎯${reset}" || echo -e "${red}${blink}☣️☣️☢️${reset}"
}

status_ssh=$(check_service ssh)
status_xray=$(check_service xray)
status_dropbear=$(check_service dropbear)
status_nginx=$(check_service nginx)
status_haproxy=$(check_service haproxy)
status_psiphon=$(check_service psiphon)
status_ziudp=$(check_service zivpn)
status_openvpn=$(check_service openvpn)

# ===================== ASCII ART =====================
clear
if [[ "$DISTRO" == "ubuntu" ]]; then
    echo -e "${purple}${bold}"
    cat <<'EOF'
           _
       ---(_)
   _/  ---  \
  (_) |   |
    \  --- _/
       ---(_)
EOF
    echo -e "${reset}"
elif [[ "$DISTRO" == "debian" ]]; then
    echo -e "${purple}${bold}"
    cat <<'EOF'
       ▄▄▄▄▄▄▄
     ▄█████████▄
    ███▀   ▀█████
   ███        ███
   ███▄      ▄███
    █████▄▄█████
      ▀███████▀
EOF
    echo -e "${reset}"
fi

# ===================== HEADER =====================
neon "🕹️  TOpPLUG CYBERPUNK STORE PANEL ⚡ 2025"
echo -e "${purple}──────────────────────────────────────────────────────────────${reset}"
echo

# ===================== SYSTEM DETAILS =====================
echo -e "${cyan}[🧠] SYSTEM OS${reset}       = ${yellow}$OS${reset}"
echo -e "${cyan}[⚙️] CORE SYSTEM${reset}     = ${yellow}$CORE${reset}"
echo -e "${cyan}[💾] SERVER RAM${reset}      = ${yellow}$RAM_USED/$RAM_TOTAL MB${reset}"
echo -e "${cyan}[⏳] SERVER UPTIME${reset}   = ${yellow}$UPTIME${reset}"
echo -e "${cyan}[🌐] DOMAIN${reset}          = ${yellow}$DOMAIN${reset}"
echo -e "${cyan}[📡] IP VPS${reset}          = ${yellow}$IP${reset}"
echo -e "${cyan}[🏢] ISP${reset}             = ${yellow}$ISP${reset}"
echo -e "${cyan}[📍] CITY${reset}            = ${yellow}$CITY${reset}"
echo -e "${cyan}[📅] DATE${reset}            = ${yellow}$DATE${reset}"
echo -e "${cyan}[⏰] TIME${reset}            = ${yellow}$TIME${reset}"
echo

# ===================== SERVICE STATUS =====================
neon "⚔️ LIVE SERVICE STATUS"
echo -e "${purple}──────────────────────────────────────────────────────────────${reset}"
echo -e " SSH        : $status_ssh        XRAY      : $status_xray"
echo -e " DROPBEAR   : $status_dropbear   NGINX     : $status_nginx"
echo -e " HAPROXY    : $status_haproxy    PSIPHON   : $status_psiphon"
echo -e " ZI-UDP     : $status_ziudp      OPENVPN   : $status_openvpn"
echo -e "${purple}──────────────────────────────────────────────────────────────${reset}"
echo

# ===================== ACCOUNT STATUS =====================
neon "💼 ACCOUNT STATUS"
echo -e "${purple}──────────────────────────────────────────────────────────────${reset}"
echo -e "${green} SSH/OPENVPN     ${reset}➤ 2 PREMIUM ACCOUNTS"
echo -e "${green} VMESS/WS/GRPC   ${reset}➤ 0 PREMIUM ACCOUNTS"
echo -e "${green} VLESS/WS/GRPC   ${reset}➤ 0 PREMIUM ACCOUNTS"
echo -e "${green} TROJAN/WS/GRPC  ${reset}➤ 0 PREMIUM ACCOUNTS"
echo -e "${green} SHADOWSOCKS/WS  ${reset}➤ 0 PREMIUM ACCOUNTS"
echo -e "${purple}──────────────────────────────────────────────────────────────${reset}"
echo

# ===================== CYBERPUNK MENU =====================
neon "🚀 TOpPLUG STORE MENU"
echo -e "${purple}──────────────────────────────────────────────────────────────${reset}"
echo -e "${yellow}[01]${reset} SSH / OVPN Menu           ${yellow}[09]${reset} Psiphon Manager"
echo -e "${yellow}[02]${reset} Vmess Manager             ${yellow}[10]${reset} Zi-UDP Manager"
echo -e "${yellow}[03]${reset} Vless Manager             ${yellow}[11]${reset} OpenVPN Manager"
echo -e "${yellow}[04]${reset} Trojan Manager            ${yellow}[12]${reset} 3xUI Panel"
echo -e "${yellow}[05]${reset} Shadowsocks Manager       ${yellow}[13]${reset} 1Panel Dashboard"
echo -e "${yellow}[06]${reset} Limit Speed               ${yellow}[14]${reset} SlowDNS Control"
echo -e "${yellow}[07]${reset} VPS Info                  ${yellow}[15]${reset} Helium Panel"
echo -e "${yellow}[08]${reset} Auto Reboot               ${yellow}[16]${reset} Settings"
echo -e "${yellow}[17]${reset} Reboot VPS                ${yellow}[18]${reset} Clear Cache"
echo -e "${yellow}[19]${reset} Running Services          ${yellow}[20]${reset} Backup / Restore"
echo -e "${yellow}[21]${reset} Update Script             ${yellow}[22]${reset} Exit"
echo -e "${purple}──────────────────────────────────────────────────────────────${reset}"
echo

read -p "💠 Enter Option: " opt
case $opt in
    1) clear; m-sshovpn ;;
    2) clear; m-vmess ;;
    3) clear; m-vless ;;
    4) clear; m-trojan ;;
    5) clear; m-ssws ;;
    6) clear; limitspeed ;;
    7) clear; gotop ;;
    8) clear; autoreboot ;;
    9) clear; m-psiphon ;;
    10) clear; m-ziudp ;;
    11) clear; m-openvpn ;;
    12) clear; VERSION=v2.5.5 && bash <(curl -Ls "https://raw.githubusercontent.com/mhsanaei/3x-ui/$VERSION/install.sh") $VERSION ;;
    13) clear; bash -c "$(curl -sSL https://resource.1panel.pro/quick_start.sh)" ;;
    14) clear; rm -rf install; apt update; wget https://github.com/powermx/dnstt/raw/main/install; chmod +x install; ./install --start ;;
    15) clear; apt update && apt install wget -y && wget -q -O /usr/bin/ins-helium "https://raw.githubusercontent.com/Hubdarkweb/Lenin/master/helium/ins-helium.sh" && chmod +x /usr/bin/ins-helium && ins-helium ;;
    16) clear; m-system ;;
    17) clear; reboot ;;
    18) clear; clearcache ;;
    19) clear; running ;;
    20) clear; menu-backup ;;
    21) clear; wget https://raw.githubusercontent.com/Hubdarkweb/Lenin/main/update.sh && chmod +x update.sh && ./update.sh ;;
    22) echo -e "${red}Exiting TOpPLUG Panel... ⚡${reset}"; exit ;;
    *) echo -e "${red}Invalid Option!${reset}"; sleep 2; clear; bash $0 ;;
esac
