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
		_interw="$(iw dev | grep -A5 $i | awk '/Interface/ {print $2}')"
		_mac="$(iw dev | grep -A5 $i | awk '/addr/ {print $2}')"
		_macm="$(echo ${_mac:0:1}2${_mac:2:14}0)"
		echo "INTERFACE $i is $_interw with MAC ADDRESS $_mac - MAC ADDRESS will be: $_macm"
		#
		#
		#
		u="$(echo $i| tr -d '\#')"
		_mode="$(iw phy "$u" info | grep -A12 "Supported interface modes:" | grep -B 12 "Band 1:")"
		echo "$_mode" | grep -q "* monitor"
		_key="$?"
		#
		#
		#
		if [ "$_key" != "0" ]
		then
			echo "Monitor mode - not supported"
			exit 1
		else
			_mssid=$(iw phy "$u" info | grep 'total.*channels' | cut -d',' -f1 | awk '{print $NF}')
		#
		#
		#
		if [ -z "$_mssid" ]
		then
			_nssid="1"
		else
			_nssid="$_mssid"
		fi
		#
		#
		#
		if [ "$_nssid" -gt "1" ]
		then
			echo "Multiple SSIDs: $_nssid"
		else
			echo "WIRELESS CARD DOESN'T PERMIT MULTIPLE SSIDs"
		fi
	fi
	done
	echo "--------------------------------------"
	echo ""
fi

