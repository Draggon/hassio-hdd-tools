
echo "[$(date)][INFO] Updating drives database..."

SMARTCTL_DATABASE_OUTPUT=$(/usr/sbin/update-smart-drivedb)
echo "[$(date)][INFO] $SMARTCTL_DATABASE_OUTPUT"
