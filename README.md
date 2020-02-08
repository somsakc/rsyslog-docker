# rsyslog container

## How does it work
The container composes of supervisord as primary process. It is the entry point and it starts other child processes as below.
* cron process - invoke logrotate job daily for rotating all rsyslog files located under /log directory.
* rsyslog process - receive syslog message incoming from outside.

## How to up and run the container
### Alternative 1: Docker command line

```bash
$ sudo mkdir log
$ sudo touch log/syslog.log
$ sudo chown -R 1000:1000 log
$ docker run --rm -n rsyslog -p "1514:514" -p "1514:514/udp" -v $(pwd)/rsyslog.d:/etc/rsyslog.d -v $(pwd)/log:/log mbixtech/rsyslog
```

### Alternative 2: Docker composer file
See [docker-compose.yml](docker-compose.yml) file as a sample. Customize it regarding your desire.

