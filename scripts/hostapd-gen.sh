#!/bin/bash 
#
#
_interw="$1"
_macm="$2"
_nssid="$3"
#
#
#
echo "interface="$_interw"
bssid="$_macm"
driver=nl80211
ssid=RaspiGET
channel=3
wpa=2
wpa_passphrase=raspgetpi
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP"
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
for _i in $(cat ../templates/SSID|head -n $(($_nssid-1)))
do
	echo "#
#	SSID $_i
#
bss="$_interw"_"$_bit"
ssid="$_i""
	let _bit++
done
