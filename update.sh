#!/usr/bin/env bash

# Fix server date extraction and formatting
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep -i '^Date:' | sed -e 's/^[Dd]ate: //')
server_date=$(date -d "$dateFromServer" +"%Y-%m-%d" 2>/dev/null || date +"%Y-%m-%d")

red() {
  echo -e "\033[31m$*\033[0m"
}

clear
fun_bar() {
  local cmd1="$1"
  local cmd2="$2"
  local pid
  local spinner='|/-\'
  (
    # run provided commands if any
    if [ -n "$cmd1" ]; then
      eval "$cmd1" >/dev/null 2>&1
    fi
    if [ -n "$cmd2" ]; then
      eval "$cmd2" >/dev/null 2>&1
    fi
    # create a flag file when done
    touch "$HOME/.fim"
  ) &
  pid=$!

  tput civis
  printf "  \033[3mPlease Wait Loading \033[0m"
  # spinner loop until background job finishes
  while true; do
    for i in $(seq 0 3); do
      printf "\b${spinner:i:1}"
      sleep 0.1
    done
    if [ -e "$HOME/.fim" ]; then
      rm -f "$HOME/.fim"
      break
    fi
  done
  printf "\b \033[33m]\033[7m -\033[2m OK !\033[0m\n"
  tput cnorm
  wait "$pid" 2>/dev/null || true
}

res1() {
  wget -q https://raw.githubusercontent.com/Hubdarkweb/Lenin/main/menu/menu.zip -O /tmp/menu.zip
  unzip -o /tmp/menu.zip -d /tmp >/dev/null 2>&1
  chmod +x /tmp/menu/*
  mv /tmp/menu/* /usr/local/sbin/ 2>/dev/null || true
  rm -rf /tmp/menu /tmp/menu.zip
  # remove this update script if desired
  rm -f "$(realpath "$0")"
}

netfilter-persistent
clear
echo -e "\033[36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " \e[1m          UPDATED SCRIPT POWERED BY 🗽📡🛰️⛷️🤿🎯💻 TOpNeT Cyberpunk    \e[0m"
echo -e "\033[36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e "  \033[m update script service\033[m"
fun_bar "res1" ""
echo -e "\033[36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -n 1 -s -r -p "Press [ Enter ] to back on menu"
echo
# try to call menu if available
if command -v menu >/dev/null 2>&1; then
  menu
fi
