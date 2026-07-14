#!/bin/sh

ADC_FILE="/sys/bus/iio/devices/iio:device0/in_voltage1_raw"

VREF=1800
MAX_RAW=1023
RATIO=31

if [ ! -f "$ADC_FILE" ]; then
	exit 1
fi

RAW_VALUE=$(cat "$ADC_FILE")

TOTAL_MV=$(( (RAW_VALUE * 55800) / 1023 ))
V_WHOLE=$(( TOTAL_MV / 1000 ))
V_FRACTION=$(( (TOTAL_MV % 1000) / 10 ))

if [ $V_FRACTION -lt 10 ]; then
    V_FRACTION="0$V_FRACTION"
fi

echo "{\"raw\":$RAW_VALUE,\"voltage\":$V_WHOLE.$V_FRACTION}"
