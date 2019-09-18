#!/bin/bash

# Title       : XenServer Default Setting
# Description : XenServer Default Setting
# How to Use  : ./xen_init.sh
# Maker       : LT
# Date        : 2019.09.19.
# OS          : XenServer




#############################
##### Modify Repository #####
#############################
echo -e "\n\E[;32m @ Modify Repository \033[0m"
cp -a /etc/yum.repos.d/CentOS-Base.repo ~/ori/CentOS-Base.repo.ori
cat ~/ori/CentOS-Base.repo.ori | sed '/base/,/centosplus/s/enabled=0/enabled=1/g' | sed 's/$releasever/7/g' > /etc/yum.repos.d/CentOS-Base.repo
echo -e "\t\E[;36m Complete\033[0m"


###########################
##### Install package #####
###########################
echo -e "\n\E[;32m @ Install package - epel, expect, ... \033[0m"
	yum install -y epel-release expect rdate
	yum install -y python-pip
echo -e "\t\E[;36m Complete\033[0m"


######################################
##### Set up the iptables policy #####
######################################
echo -e "\n\E[;32m @ Set up the iptables policy \033[0m"
mv /etc/sysconfig/iptables ~/iptables.ori
echo "# sample configuration for iptables service
# you can edit this manually or use system-config-firewall
# please do not ask us to add additional ports/services to this default configuration
*filter
:INPUT DROP [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:RH-Firewall-1-INPUT - [0:0]

### Default
-A INPUT -i lo -j ACCEPT
-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp --icmp-type any -j ACCEPT
-A INPUT -s [Console PC IP] -j ACCEPT
COMMIT

### NAT
*nat
:PREROUTING ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A POSTROUTING -s [Guest IP/Netmask] -j MASQUERADE
-A PREROUTING -d [Host IP] -p [tcp/udp] --dport [Port] -j DNAT --to-destination [Guest IP:Port]
COMMIT" > /etc/sysconfig/iptables

/usr/bin/systemctl restart iptables
echo -e "\t\E[;36m Complete\033[0m"


####################################
##### Set time Synchronization #####
####################################
echo -e "\n\E[;32m @ Set time Synchronization \033[0m"
/usr/bin/rdate -s time.nist.gov && /sbin/hwclock -w

chk=`cat /etc/crontab | grep rdate | wc -l`
if [ $chk -eq 0 ] ; then
	echo >> /etc/crontab
	echo "0 1 * * * root rdate -s time.nist.gov && hwclock -w" >> /etc/crontab
fi
/usr/bin/systemctl restart crond
echo -e "\t\E[;36m Complete\033[0m"
