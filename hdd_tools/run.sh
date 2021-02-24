#!/usr/bin/with-contenv bashio

echo "[$(date)][Info] HDD Tools start"

CONFIG_PATH=/data/options.json

PERFORMANCE_CHECK="$(jq --raw-output '.performance_check' $CONFIG_PATH)"
echo "[$(date)][Info] Configuration - performance check enabled: $PERFORMANCE_CHECK"

HDD_PATH="$(jq --raw-output '.hdd_path' $CONFIG_PATH)"
echo "[$(date)][Info] Configuration - disk path: $HDD_PATH" 

CHECK_PERIOD="$(jq --raw-output '.check_period' $CONFIG_PATH)"
echo "[$(date)][Info] Configuration - check period: $CHECK_PERIOD" 

OUTPUT_FILE="$(jq --raw-output '.output_file' $CONFIG_PATH)"
echo "[$(date)][Info] Configuration - output file: $OUTPUT_FILE"

ATTRIBUTES_PROPERTY="$(jq --raw-output '.attributes_property' $CONFIG_PATH)"
echo "[$(date)][Info] Configuration - attributes property: $ATTRIBUTES_PROPERTY"

mkdir -p /share/hdd_tools/scripts/
mkdir -p /share/hdd_tools/performance_test/
cp /opt/storage.sh /share/hdd_tools/scripts/storage.sh
cp /opt/main.sh /share/hdd_tools/scripts/main.sh

echo "[$(date)][Info] Init run"
/share/hdd_tools/scripts/main.sh

if [ "$PERFORMANCE_CHECK" = "true" ]; then
    echo "[$(date)][Info] Run performance test"
    /share/hdd_tools/scripts/storage.sh /share/hdd_tools/performance_test/ > /share/hdd_tools/performance.log 2> /share/hdd_tools/performance.log
    cat /share/hdd_tools/performance.log | sed  -n '/Category/,$p'
    echo "[$(date)][Info] Performance test end"
fi

echo "[$(date)][Info] Cron tab update"
sed -i "s/TIME_TOKEN/$CHECK_PERIOD/g" /etc/cron.d/cron

echo "[$(date)][Info] Apply cron tab"
crontab /etc/cron.d/cron

if [ -b $HDD_PATH ]; then 
    echo "[$(date)][Info] Device $HDD_PATH found - starting CRON"    
    crond -f
else
    echo "[$(date)][Info] Device $HDD_PATH not found - exiting"    
    exit 1
fi

echo $(date) "HDD Tools exit"
