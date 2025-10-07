#!/bin/bash
# Cyberpunk Spider Panel — TOpNeT Edition 2025
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
    systemctl is-active --quiet "$1" && echo -e "${green}⛷️🛰️🎯♎${nc}" || echo -e "${red}☣️☣️☢️♈${nc}"
}

status_ssh=$(check_service ssh)
status_xray=$(check_service xray)
status_dropbear=$(check_service dropbear)
status_nginx=$(check_service nginx)
status_haproxy=$(check_service haproxy)
status_psiphon=$(check_service psiphon)
status_ziudp=$(check_service zivpn)
# ==================================================

# ===================== PSIPHON MANAGER =====================
m-psiphon() {
    clear
    echo -e "${cyan}──────────────────────────────────────────────────────────────${nc}"
    echo -e "${yellow}>>>${white}${bold} Psiphon Manager ${yellow}🛡️${nc}"
    echo -e "${cyan}──────────────────────────────────────────────────────────────${nc}"
    echo -e "${white}${bold}Service Status:${nc} $status_psiphon"
    echo
    echo -e "${yellow}[1]${nc} Install Psiphon"
    echo -e "${yellow}[2]${nc} Start Psiphon"
    echo -e "${yellow}[3]${nc} Stop Psiphon"
    echo -e "${yellow}[4]${nc} Restart Psiphon"
    echo -e "${yellow}[5]${nc} Check Psiphon Status"
    echo -e "${yellow}[6]${nc} Display server-entry.dat"
    echo -e "${yellow}[7]${nc} Back to Main Menu"
    echo -e "${cyan}──────────────────────────────────────────────────────────────${nc}"
    read -p "Select an option: " psiphon_opt
    case $psiphon_opt in
        1)
            echo -e "${yellow}Installing Psiphon...${nc}"
            readonly INSTALL_DIR="/opt/5G"
            readonly PSIPHON_URL="https://raw.githubusercontent.com/Psiphon-Labs/psiphon-tunnel-core-binaries/master/psiphond/psiphond"
            readonly SERVICE_FILE="/etc/systemd/system/psiphon.service"
            readonly LOG_FILE="/var/log/psiphon_setup.log"
            sudo touch "$LOG_FILE"
            sudo chown "$(whoami)" "$LOG_FILE"
            for cmd in curl wget sed systemctl; do
                if ! command -v "$cmd" &>/dev/null; then
                    echo -e "${red}Error: $cmd is required but not installed.${nc}"
                    sleep 2
                    m-psiphon
                fi
            done
            if ! sudo apt-get update; then
                echo -e "${red}Failed to update package repositories.${nc}"
                sleep 2
                m-psiphon
            fi
            if ! sudo apt-get install -y curl wget screen; then
                echo -e "${red}Failed to install necessary packages.${nc}"
                sleep 2
                m-psiphon
            fi
            sudo sed -i '/^#DNSStubListener=yes/c\DNSStubListener=no' /etc/systemd/resolved.conf
            echo "DNS=1.1.1.1" | sudo tee -a /etc/systemd/resolved.conf >/dev/null
            sudo systemctl restart systemd-resolved
            sudo mkdir -p "$INSTALL_DIR"
            if ! sudo wget -nv "$PSIPHON_URL" -O "$INSTALL_DIR/psiphond"; then
                echo -e "${red}Failed to download Psiphon.${nc}"
                sleep 2
                m-psiphon
            fi
            sudo chmod +x "$INSTALL_DIR/psiphond"
            ip_address=$(curl -s https://api.ipify.org)
            (cd "$INSTALL_DIR" && sudo ./psiphond --ipaddress "$ip_address" --protocol SSH:80 --protocol OSSH:53 generate)
            sudo sed -i 's/"ServerIPAddress": "[^"]*"/"ServerIPAddress": "0.0.0.0"/g' "$INSTALL_DIR/psiphond.config"
            sudo tee "$SERVICE_FILE" >/dev/null <<EOF
[Unit]
Description=Psiphon Service
After=network.target

[Service]
Type=simple
ExecStart=$INSTALL_DIR/psiphond run
WorkingDirectory=$INSTALL_DIR
Restart=on-failure
RestartSec=10s

[Install]
WantedBy=multi-user.target
EOF
            sudo systemctl daemon-reload
            sudo systemctl enable psiphon.service
            sudo systemctl start psiphon.service
            echo -e "${green}Psiphon installed successfully!${nc}"
            read -rp "Would you like to display the contents of server-entry.dat now? (y/N): " display_confirm
            if [[ "${display_confirm,,}" =~ ^(yes|y)$ ]]; then
                if [[ -f "$INSTALL_DIR/server-entry.dat" ]]; then
                    sudo cat "$INSTALL_DIR/server-entry.dat"
                    read -p "Press Enter to continue..."
                else
                    echo -e "${red}server-entry.dat file not found.${nc}"
                fi
            fi
            read -rp "Would you like to reboot now? (y/N): " confirm
            if [[ "${confirm,,}" =~ ^(yes|y)$ ]]; then
                echo -e "${yellow}Rebooting the system...${nc}"
                sudo reboot
            else
                echo -e "${yellow}Please reboot the system later to apply changes.${nc}"
                sleep 2
                m-psiphon
            fi
            ;;
        2)
            sudo systemctl start psiphon.service
            echo -e "${green}Psiphon started!${nc}"
            sleep 2
            m-psiphon
            ;;
        3)
            sudo systemctl stop psiphon.service
            echo -e "${yellow}Psiphon stopped!${nc}"
            sleep 2
            m-psiphon
            ;;
        4)
            sudo systemctl restart psiphon.service
            echo -e "${green}Psiphon restarted!${nc}"
            sleep 2
            m-psiphon
            ;;
        5)
            sudo systemctl status psiphon.service
            read -p "Press Enter to continue..."
            m-psiphon
            ;;
        6)
            if [[ -f "$INSTALL_DIR/server-entry.dat" ]]; then
                sudo cat "$INSTALL_DIR/server-entry.dat"
            else
                echo -e "${red}server-entry.dat file not found.${nc}"
            fi
            read -p "Press Enter to continue..."
            m-psiphon
            ;;
        7)
            clear
            bash $0
            ;;
        *)
            echo -e "${red}Invalid Option!${nc}"
            sleep 2
            m-psiphon
            ;;
    esac
}
# ==================================================

