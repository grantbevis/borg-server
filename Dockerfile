FROM alpine:3
LABEL maintainer="b3vis"

#Install Borg & SSH
RUN apk add --no-cache openssh=8.8_p1-r1 sshfs=3.7.2-r0 borgbackup=1.1.17-r2 supervisor=4.2.2-r2
RUN adduser -D -u 1000 borg && \
    passwd -u borg && \
    mkdir -m 0700 /backups && \
    chown borg.borg /backups && \
    sed -i \
        -e 's/^#PasswordAuthentication yes$/PasswordAuthentication no/g' \
        -e 's/^PermitRootLogin without-password$/PermitRootLogin no/g' \
        /etc/ssh/sshd_config

COPY supervisord.conf /etc/supervisord.conf
COPY service.sh /usr/local/bin/service.sh

EXPOSE 22
VOLUME /etc/ssh

CMD ["/usr/bin/supervisord"]
