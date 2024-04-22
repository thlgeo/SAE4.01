#!/bin/bash

interface="/etc/network/interfaces"
dns_file="/etc/resolv.conf"

set -e

# read -p "Nom du device: " device_name
# read -p "IP Statique souhaitée: " ip
# read -p "Masque réseau: " masque
# read -p "IP du routeur: " routeur
# read -p "IP du DNS: " dns

device_name=enp0s3

#ifdown $device_name
echo "Périphérique désactivé"

head -n -2 $interface > $interface

echo "allow-hotplug $device_name
iface $device_name inet static
    address $1/16
    gateway 10.42.0.1
" >> $interface

echo "nameserver 10.42.0.1" > $dns_file

#ifup $device_name
apt install sudo sshpass -y

sudo usermod -aG sudo user

sudo reboot