# ===================== ZI-UDP MANAGER =====================
m-ziudp() {
    clear
    echo -e "${cyan}──────────────────────────────────────────────────────────────${nc}"
    echo -e "${yellow}>>>${white}${bold} Zi-UDP Manager ${yellow}🚀${nc}"
    echo -e "${cyan}──────────────────────────────────────────────────────────────${nc}"
    echo -e "${white}${bold}Service Status:${nc} $status_ziudp"
    echo
    echo -e "${yellow}[1]${nc} Install Zi-UDP"
    echo -e "${yellow}[2]${nc} Start Zi-UDP"
    echo -e "${yellow}[3]${nc} Stop Zi-UDP"
    echo -e "${yellow}[4]${nc} Restart Zi-UDP"
    echo -e "${yellow}[5]${nc} Check Zi-UDP Status"
    echo -e "${yellow}[6]${nc} Modify Users"
    echo -e "${yellow}[7]${nc} Back to Main Menu"
    echo -e "${cyan}──────────────────────────────────────────────────────────────${nc}"
    read -p "Select an option: " ziudp_opt
    case $ziudp_opt in
        1)
            echo -e "${yellow}Installing Zi-UDP...${nc}"
            for cmd in wget openssl sed systemctl ip ufw; do
                if ! command -v "$cmd" &>/dev/null; then
                    echo -e "${red}Error: $cmd is required but not installed.${nc}"
                    sleep 2
                    m-ziudp
                fi
            done
            if ! apt-get update || ! apt-get upgrade -y; then
                echo -e "${red}Failed to update/upgrade system packages.${nc}"
                sleep 2
                m-ziudp
            fi
            systemctl stop zivpn.service 2>/dev/null
            if ! wget https://github.com/zahidbd2/udp-zivpn/releases/download/udp-zivpn_1.4.9/udp-zivpn-linux-amd64 -O /usr/local/bin/zivpn; then
                echo -e "${red}Failed to download Zi-UDP binary.${nc}"
                sleep 2
                m-ziudp
            fi
            chmod +x /usr/local/bin/zivpn
            mkdir -p /etc/zivpn
            if ! wget https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/config.json -O /etc/zivpn/config.json; then
                echo -e "${red}Failed to download Zi-UDP config.${nc}"
                sleep 2
                m-ziudp
            fi
            openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=California/L=Los Angeles/O=Example Corp/OU=IT Department/CN=zivpn" -keyout "/etc/zivpn/zivpn.key" -out "/etc/zivpn/zivpn.crt"
            sysctl -w net.core.rmem_max=16777216 >/dev/null
            sysctl -w net.core.wmem_max=16777216 >/dev/null
            iptables -t nat -A PREROUTING -i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -p udp --dport 20000:50000 -j DNAT --to-destination :5666
            ufw allow 20000:50000/udp
            ufw allow 5666/udp
            cat <<EOF >/etc/systemd/system/zivpn.service
