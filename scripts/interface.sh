#!/bin/bash
#
#
#
_interface="$(iw dev | grep ^phy | paste -s -d " ")"
#
#
#
if [ ! -z "$_interface" ]
then
	for i in $_interface
	do
		echo "--------------------------------------"
		_interw="$(iw dev | grep -A1 $i | awk '/Interface/ {print $2}')"
		echo "INTERFACE $i is $_interw"
		i="$(echo $i| tr -d '\#')"
		_mode="$(iw phy "$i" info | grep -A12 "Supported interface modes:" | grep -B 12 "Band 1:")"
		echo "$_mode" | grep -q "* monitor"
		_key="$?"
		if [ "$_key" != "0" ]
		then
			echo "Monitor mode - not supported"
			exit 1
		else
			_mssid=$(iw phy "$i" info | grep 'total.*channels' | cut -d',' -f1 | awk '{print $NF}')
		if [ -z "$_mssid" ]
		then
			_nssid="1"
		else
			_nssid="$_mssid"
		fi
		echo "SSID SIZE: $_nssid SSIDs may be supported"
	fi
	done
	echo "--------------------------------------"
	echo ""
fi

