FROM ubuntu:20.04

LABEL maintainer "somsakc@hotmail.com"
LABEL version="1.4"
LABEL description="rsyslog docker container with logrotate"

# given arguments
ARG BUILDPLATFORM
ARG TARGETPLATFORM

# print build and target platform
RUN printf "BUILDPLATFORM is set to $BUILDPLATFORM.\n"
RUN printf "TARGETPLATFORM is set to $TARGETPLATFORM.\n"

# install packages
RUN apt-get update && \
    apt-get install -y bash && \
    apt-get install -y logrotate && \
    apt-get install -y rsyslog && \
    apt-get install -y supervisor && \
    apt-get install -y tzdata && \
    apt-get clean

# clean up non-used files
RUN rm -f /etc/logrotate.d/* && \
    rm -f /etc/rsyslog.d/* && \
    rm -fr /etc/cron.d/* && \
    rm -fr /etc/cron.hourly/* && \
    rm -fr /etc/cron.daily/* && \
    rm -fr /etc/cron.weekly/* && \
    rm -fr /etc/cron.monthly/* && \
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
COPY logrotate.d/rsyslog /etc/logrotate.d/rsyslog
COPY rsyslog-logrotate /usr/local/bin/rsyslog-logrotate
COPY rsyslog-reload /usr/local/bin/rsyslog-reload
COPY rsyslog.conf /etc/rsyslog.conf
COPY rsyslog.d/00-global.conf /etc/rsyslog.d/00-global.conf
COPY rsyslog.d/11-syslog-dynamic.conf /etc/rsyslog.d/11-syslog-dynamic.conf
COPY supervisord.conf /etc/supervisord.conf

# setup user/group and permission
RUN groupadd -g 1000 rsyslog && \
    useradd -u 1000 -g rsyslog rsyslog && \
    chown root.root /usr/local/bin/rsyslog-logrotate && \
    chown root.root /usr/local/bin/rsyslog-reload && \
    chown -R rsyslog.rsyslog /var/lib/logrotate && \
    chown -R rsyslog.rsyslog /var/log && \
    chown -R rsyslog.rsyslog /var/run /run && \
    chmod 755 /usr/local/bin/rsyslog-logrotate && \
    chmod 755 /usr/local/bin/rsyslog-reload && \
    chmod 644 /etc/logrotate.d/rsyslog && \
    chmod +s /usr/sbin/logrotate && \
    chmod +s /usr/sbin/rsyslogd

# set working directory
WORKDIR /var/log

# set restricted working user and group
USER rsyslog:rsyslog

# main entry program
CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]

# expose tcpip ports
EXPOSE 514/tcp 514/udp

# mapping volumes
VOLUME [ "/etc/logrotate.d", "/etc/syslog.d", "/var/log" ]
