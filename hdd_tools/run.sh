#!/usr/bin/with-contenv bashio

echo "[$(date)][INFO] HDD Tools start"

CONFIG_PATH=/data/options.json

SENSOR_STATE_TYPE="$(jq --raw-output '.sensor_state_type' $CONFIG_PATH)"
echo "[$(date)][INFO] Configuration - sensor state type: $SENSOR_STATE_TYPE"

PERFORMANCE_CHECK="$(jq --raw-output '.performance_check' $CONFIG_PATH)"
echo "[$(date)][INFO] Configuration - performance check enabled: $PERFORMANCE_CHECK"

HDD_PATH="$(jq --raw-output '.hdd_path' $CONFIG_PATH)"
echo "[$(date)][INFO] Configuration - disk path: $HDD_PATH" 

DEVICE_TYPE="$(jq --raw-output '.device_type' $CONFIG_PATH)"
echo "[$(date)][INFO] Configuration - device type: $DEVICE_TYPE"

SMART_CHECK_PERIOD="$(jq --raw-output '.check_period' $CONFIG_PATH)"
echo "[$(date)][INFO] Configuration - check period: $SMART_CHECK_PERIOD"

DATABASE_UPDATE="$(jq --raw-output '.database_update' $CONFIG_PATH)"
echo "[$(date)][INFO] Configuration - database update: $DATABASE_UPDATE"

DATABASE_UPDATE_PERIOD="$(jq --raw-output '.database_update_period' $CONFIG_PATH)"
echo "[$(date)][INFO] Configuration - database update period: $DATABASE_UPDATE_PERIOD"

OUTPUT_FILE="$(jq --raw-output '.output_file' $CONFIG_PATH)"
echo "[$(date)][INFO] Configuration - output file: $OUTPUT_FILE"

ATTRIBUTES_PROPERTY="$(jq --raw-output '.attributes_property' $CONFIG_PATH)"
echo "[$(date)][INFO] Configuration - attributes property: $ATTRIBUTES_PROPERTY"

mkdir -p /share/hdd_tools/scripts/
mkdir -p /share/hdd_tools/performance_test/
cp -p /opt/storage.sh /share/hdd_tools/scripts/storage.sh
cp -p /opt/main.sh /share/hdd_tools/scripts/main.sh
cp -p /opt/database.sh /share/hdd_tools/scripts/database.sh

echo "[$(date)][INFO] Init run"
/share/hdd_tools/scripts/main.sh

if [ "$PERFORMANCE_CHECK" = "true" ]; then
    echo "[$(date)][INFO] Run performance test"
    /share/hdd_tools/scripts/storage.sh /share/hdd_tools/performance_test/ > /share/hdd_tools/performance.log 2> /share/hdd_tools/performance.log
    cat /share/hdd_tools/performance.log | sed  -n '/Category/,$p'
    echo "[$(date)][INFO] Performance test end"
fi

echo "[$(date)][INFO] Cron tab SMART update"
sed -i "s/SMART_TIME_TOKEN/$SMART_CHECK_PERIOD/g" /etc/cron.d/cron

if [ "$DATABASE_UPDATE" = "true" ]; then
    echo "[$(date)][INFO] Cron tab database update ENABLED"
    /share/hdd_tools/scripts/database.sh
    sed -i "s/#\(.*\)DATABASE_TIME_TOKEN/\1$DATABASE_UPDATE_PERIOD/g" /etc/cron.d/cron
else
    echo "[$(date)][INFO] Cron tab database update DISABLED"
fi

echo "[$(date)][INFO] Apply cron tab"
crontab /etc/cron.d/cron

if [ -b $HDD_PATH ]; then 
    echo "[$(date)][INFO] Device $HDD_PATH found - starting CRON"    
    crond -f
else
    echo "[$(date)][INFO] Device $HDD_PATH not found - exiting"    
    exit 1
fi

echo $(date) "HDD Tools exit"
