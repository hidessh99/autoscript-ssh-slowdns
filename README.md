<h2 align="center">
Auto Script Install All VPN Service

#info for you
   slow dns membuat openvpn eror but wireguard working and lt2p working
   
   
   
## Installation 

Part 1: Update dan Upgrade
  ```html
apt-get update && apt-get upgrade -y && update-grub && sleep 2 && reboot
```
## Auto installer 
  
script installer SSH + Slowdns 443
  ```html
wget https://raw.githubusercontent.com/hidessh99/autoscript-ssh-slowdns/main/setup.sh && chmod +x setup.sh && ./setup.sh
...   

   
## Setting cloudflare 

tambahan ip vps ke akun cloudflare kamu
 contohnya 
   
settingan A recond DNS Clouflare 
A sub domain ip vps
   
Example
   
A  id   103.140.155.156
      
settingan NS recond DNS Clouflare buat SlowDNS
   
NS  slowdns-subdomain suubdomain
    
Example 
  
NS slowdns-id    id.domain.com
   
   
   

## Os Supported
  ```html
• Debian 10 & 9

• Ubuntu 18.04 & 20.04

# Service & Port

• OpenSSH                 : 22, 88
• Dropbear                : 44, 77
• Stunnel                 : 444, 222, 777
• OpenVPN                 : TCP 1194, UDP 2200, SSL 990
• Websocket SSH TLS       : 443
• Websocket SSH HTTP      : 8880
• Squid Proxy             : 3128, 8080
• Badvpn                  : 7100, 7200, 7300
• Nginx                   : 89
• OHP SSH                 : 8181
• OHP Dropbear            : 8282
• SLOWDNS OPENSSH         : ALL Port ( 22, 443, 44)


 ### Server Information & Other Features

• Timezone                : Asia/Jakarta (GMT +7)

• Fail2Ban                : [ON]

• Dflate                  : [ON]

• IPtables                : [ON]

• Auto-Reboot             : [ON]



• Autoreboot On 05.00 GMT +7

• Autoreboot On 17.00 GMT +7

• Auto Delete Expired Account
     ```
  
