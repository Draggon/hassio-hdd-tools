CONFIG_PATH=/data/options.json

HDD_PATH="$(jq --raw-output '.hdd_path' $CONFIG_PATH)"
OUTPUT_FILE="$(jq --raw-output '.output_file' $CONFIG_PATH)"

TEMP=$(/usr/sbin/smartctl -a ${HDD_PATH} | grep Temperature_Celsius | awk '{print $(NF)}')

echo "[$(date)][Info] HDD Temp: $TEMP°" > /proc/1/fd/1 2>/proc/1/fd/2
echo "[$(date)][Info] HDD Temp: $TEMP°" >> /share/hdd_tools/${OUTPUT_FILE}

curl -X POST -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
       -H "Content-Type: application/json" \
       -d $'{"state": "'"$TEMP"'", "attributes": {"unit_of_measurement": "°C", "friendly_name": "Hdd Temp"}}' \
       http://supervisor/core/api/states/sensor.hdd_temp