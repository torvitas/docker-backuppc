FROM alpine:3.5

RUN apk --update --no-cache add \
        bash \
        lighttpd \
        lighttpd-mod_auth \
        backuppc\<3.4 \
        perl-cgi \
        rsync \
        openssh-client \
        supervisor \
        ca-certificates


EXPOSE 80
ENTRYPOINT ["docker-entrypoint.sh"]

COPY src /
RUN mkdir -p /run/backuppc \
    && chown backuppc:backuppc /run/backuppc /etc/BackupPC -R \
    && mv /etc/BackupPC /usr/share/BackupPC/etc
