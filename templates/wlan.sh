#!/bin/bash
#
#
#
wpapid="$(pgrep wpa_supplicant)"
if [ ! -z "$wpapid" ]
then
	echo "Eu encontrei um PID referente ao processo wpa_supplicant"
	kill -9 $(pgrep wpa_supplicant)
fi
#
#
#
#gpsd -n /dev/ttyUSB0
#
#
#
hostapd -B /etc/hostapd/hostapd.conf
#
#
#
ifconfig wlan0_1 10.10.1.1/24 up
ifconfig wlan0_2 10.10.2.1/24 up
ifconfig wlan0_3 10.10.3.1/24 up
ifconfig wlan0_4 10.10.4.1/24 up
ifconfig wlan0_5 10.10.5.1/24 up
ifconfig wlan0_6 10.10.6.1/24 up
ifconfig wlan0_7 10.10.7.1/24 up
#
#
#
iptables -t nat -A PREROUTING -i wlan+ -p tcp --dport 80 -j DNAT --to-destination 10.10.0.1:80
iptables -t nat -A PREROUTING -i wlan+ -p tcp --dport 443 -j DNAT --to-destination 10.10.0.1:80
iptables -t nat -A PREROUTING -i wlan+ -p tcp --dport 53 -j DNAT --to-destination 10.10.0.1:53
#
#
#
/usr/sbin/dhcpd -cf /etc/dhcp/dhcpd.conf
#
#
#
#gpsd -n /dev/ttyUSB0
