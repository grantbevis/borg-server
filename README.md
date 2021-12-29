# Borg Backup Server Container
![alt text](https://borgbackup.readthedocs.io/en/stable/_static/logo.png "Borgbackup")

### Description

My take on a Borgbackup Server as a Docker container to faciliate the backing up of remote machines using [Borgbackup](https://github.com/borgbackup)

### Usage

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
  ghcr.io/b3vis/borg-server
```

### Note
After creating the container you will need to start the container add your own public keys.
