ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache coreutils util-linux ncurses build-base make fio hdparm perl smartmontools vim apk-cron gnupg

# Copy cron file to the cron.d directory
COPY data/cron /etc/cron.d/cron
RUN chmod 0644 /etc/cron.d/cron

# Copy script
COPY data/main.sh /opt/main.sh
RUN chmod 0755 /opt/main.sh

COPY data/storage.sh /opt/storage.sh
RUN chmod 0755 /opt/storage.sh

COPY data/database.sh /opt/database.sh
RUN chmod 0755 /opt/database.sh

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

# Create the log file to be able to run tail
CMD [ "/run.sh" ]