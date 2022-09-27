<h2 align="center">
Auto Script Install All VPN Service

#info for you
   slow dns membuat openvpn eror but wireguard working and lt2p working
   
   
   
## Installation 
## 1.
Part 1: Update dan Upgrade
   <img src="https://img.shields.io/badge/Update%20Upgrade-green"> 
  ```html
apt-get update && apt-get upgrade -y && update-grub && sleep 2 && reboot
```
  
## 2.0
script installer SSH + Slowdns 443
  ```html
wget https://raw.githubusercontent.com/hidessh99/autoscript-ssh-slowdns/main/setup.sh && chmod +x setup.sh && ./setup.sh
