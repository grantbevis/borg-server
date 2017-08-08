FROM alpine:latest
MAINTAINER b3vis
#Install Borg & SSH
RUN apk add openssh sshfs borgbackup supervisor --no-cache
RUN adduser -D -u 1000 borg && \
    ssh-keygen -A && \
    mkdir /backups && \
    chown borg.borg /backups && \
    sed -i \
        -e 's/^#PasswordAuthentication yes$/PasswordAuthentication no/g' \
        -e 's/^PermitRootLogin without-password$/PermitRootLogin no/g' \
        /etc/ssh/sshd_config
COPY supervisord.conf /etc/supervisord.conf
RUN passwd -u borg
EXPOSE 22
CMD ["/usr/bin/supervisord"]
