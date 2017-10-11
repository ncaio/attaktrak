#!/bin/bash
#
#
#
_nssid="$1"
_count="1"
#
#
#
if [ -z "$_nssid" ]
then
	echo "ERRO: ARG NOT FOUND. TRY ./dhcpd-gen.sh n"
	exit 1
fi
#
#
#
echo "
#
#	DHCPD.CONF HEADER
#
ddns-update-style none;
ignore client-updates;
authoritative;
default-lease-time 600;
max-lease-time 3600;
#
#	/30 TO MANAGEMENT SSID
#
subnet 10.10.0.0 netmask 255.255.255.252 {
	range 10.10.0.2 10.10.0.2;
}
"
#
#
#
_bit="1"
#
#
#
for _i in $(cat ../templates/SSID|head -n $(($_nssid-1)))
do 
	echo "
#
#
#
subnet 10.10."$_bit".0 netmask 255.255.255.0 {
on commit {
        set ClientIP = binary-to-ascii(10, 8, ".", leased-address);
	set ClientMac = binary-to-ascii(16, 8, ":", substring(hardware, 1, 6));
	log(concat("Commit: IP: ", ClientIP, " Mac: ", ClientMac));
	execute("/usr/local/scripts/script.sh", ClientIP, ClientMac, "$_i", option host-name);
	}
	range 10.10."$_bit".10 10.10."$_bit".254;
	option routers 10.10."$_bit".1;
	}
"
	let _bit++
done
