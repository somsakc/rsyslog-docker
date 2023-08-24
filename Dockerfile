FROM ubuntu:22.04

LABEL maintainer "somsakc@hotmail.com"
LABEL version="1.4"
LABEL description="rsyslog container image with logrotate"

# default runtime environment
ENV RSYSLOG_EXTRA_OPTIONS=""
ENV RSYSLOG_ROTATE_FILES=3
ENV RSYSLOG_ROTATE_SIZE=10M

# install packages
RUN apt-get update && \
    apt-get install -y bash && \
    apt-get install -y logrotate && \
    apt-get install -y rsyslog && \
    apt-get install -y supervisor && \
    apt-get install -y tzdata && \
    apt-get clean

# clean up non-used files
RUN rm -f /etc/rsyslog.d/* && \
    rm -f /etc/logrotate.conf && \
    rm -fr /etc/logrotate.d && \
    rm -fr /etc/cron.d/ && \
    rm -fr /etc/cron.hourly && \
    rm -fr /etc/cron.daily && \
    rm -fr /etc/cron.weekly && \
    rm -fr /etc/cron.monthly && \
    rm -fr /etc/supervisor && \
    rm -fr /etc/systemd/system && \
    rm -fr /lib/systemd/system && \
    rm -fr /var/backups && \
    rm -fr /var/lib/apt/lists/* && \
    rm -fr /var/lib/systemd && \
    rm -fr /var/log/* && \
    rm -fr /var/mail && \
    rm -fr /var/run/* && \
    rm -fr /var/spool/cron && \
    rm -fr /var/spool/mail

# copy rsyslog configuration
COPY logrotate-hourly.conf /etc/logrotate-hourly.conf
COPY logrotate-hourly.d/rsyslog /etc/logrotate-hourly.d/rsyslog
COPY rsyslog-server /usr/local/bin/rsyslog-server
COPY rsyslog-logrotate /usr/local/bin/rsyslog-logrotate
COPY rsyslog-reload /usr/local/bin/rsyslog-reload
COPY rsyslog.conf /etc/rsyslog.conf
COPY rsyslog.d/00-global.conf /etc/rsyslog.d/00-global.conf
COPY rsyslog.d/10-syslog-dynamic.conf /etc/rsyslog.d/10-syslog-dynamic.conf
COPY supervisord.conf /etc/supervisord.conf

# setup user/group and permission
RUN groupadd -g 1000 rsyslog && \
    useradd -u 1000 -g rsyslog rsyslog && \
    chown root.root /usr/local/bin/rsyslog-server && \
    chown root.root /usr/local/bin/rsyslog-logrotate && \
    chown root.root /usr/local/bin/rsyslog-reload && \
    chown -R rsyslog.rsyslog /etc/logrotate-hourly.d && \
    chown -R rsyslog.rsyslog /var/lib/logrotate && \
    chown -R rsyslog.rsyslog /var/log && \
    chown -R rsyslog.rsyslog /var/run /run && \
    chmod 755 /usr/local/bin/rsyslog-server && \
    chmod 755 /usr/local/bin/rsyslog-logrotate && \
    chmod 755 /usr/local/bin/rsyslog-reload && \
    chmod 755 /etc/logrotate-hourly.d && \
    chmod 644 /etc/logrotate-hourly.conf /etc/logrotate-hourly.d/rsyslog && \
    chmod +s /usr/sbin/rsyslogd

# set restricted working user and group
USER rsyslog:rsyslog

# set working directory
WORKDIR /var/log

# expose tcpip ports
EXPOSE 5514/tcp 5514/udp

# mapping volumes
VOLUME [ "/var/log" ]

# main entry program
CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]
