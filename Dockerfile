FROM alpine:3.16.0
LABEL maintainer="b3vis"

#Install Borg & SSH
RUN apk add --no-cache \
    openssh=9.3_p1-r3 \
    sshfs=3.7.3-r1 \
    borgbackup=1.2.4-r4 \
    supervisor=4.2.5-r2
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
