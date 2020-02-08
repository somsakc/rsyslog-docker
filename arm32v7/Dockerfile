# rsyslog docker container with logrotate
#
# usage:
#   mkdir /home/docker/rsyslog/log
#   touch /home/docker/rsyslog/log/syslog.log
#   chown -R 1000.1000 /home/docker/rsyslog/log
#   docker run -it --rm --name rsyslog \
#     -e TZ=Asia/Bangkok \
#     -p 1514:514 \
#     -p 1514:514/udp \
#     -v /home/docker/rsyslog/rsyslog.d:/etc/rsyslog.d \
#     -v /home/docker/rsyslog/log:/log \
#     mbixtech/rsyslog
#

FROM arm32v7/ubuntu:18.04

LABEL maintainer "somsakc@hotmail.com"
LABEL version="1.1"
LABEL description="rsyslog docker container with logrotate"

# install packages
RUN apt-get update && \
    apt-get install -y bash && \
    apt-get install -y tzdata && \
    apt-get install -y logrotate && \
    apt-get install -y rsyslog && \
    apt-get install -y supervisor && \
    apt-get clean

# clean up non-used files
RUN dpkg -l | grep -e logrotate -e rsyslog -e supervisor && \
    rm -f /etc/cron.hourly/* && \
    rm -f /etc/cron.daily/* && \
    rm -f /etc/cron.weekly/* && \
    rm -f /etc/cron.monthly/* && \
    rm -f /etc/rsyslog.d/* && \
    rm -fr /var/log/* && \
    rm -fr /var/lib/apt/lists/*

# copy rsyslog configuration
COPY rsyslog-reload /usr/local/bin/rsyslog-reload
COPY rsyslog.conf /etc/rsyslog.conf
COPY rsyslog.d/00-global.conf /etc/rsyslog.d/00-global.conf
COPY rsyslog.d/11-syslog.conf /etc/rsyslog.d/11-syslog.conf
COPY logrotate.conf /etc/logrotate.conf
COPY logrotate.cron /etc/cron.daily/logrotate
COPY supervisord.conf /etc/supervisord.conf

# setup user/group and permission
RUN groupadd -g 1000 rsyslog && \
    useradd -u 1000 -g rsyslog rsyslog && \
    mkdir /log && \
    touch /log/syslog.log && \
    chown -R rsyslog.rsyslog /log && \
    chmod 755 /usr/local/bin/rsyslog-reload && \
    chmod 755 /etc/cron.daily/logrotate && \
    chmod 644 /etc/logrotate.d/rsyslog

# set working directory
WORKDIR /log

# main entry program
ENTRYPOINT [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]

# expose tcpip ports
EXPOSE 514/tcp 514/udp

# mapping volumes
VOLUME [ "/log" ]
