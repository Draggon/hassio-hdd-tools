#!/usr/bin/with-contenv bashio

echo "[$(date)][INFO] HDD Tools start"

CONFIG_PATH=/data/options.json

SENSOR_STATE_TYPE="$(jq --raw-output '.sensor_state_type' $CONFIG_PATH)"
echo "[$(date)][INFO] Configuration - sensor state type: $SENSOR_STATE_TYPE"

ADDITIONAL_SENSOR_STATE_TYPE="$(jq --raw-output '.additional_sensor_state_types' $CONFIG_PATH)"
echo "[$(date)][INFO] Configuration - additional sensor state type: $ADDITIONAL_SENSOR_STATE_TYPE"

PERFORMANCE_CHECK="$(jq --raw-output '.performance_check' $CONFIG_PATH)"
echo "[$(date)][INFO] Configuration - performance check enabled: $PERFORMANCE_CHECK"

HDD_PATH="$(jq --raw-output '.hdd_path' $CONFIG_PATH)"
echo "[$(date)][INFO] Configuration - disk path: $HDD_PATH"

ADDITIONAL_HDD_PATHS="$(jq --raw-output '.additional_hdd_paths[]' $CONFIG_PATH)"
echo "[$(date)][INFO] Configuration - additional disk paths: $ADDITIONAL_HDD_PATHS"

# Merge HDD_PATH and ADDITIONAL_HDD_PATHS into a single list
MERGED_HDD_PATHS=("$HDD_PATH" "${ADDITIONAL_HDD_PATHS[@]}")
echo "[$(date)][INFO] Configuration - Merged HDD Paths: ${MERGED_HDD_PATHS[*]}"

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

DEVICE_FOUND=false

for path in "${MERGED_HDD_PATHS[@]}"; do
    if [ -b "$path" ]; then
        echo "[$(date)][INFO] Device $path found"
        DEVICE_FOUND=true
    else
        echo "[$(date)][WARNING] Device $path not found"
    fi
done

if [ "$DEVICE_FOUND" = true ]; then
    echo "[$(date)][INFO] At least one Device found - starting CRON"
    crond -f
else
    echo "[$(date)][INFO] No devices found - exiting"
    exit 1
fi

echo "$(date) HDD Tools exit"
