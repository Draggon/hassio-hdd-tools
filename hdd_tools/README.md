<div align="center">
<h1>HDD Tools Hass.io Add-on</h1>
</div>

## General

This add-on provides information about HDD Temperature from S.M.A.R.T using smartmontools.
- Temperature is visible in Home-Assistant via sensor `sensor.hdd_temp`.
- SMART attributes are mapped to `sensor.hdd_temp` sensor attributes.
- Optionally, at start, add-on runs PiBenchmarks https://jamesachambers.com/raspberry-pi-storage-benchmarks-2019-benchmarking-script/ and stores output in _/share/hdd_tools/performance.log_

Check the *Documentation* tab to get more information about `options` and `parameters`.

## Credits

- https://www.smartmontools.org/
- https://github.com/TheRemote/PiBenchmarks
