#!/bin/bash
#date january 2022
# created bye hidessh.com
# Simple
# port Stunnel and Websocket 443 & Slowdns
# ==================================================

# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ifconfig.me/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=Indonesia
locality=Indonesia
organization=hidessh.com
organizationalunit=hidessh.com
commonname=hidessh.com
email=admin@hidessh.com

# simple password minimal
wget -O /etc/pam.d/common-password "https://gitlab.com/hidessh/baru/-/raw/main/password"
chmod +x /etc/pam.d/common-password

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END


# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

# install wget and curl
apt -y install wget curl
apt -y install python

# install python
cd
gem install lolcat
apt -y install figlet

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime


# install
apt-get -y bzip2 gzip wget screen htop net-tools zip unzip wget curl nano sed screen

# Install Requirements Tools
apt install python -y
apt install make -y
apt install cmake -y
apt install jq -y
apt install apt-transport-https -y
apt install neofetch -y
apt install git -y
apt install gcc -y
apt install g++ -y

#tambahan package nettools
apt-get install net-tools -y

#hapus apache
apt-get remove apache2 -y
apt-get purge apache2* -y

# install webserver
apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://gitlab.com/hidessh/baru/-/raw/main/nginx.conf"
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf "https://gitlab.com/hidessh/baru/-/raw/main/vps.conf"
/etc/init.d/nginx restart

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://gitlab.com/hidessh/baru/-/raw/main/badvpn-udpgw64"
chmod +x /usr/bin/badvpn-udpgw

#installer badvpn
wget https://raw.githubusercontent.com/hidessh99/projectku/main/badvpn/installer-badvpn.sh && chmod +x installer-badvpn.sh && ./installer-badvpn.sh


# setting port ssh
sed -i '/Port 22/a Port 88' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart
/etc/init.d/ssh restart


# install dropbear
apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=44/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 69 -p 77 -p 300"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# install stunnel
apt install stunnel4 -y
#certi stunnel
#wget -O /etc/stunnel/hidessh.pem https://gitlab.com/hidessh/baru/-/raw/main/certi/stunel && chmod +x /etc/stunnel/hidessh.pem
#installer SSL Cloudflare 
cd

wget https://raw.githubusercontent.com/hidessh99/projectku/main/SSL/hidesvr.crt
wget https://raw.githubusercontent.com/hidessh99/projectku/main/SSL/hidesvr.key
#buat directory
mkdir /etc/hidessh
chmod +x /etc/hidessh

cat hidesvr.key hidesvr.crt >> /etc/hidessh/stunnel.pem

#konfigurasi stunnel4
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/hidessh/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 222
connect = 127.0.0.1:22

[dropbear]
accept = 444
connect = 127.0.0.1:300

[dropbear]
accept = 777
connect = 127.0.0.1:77

[openvpn]
accept = 442
connect = 127.0.0.1:1194

[slws]
accept = 8443
connect = 127.0.0.1:443

END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

cd
#install sslh
apt-get install sslh -y
#konfigurasi
#port 333 to 44 and 777
wget -O /etc/default/sslh "https://gitlab.com/hidessh/baru/-/raw/main/SSLH/sslh.conf"
service sslh restart


# install squid
#cd
apt -y install squid3
wget -O /etc/squid/squid.conf "https://gitlab.com/hidessh/baru/-/raw/main/squid.conf"
sed -i $MYIP2 /etc/squid/squid.conf
/etc/init.d/squid restart

#install badvpncdn
wget https://github.com/ambrop72/badvpn/archive/master.zip
unzip master.zip
cd badvpn-master
mkdir build
cmake .. -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1
sudo make install

END


# install fail2ban
apt -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# blockir torrent
apt install iptables-persistent -y
#wget https://raw.githubusercontent.com/4hidessh/hidessh/main/security/torrent && chmod +x torrent && ./torrent
#iptables-save > /etc/iptables.up.rules
#iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

