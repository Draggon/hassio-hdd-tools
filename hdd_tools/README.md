<div align="center">
<h1>HDD Tools Hass.io Add-on</h1>
</div>

## General

This add-on provides information about HDD Temperature from S.M.A.R.T using smartmontools.
Temperature is visible in Home-Assistant via sensor sensor.hdd_temp.
At start add-on runs PiBenchmarks https://jamesachambers.com/raspberry-pi-storage-benchmarks-2019-benchmarking-script/ and stores output in /share/hdd_tools/performance.log

## Configuration

Configure the add-on via your Home Assistant front-end under **Supervisor (Hass.io) → Dashboard → HDD Tools**.

### Configuration parameters

| Parameter | Description |
|-----------|-------------|
| sensor_name | Name for the sensor which is exposed to home-assistant
| friendly_name | Friendly name for the sensor which is exposed to home-assistant
| performance_check | flag to enable or disable the execution of performance check at startup
| hdd_path | path to drive to monitor
| check_period | interval in minutes / how often to read temperature
| debug | flag to enable or disable debugging. Activate this if you want to debug which property from the JSON output of `smartctl` you want to be merged to the sensor.
| output_file | log file
| attributes_property | attribute you want to merge with the attributes in your sensor. Check the `output_file` for the available properties.

## Notes

Addon reguires Protection Mode to be disabled to access S.M.A.R.T data

## Credits

- https://www.smartmontools.org/
- https://github.com/TheRemote/PiBenchmarks
