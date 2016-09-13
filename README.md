navicc
======
[![Build Status](https://travis-ci.org/baden/navicc.png)](https://travis-ci.org/baden/navicc)
[![Жучки](https://badge.waffle.io/baden/navicc.svg?label=ready&title=Ready)](http://waffle.io/baden/navicc)

GPS tracker server for new.navi.cc project.

Erlang versions supported: 17.1 and up

## Project components

* Сбор статистики - [navistats](https://github.com/baden/navistats)
* Работа с базой данных - [navidb](https://github.com/baden/navidb)
* Прием данных с трекеров - [navipoint](https://github.com/baden/navipoint)
* API - [naviapi](https://github.com/baden/naviapi)
* Дуплексный обмен для API - [naviws](https://github.com/baden/naviws)

## Dependencies

### Erlang

```shell
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
sudo dpkg -i erlang-solutions_1.0_all.deb
rm ./erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get install -y erlang
```

### MongoDB

```shell
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu `lsb_release -cs`/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo servise mongod start
```

#### To build the project:

```shell
make
```

#### Install and start MongoDB

    mkdir mongo-db
    mongod --dbpath=`pwd`/mongo-db

#### To test the project:

```shell
make elvis
make tests
# make xref
```

#### To run project:

```
    ./_rel/navicc_release/bin/navicc_release console
```

#### To connect by observer:

```shell
    make observer
```

### Documentation

```shell
    make docs
```
