# netatalk-timemachine

Version: **0.2-3.1.10-r1**

## Build, tag and push

```sh
docker build -t vi7al/netatalk-timemachine:${VERSION} .
docker tag vi7al/netatalk-timemachine:${VERSION} vi7al/netatalk-timemachine:latest
docker push vi7al/netatalk-timemachine:${VERSION}
docker push vi7al/netatalk-timemachine
```

## Run

Running the service via Docker compose:
```sh
export TIMEMACHINE_VOLUME=/some/path
docker-compose -f netatalk-compose.yml up -d
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