cd
# Custom Banner SSH
echo "================  Banner ======================"
wget -O /etc/issue.net "https://gitlab.com/hidessh/baru/-/raw/main/banner.conf"
chmod +x /etc/issue.net

echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
echo "DROPBEAR_BANNER="/etc/issue.net"" >> /etc/default/dropbear

# download script
cd /usr/bin
wget -O about "https://gitlab.com/hidessh/baru/-/raw/main/about.sh"
wget -O menu "https://gitlab.com/hidessh/baru/-/raw/main/menu.sh"
wget -O usernew "https://gitlab.com/hidessh/baru/-/raw/main/usernew.sh"
wget -O trial "https://gitlab.com/hidessh/baru/-/raw/main/trial.sh"
wget -O hapus "https://gitlab.com/hidessh/baru/-/raw/main/hapus.sh"
wget -O member "https://gitlab.com/hidessh/baru/-/raw/main/member.sh"
wget -O delete "https://gitlab.com/hidessh/baru/-/raw/main/delete.sh"
wget -O cek "https://gitlab.com/hidessh/baru/-/raw/main/cek.sh"
wget -O restart "https://gitlab.com/hidessh/baru/-/raw/main/restart.sh"
wget -O speedtest "https://gitlab.com/hidessh/baru/-/raw/main/speedtest_cli.py"
wget -O info "https://gitlab.com/hidessh/baru/-/raw/main/info.sh"
wget -O ram "https://gitlab.com/hidessh/baru/-/raw/main/ram.sh"
wget -O renew "https://gitlab.com/hidessh/baru/-/raw/main/renew.sh"
wget -O autokill "https://gitlab.com/hidessh/baru/-/raw/main/autokill.sh"
wget -O ceklim "https://gitlab.com/hidessh/baru/-/raw/main/ceklim.sh"
wget -O tendang "https://gitlab.com/hidessh/baru/-/raw/main/tendang.sh"
wget -O clear-log "https://gitlab.com/hidessh/baru/-/raw/main/clear-log.sh"
wget -O user-limit "https://gitlab.com/hidessh/baru/-/raw/main/user-limit.sh"

#tambahan baru
wget -O userdelexpired "https://gitlab.com/hidessh/baru/-/raw/main/userdelexpired.sh"
wget -O autoreboot "https://gitlab.com/hidessh/baru/-/raw/main/autoreboot.sh"
wget -O autoservice "https://gitlab.com/hidessh/baru/-/raw/main/autoservice.sh"


#permission
chmod +x autoservice
chmod +x userdelexpired
chmod +x user-limit
chmod +x add-host
chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x hapus
chmod +x member
chmod +x delete
chmod +x cek
chmod +x restart
chmod +x speedtest
chmod +x info
chmod +x about
chmod +x autokill
chmod +x tendang
chmod +x ceklim
chmod +x ram
chmod +x renew
chmod +x autoreboot

#auto reboot cronjob
echo "0 5 * * * root clear-log && reboot" >> /etc/crontab
echo "0 17 * * * root clear-log && reboot" >> /etc/crontab
echo "50 * * * * root userdelexpired" >> /etc/crontab

# finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/stunnel4 restart
#/etc/init.d/squid restart


history -c
echo "unset HISTFILE" >> /etc/profile

#hapus file instalasi
cd
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh
rm -f /root/ihide
rm -rf /root/vpnku.sh

# remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y


#instalasi Websocket
wget https://raw.githubusercontent.com/hidessh99/projectku/main/websocket/hideinstall-websocket.sh && chmod +x hideinstall-websocket.sh && ./hideinstall-websocket.sh

# finihsing
clear
#installer OPH
wget https://gitlab.com/hidessh/baru/-/raw/main/ohp.sh && chmod +x ohp.sh && ./ohp.sh

#remove file 
cd
rm -rf hideinstall-websocket.sh
rm -rf hidehost.sh
rm -rf ohp.sh
