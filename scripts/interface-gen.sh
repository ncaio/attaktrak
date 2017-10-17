#!/bin/bash 
#
#
_interw="$1"
_macm="$2"
_nssid="$3"
#
#
#
echo "#
#	RaspiGET CONFIG
#
auto $_interw
allow-hotplug $_interw
iface wlan0 inet static
hostapd /etc/hostapd/hostapd.conf
address 10.10.0.1
netmask 255.255.255.0
pre-up ifconfig $_interw hw ether $_macm"
#
#
#
_bit="1"
#
#
#
_interc=$(echo $_interw | wc -c)
if [ "$_interc" -gt 10 ]
then
	_interw="$(echo "$_interw" | cut -c1-5)"
fi
#
#
#
for _i in $(seq 1 $(($_nssid-1)) )
do
	echo "#
#	$_interw alias $_i	
#
auto $_interw"_"$_i
iface $_interw"_"$_i inet static
address 10.10.$_i.1
netmask 255.255.255.0"
	let _bit++
done