[Unit]
Description=zivpn VPN Server
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/etc/zivpn
ExecStart=/usr/local/bin/zivpn -config /etc/zivpn/config.json server
Restart=always
RestartSec=3
Environment=ZIVPN_LOG_LEVEL=info
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF
            systemctl daemon-reload
            systemctl enable zivpn.service
            systemctl start zivpn.service
            echo -e "${green}Zi-UDP installed successfully!${nc}"
            sleep 2
            m-ziudp
            ;;
        2)
            systemctl start zivpn.service
            echo -e "${green}Zi-UDP started!${nc}"
            sleep 2
            m-ziudp
            ;;
        3)
            systemctl stop zivpn.service
            echo -e "${yellow}Zi-UDP stopped!${nc}"
            sleep 2
            m-ziudp
            ;;
        4)
            systemctl restart zivpn.service
            echo -e "${green}Zi-UDP restarted!${nc}"
            sleep 2
            m-ziudp
            ;;
        5)
            systemctl status zivpn.service
            read -p "Press Enter to continue..."
            m-ziudp
            ;;
        6)
            echo -e "${yellow}Enter usernames separated by commas (e.g., user1,user2):${nc}"
            read -p "Press Enter for default 'zi': " input_config
            if [ -n "$input_config" ]; then
                IFS=',' read -r -a config <<< "$input_config"
                if [ ${#config[@]} -eq 1 ]; then
                    config+=(${config[0]})
                fi
            else
                config=("zi")
            fi
            new_config_str="\"config\": [$(printf "\"%s\"," "${config[@]}" | sed 's/,$//')]"
            sed -i -E "s/\"config\": ?\[[[:space:]]*\"zi\"[[:space:]]*\]/${new_config_str}/g" /etc/zivpn/config.json
            systemctl restart zivpn.service
            echo -e "${green}Users updated and Zi-UDP restarted!${nc}"
            sleep 2
            m-ziudp
            ;;
        7)
            clear
            bash $0
            ;;
        *)
            echo -e "${red}Invalid Option!${nc}"
            sleep 2
            m-ziudp
            ;;
    esac
}
# ==================================================

# ===================== HEADER =====================
clear
echo -e "${cyan}──────────────────────────────────────────────────────────────${nc}"
echo -e "${yellow}>>>${white}${bold}  T_OpPLUG || CYBERPUNK PANEL || 2025 ${yellow}🗽💻📡🛰️🤿⛷️${nc}"
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
echo -e "  HAPROXY   : $status_haproxy   PSIPHON   : $status_psiphon"
echo -e "  ZI-UDP    : $status_ziudp"
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
    14) clear; rm -rf install; apt update; wget https://github.com/powermx/dnstt/raw/main/install; chmod +x install; ./install --start ;;
    15) clear; apt update && apt install wget -y && wget -q -O /usr/bin/ins-helium "https://raw.githubusercontent.com/Hubdarkweb/Lenin/master/helium/ins-helium.sh" && chmod +x /usr/bin/ins-helium && ins-helium ;;
    16) clear; m-system ;;
    17) clear; reboot ;;
    18) clear; clearcache ;;
    19) clear; running ;;
    20) clear; menu-backup ;;
    21) clear; wget https://raw.githubusercontent.com/spider660/Lau_Op/main/update.sh && chmod +x update.sh && ./update.sh ;;
    22) echo -e "${red}Exiting Cyberpunk Control Panel... Stay sharp ⚡${nc}"; exit ;;
    *) echo -e "${red}Invalid Option!${nc}"; sleep 2; clear; bash $0 ;;
esac
# ==================================================
