# netatalk-timemachine

**Alpine Linux based Netatalk AFP fileserver for the Apple Time Machine backups and more**

Based on:
- [Alpine Linux](https://hub.docker.com/r/library/alpine/)
- [Netatalk](https://pkgs.alpinelinux.org/packages?name=netatalk)

----------------

## Run

Running the service via Docker compose:
```sh
# Overrride mountpoint for timemachine data volume if needed. Default: `/mnt/timemachine`
# export TIMEMACHINE_VOLUME=/some/path
# Override container name prefix
# export COMPOSE_PROJECT_NAME=myapp
docker-compose -f netatalk-compose.yml up -d
```

>If you're not using Docker Compose, there is run example directly via Docker at [`tm_runner.sh`](./tm_runner.sh).
>
>**IMPORTANT:** **This is very basic example which is not alligned with [`netatalk-compose.yml`](./netatalk-compose.yml) and thus doesn't contain all the recommended container run options**

## Use

### Mac OS Time Machine disk

- Go to **Finder**, press **CMD+K**, insert `afp://<your-server-address>/`
- Provide credentials, defaults are:
  - username: `tmbackup`
  - password: `tmbackup`
- Go to **Time Machine Preferences** pane, press **Select Disk**, choose the network drive connected in the previous step, enter credentials again if asked
- Sometimes Mac OS doesn't show "unsupported" or non-Apple Time Machine network drives, but you can easily change that with one Terminal command:
  ```sh
  defaults write com.apple.systempreferences TMShowUnsupportedNetworkVolumes 1
  ```

>**Netatalk autodsicovery**
>
>In order for the **Netatalk** network share be automatically detected by **Finder** you should install and configure **Avahi daemon** at
>your server. Currently **Avahi** automatic deployment is out of the scope for this project, but you can use **Avahi** configuration file
>example [avahi/afpd.service](./avahi/afpd.service) which supposed to ease your life a bit ;). **Avahi daemon** installation and
>configuration example as well can be obtained here: https://gist.github.com/vi7/d23d00f313800e6f4042212326878de7

## Build, tag and push

**Note:** the example below is using my Docker HUB username and Project versioning

```sh
export TM_VERSION=0.3
docker build -t vi7al/netatalk-timemachine:${TM_VERSION} .
docker tag vi7al/netatalk-timemachine:${TM_VERSION} vi7al/netatalk-timemachine:latest
docker push vi7al/netatalk-timemachine:${TM_VERSION}
docker push vi7al/netatalk-timemachine
```

## Configure

### Add share

- open **afpd** config file in editor:
  ```sh
  docker exec -it <container_name> vi /etc/afp.conf
  ```

- add configuration section for the share at the end of the file. Example is below
  ```
  [Time Machine vol2]
  path = /timemachine/vol2
  valid users = tmbackup
  time machine = yes
  # the max size of the data folder (in Kb)
  vol size limit = 536870912
  ```

- force AFPd to re-read the config
  ```sh
  docker exec -it <container_name> pkill -HUP afpd
  ```
