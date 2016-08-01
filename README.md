navicc
======
[![Build Status](https://travis-ci.org/baden/navicc.png)](https://travis-ci.org/baden/navicc)
[![Жучки](https://badge.waffle.io/baden/navicc.svg?label=ready&title=Ready)](http://waffle.io/baden/navicc)


## New strategy

Run 1st time:

```
docker build --no-cache -t navicc .
docker run -d --name mongo mongo
# docker run -it --rm --link mongo -p 8981:8981 -p 8982:8982 -p 8983:8983 navicc
#docker run -d --name app1 --link mongo -p 8981:8981 -p 8982:8982 -p 8983:8983 navicc
docker run -dti --name app1 --link mongo -p 8981:8981 -p 8982:8982 -p 8983:8983 navicc
```

You can check working (from host):

```
curl -v localhost:8981/info
curl -v localhost:8982/1.0/info
```

You can start without access to host network (better way):

```
docker run -dti --name app1 --link mongo navicc
```

```
export GUEST=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' app1)
curl -v $GUEST:8981/info
curl -v $GUEST:8982/1.0/info

```

Logs:

```
docker logs app1
```

Attach to app console:

```
docker attach app1
```

Detach: Ctrl+p, Ctrl+q

Stop:

```
docker stop app1
```


Run later:
```
docker start mongo
docker start app1
#docker run -it --rm --link mongo -p 8981:8981 -p 8982:8982 -p 8983:8983 navicc
```

Stop and remove:

```
docker rm $(docker stop app1)
```

Stop and remove mongo container:

```
docker rm $(docker stop mongo)
```

## Usefull things

Connect to container's mongo database:

```
docker run -it --rm --link mongo mongo mongo --host mongo
```

### DockerHUB

You can run container direct from
[DockerHUB](https://hub.docker.com/r/baden/navicc/)
anywhere using baden/navicc tag name.

```
docker run -dti --name app1 --link mongo -p 8981:8981 -p 8982:8982 -p 8983:8983 baden/navicc
```

Update local copy after update copy on hub:

```
docker pull baden/navicc
```

----------------------------

GPS tracker server for new.navi.cc project.

#### To build the project:

    make

#### Install and start MongoDB

    mkdir mongo-db
    mongod --dbpath=`pwd`/mongo-db

#### To test the project:

    make tests

#### To run project:

    ./_rel/navicc_release/bin/navicc_release console

#### To connect by observer:

    make observer


#### Build deb-package

Install tools:

    sudo apt install ruby ruby-dev
    sudo gem install fpm

Make deb:

    make deb

Erlang versions supported: 17.1 and up
