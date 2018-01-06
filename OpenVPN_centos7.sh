#!/bin/bash
# Installs a  OpenVPN-only system for CentOS7

# Check if user is root
[ $(id -u) != "0" ] && { echo -e "\033[31mError: You must be root to run this script\033[0m"; exit 1; } 

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
clear
printf "
#######################################################################
#            Installs OpenVPN for CentOS7                             #
#            More information http://www.iewb.net                     #
#######################################################################
"
[ ! -e '/etc/yum.repos.d/epel.repo' ] && yum -y install epel-release
[ ! -e '/usr/bin/curl' ] && yum -y install curl
SERVER_IP=`ip addr |grep "inet"|grep -v "127.0.0.1"|grep -v "inet6" |cut -d: -f2|awk '{print $2}'|cut -d/ -f1|awk '{print $1}'`
VPN_IP=`curl ipv4.icanhazip.com`
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf   
echo "1" > /proc/sys/net/ipv4/ip_forward
yum -y install openvpn easy-rsa
/bin/cp -f ./data/server/* /etc/openvpn/
/bin/cp -f ./data/client.zip /etc/openvpn/
sed -i "25a local $SERVER_IP" /etc/openvpn/server.conf
systemctl start firewalld
firewall-cmd --add-port 1194/udp --permanent
firewall-cmd --reload
systemctl stop firewalld
echo '/usr/sbin/openvpn /etc/openvpn/server.conf' >>/etc/rc.d/rc.local
clear
echo -e "\033[32mYour OpenVPN installed successfully\033[0m"
echo -e "your external IP \033[32m${VPN_IP}\033[0m"
echo -e "Whether to start the OpenVPN now?"
confirm="yes"
while :; do echo
read -p "Please input {yes} to start the OpenVPN: " isconfirm
[ -n "$isconfirm" ] && break
done
if [ "$isconfirm" = "$confirm" ];then
/usr/sbin/openvpn /etc/openvpn/server.conf
else
echo -e "You input others,so the OpenVPN is not running,pleale run \033[32m'/usr/sbin/openvpn /etc/openvpn/server.conf '\033[0m to start it."
fi
