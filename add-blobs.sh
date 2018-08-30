#!/bin/sh

DIR=`pwd`

mkdir -p .downloads

cd .downloads



if [ ! -f ${DIR}/blobs/nexus/nexus-3.12.1-01-unix.tar.gz ];then
    curl -L -O -J https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-3.12.1-01-unix.tar.gz
    bosh add-blob --dir=${DIR} nexus-3.12.1-01-unix.tar.gz nexus/nexus-3.12.1-01-unix.tar.gz
fi

cd -
