#!/bin/sh

sn=$(cat /etc/device_serial)

var1=$(($sn/256/256%256+128))
var2=$(($sn/256%256))
var3=$(($sn%256))

mac=$(printf "%02X:%02X:%02X" $var1 $var2 $var3)
echo 62:01:94:$mac
