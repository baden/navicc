navicc
======
[![Build Status](https://travis-ci.org/baden/navicc.png)](https://travis-ci.org/baden/navicc)
[![Жучки](https://badge.waffle.io/baden/navicc.svg?label=ready&title=Ready)](http://waffle.io/baden/navicc)

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

Erlang versions supported: 17.1 and up
