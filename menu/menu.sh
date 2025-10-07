#!/bin/bash
# Cyberpunk Spider Panel — Hezpaty Edition 2025
# Auto-detect Debian/Ubuntu + Dynamic ASCII Art + Unified Management Menu

# ===================== COLORS =====================
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
white='\033[1;37m'
gray='\033[0;37m'
bold='\033[1m'
nc='\033[0m'
# ==================================================

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
# ========================================================

# ===================== SERVICE STATUS =====================
check_service() {
    systemctl is-active --quiet "$1" && echo -e "${green}⛷️🛰️🎯${nc}" || echo -e "${red}☣️☣️☢️${nc}"
}

status_ssh=$(check_service ssh)
status_xray=$(check_service xray)
status_dropbear=$(check_service dropbear)
status_nginx=$(check_service nginx)
status_haproxy=$(check_service haproxy)
# ==================================================

# ===================== HEADER =====================
clear
echo -e "${cyan}──────────────────────────────────────────────────────────────${nc}"
echo -e "${yellow}>>>${white}${bold}  T_OpPLUG | CYBERPUNK SPIDER PANEL 🕷️ 2025 ${yellow}🗽💻📡🛰️🤿⛷️${nc}"
echo -e "${cyan}──────────────────────────────────────────────────────────────${nc}"
echo
# ==================================================

# ===================== ASCII ART AUTO-DETECT =====================
if [[ "$DISTRO" == "ubuntu" ]]; then
    echo -e "${purple}"
    cat <<'EOF'
           _
       ---(_)
   _/  ---  \
  (_) |   |
    \  --- _/
       ---(_)
EOF
    echo -e "${nc}"
elif [[ "$DISTRO" == "debian" ]]; then
    echo -e "${red}"
    cat <<'EOF'
       ▄▄▄▄▄▄▄
     ▄█████████▄
    ███▀   ▀█████
   ███        ███
   ███▄      ▄███
    █████▄▄█████
      ▀███████▀
EOF
    echo -e "${nc}"
else
    echo -e "${blue}[!] Unknown Linux Distribution Detected${nc}"
fi
# ==================================================

# ===================== SYSTEM DETAILS =====================
echo -e "${purple} [🧠] SYSTEM OS${nc}       = ${yellow}$OS${nc}"
echo -e "${purple} [⚙️] CORE SYSTEM${nc}     = ${yellow}$CORE${nc}"
echo -e "${purple} [💾] SERVER RAM${nc}      = ${yellow}$RAM_USED/$RAM_TOTAL MB${nc}"
echo -e "${purple} [⏳] SERVER UPTIME${nc}   = ${yellow}$UPTIME${nc}"
echo -e "${purple} [🌐] DOMAIN${nc}          = ${yellow}$DOMAIN${nc}"
echo -e "${purple} [📡] IP VPS${nc}          = ${yellow}$IP${nc}"
echo -e "${purple} [🏢] ISP${nc}             = ${yellow}$ISP${nc}"
echo -e "${purple} [📍] CITY${nc}            = ${yellow}$CITY${nc}"
echo -e "${purple} [📅] DATE${nc}            = ${yellow}$DATE${nc}"
echo -e "${purple} [⏰] TIME${nc}            = ${yellow}$TIME${nc}"
echo
# ==================================================

# ===================== ACCOUNT STATUS =====================
echo -e "${cyan}>>>${white}${bold} VPS ACCOUNT STATUS ${cyan}<<<${nc}"
echo -e "${cyan}──────────────────────────────────────────────────────────────${nc}"
echo -e "${green} SSH / OPENVPN     ${nc}➤ 2 PREMIUM ACCOUNTS"
echo -e "${green} VMESS / WS / GRPC ${nc}➤ 0 PREMIUM ACCOUNTS"
echo -e "${green} VLESS / WS / GRPC ${nc}➤ 0 PREMIUM ACCOUNTS"
echo -e "${green} TROJAN / WS / GRPC${nc}➤ 0 PREMIUM ACCOUNTS"
echo -e "${green} SHADOWSOCKS / WS  ${nc}➤ 0 PREMIUM ACCOUNTS"
echo -e "${cyan}──────────────────────────────────────────────────────────────${nc}"
echo
# ==================================================

# ===================== LIVE SERVICE STATUS =====================
echo -e "${white}${bold}Service Status:${nc}"
echo -e "  SSH       : $status_ssh      XRAY      : $status_xray"
echo -e "  DROPBEAR  : $status_dropbear  NGINX     : $status_nginx"
echo -e "  HAPROXY   : $status_haproxy"
echo -e "${cyan}──────────────────────────────────────────────────────────────${nc}"
echo
# ==================================================

# ===================== MAIN CYBERPUNK MENU =====================
echo -e "${yellow}${bold}[01]${nc} SSH / OVPN Menu         ${yellow}[09]${nc} Psiphon Manager"
echo -e "${yellow}${bold}[02]${nc} Vmess Manager           ${yellow}[10]${nc} Zi-UDP Manager"
echo -e "${yellow}${bold}[03]${nc} Vless Manager           ${yellow}[11]${nc} OpenVPN Manager"
echo -e "${yellow}${bold}[04]${nc} Trojan Manager          ${yellow}[12]${nc} 3xUI Panel"
echo -e "${yellow}${bold}[05]${nc} Shadowsocks Manager     ${yellow}[13]${nc} 1Panel Dashboard"
echo -e "${yellow}${bold}[06]${nc} Limit Speed             ${yellow}[14]${nc} SlowDNS Control"
echo -e "${yellow}${bold}[07]${nc} VPS Info                ${yellow}[15]${nc} Helium Panel"
echo -e "${yellow}${bold}[08]${nc} Auto Reboot             ${yellow}[16]${nc} Settings"
echo -e "${yellow}${bold}[17]${nc} Reboot VPS              ${yellow}[18]${nc} Clear Cache"
echo -e "${yellow}${bold}[19]${nc} Running Services        ${yellow}[20]${nc} Backup / Restore"
echo -e "${yellow}${bold}[21]${nc} Update Script           ${yellow}[22]${nc} Exit${nc}"
echo -e "${cyan}──────────────────────────────────────────────────────────────${nc}"
echo
# ==================================================

read -p "Select an option: " opt
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
    14) clear; rm -rf install; apt update; wget https://github.com/powermx/dnstt/raw/main/install; chmod 777 install; ./install --start ;;
    15) clear; apt update && apt install wget -y && wget -q -O /usr/bin/ins-helium "https://raw.githubusercontent.com/Hubdarkweb/Lenin/master/helium/ins-helium.sh" && chmod +x /usr/bin/ins-helium && ins-helium ;;
    16) clear; m-system ;;
    17) clear; reboot ;;
    18) clear; clearcache ;;
    19) clear; running ;;
    20) clear; menu-backup ;;
    21) clear; wget https://raw.githubusercontent.com/spider660/Lau_Op/main/update.sh && chmod +x update.sh && ./update.sh ;;
    22) echo -e "${red}Exiting Cyberpunk Control Panel... Stay sharp ⚡${nc}"; exit ;;
    *) echo -e "${red}Invalid Option!${nc}" ;;
esac
# ==================================================
