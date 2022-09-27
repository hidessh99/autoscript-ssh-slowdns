#!/bin/bash
# Setup installer projext SSH + OpenVPN +Websocket + l2tp/IPsec
# auto installer script created by SL
# skrip penginstal otomatis dibuat oleh SL
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
# ==========================================
# Color
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'



echo "installing insaller Slowdns "
echo "Progress..."
echo "Sedang berlangsung..."
https://raw.githubusercontent.com/hidessh99/projectku/main/Slowdns/hidessh-slowdns && chmod +x hidessh-slowdns && ./hidessh-slowdns
sleep 1

echo -e "[ ${green}INFO${NC} ] DONE... ALAT"
sleep 1
echo "Progress..."
echo "Sedang berlangsung..."
sleep 3
