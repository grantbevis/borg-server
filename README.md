# Borg Backup Server Container

## Description

My take on a Borgbackup Server as a Docker container to facilicate the backing up of remote machines using [Borgbackup](https://github.com/borgbackup)
---
## Dockerfile
```
FROM alpine:latest
MAINTAINER b3vis
#Install Borg & SSH
RUN apk add openssh sshfs borgbackup supervisor --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/
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
```
---

## Usage

I personally like to split my ssh keys out of the main container to make updates and management easier. To achieve this I create a persistent storage container;

`docker run -d -v /home/borg/.ssh --name borg-keys-storage busybox:latest`

* Container Creation:

```
docker create \
  --name=borg-server \
  --restart=always \
  --volumes-from borg-keys-storage \
  -v path/to/backups:/backups \
  -p 2022:22 \
  b3vis/borg-server
```
* Note

After creating the container you will need to start the container add your own public keys
---
