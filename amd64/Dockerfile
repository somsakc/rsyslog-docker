FROM ubuntu:20.04

LABEL maintainer "somsakc@hotmail.com"
LABEL version="1.3"
LABEL description="rsyslog docker container with logrotate"

# install packages
RUN apt-get update && \
    apt-get install -y anacron && \
    apt-get install -y bash && \
    apt-get install -y logrotate && \
    apt-get install -y rsyslog && \
    apt-get install -y supervisor && \
    apt-get install -y tzdata && \
    apt-get clean

# clean up non-used files
RUN rm -f /etc/cron.d/* && \
    rm -f /etc/cron.hourly/* && \
    rm -f /etc/cron.daily/* && \
    rm -f /etc/cron.weekly/* && \
    rm -f /etc/cron.monthly/* && \
    rm -f /etc/logrotate.d/* && \
    rm -f /etc/rsyslog.d/* && \
    rm -fr /etc/supervisor && \
    rm -fr /etc/systemd/system && \
    rm -fr /lib/systemd/system && \
    rm -fr /var/lib/apt/lists/* && \
    rm -fr /var/log/* && \
    rm -fr /var/run/*

# copy rsyslog configuration
COPY logrotate.d/rsyslog /etc/logrotate.d/rsyslog
COPY logrotate.cron /etc/cron.hourly/logrotate
COPY rsyslog-reload /usr/local/bin/rsyslog-reload
COPY rsyslog.conf /etc/rsyslog.conf
COPY rsyslog.d/00-global.conf /etc/rsyslog.d/00-global.conf
COPY rsyslog.d/11-syslog-dynamic.conf /etc/rsyslog.d/11-syslog-dynamic.conf
COPY supervisord.conf /etc/supervisord.conf

# setup user/group and permission
RUN groupadd -g 1000 rsyslog && \
    useradd -u 1000 -g rsyslog rsyslog && \
    chown -R rsyslog.rsyslog /var/log && \
    chmod 755 /usr/local/bin/rsyslog-reload && \
    chmod 755 /etc/cron.hourly/logrotate && \
    chmod 644 /etc/logrotate.d/rsyslog

# set working directory
WORKDIR /var/log

# main entry program
CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]

# expose tcpip ports
EXPOSE 514/tcp 514/udp

# mapping volumes
VOLUME [ "/etc/syslog.d", "/var/log" ]
