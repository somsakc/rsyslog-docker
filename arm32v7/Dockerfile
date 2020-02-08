# rsyslog docker container with logrotate
#
# usage:
#   docker run -it --rm --name rsyslog \
#     -e TZ=Asia/Bangkok \
#     -p 1514:514 \
#     -p 1514:514/udp \
#     -v /home/docker/rsyslog/arm32v7/rsyslog.d:/etc/rsyslog.d \
#     -v /home/docker/rsyslog/arm32v7/logs:/var/log \
#     mbixtech/arm32v7-rsyslog
#

FROM arm32v7/ubuntu:17.04

LABEL maintainer "somsakc@hotmail.com"
LABEL version="1.0"
LABEL description="rsyslog docker container with logrotate"

# install packages
RUN apt-get update && \
    apt-get install -y bash && \
    apt-get install -y tzdata && \
    apt-get install -y logrotate && \
    apt-get install -y rsyslog && \
    apt-get install -y supervisor && \
    apt-get clean

RUN dpkg -l |grep -e logrotate -e rsyslog -e supervisor && \
    rm -f /etc/rsyslog.d/* && \
    rm -fr /var/log/* && \
    rm -fr /var/lib/apt/lists/*

# custom configuration
COPY rsyslog.conf /etc/rsyslog.conf
COPY rsyslog.d/common /etc/rsyslog.d/common
COPY supervisord.conf /etc/supervisord.conf

# main entry program
ENTRYPOINT [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]

# expose tcpip ports
EXPOSE 514/tcp 514/udp

# mapping volumes
VOLUME [ "/etc/rsyslog.d", "/etc/logrotate.d", "/var/log" ]
