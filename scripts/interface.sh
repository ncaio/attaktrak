#!/bin/bash
#
#
#
_interface="$(iw dev| head -n 1|tr -d '\#')"
#
#
#
echo "INTERFACE: $_interface"
if [ ! -z "$_interface" ]
then
	_mode="$(iw phy "$_interface" info | grep -A12 "Supported interface modes:" | grep -B 12 "Band 1:")"
	echo "$_mode" | grep -q "* monitor"
	_key="$?"
	if [ "$_key" != "0" ]
	then
		echo "Monitor mode disabled"
		exit 1
	else
		_mssid=$(iw phy "$_interface" info | grep 'total.*channels' | cut -d',' -f1 | awk '{print $NF}')
		if [ -z "$_mssid" ]
		then
			_nssid="1"
		else
			_nssid="$_mssid"
		fi
		echo "SSID SIZE: $_nssid"
	fi
fi

