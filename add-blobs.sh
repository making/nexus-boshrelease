#!/bin/sh

DIR=`pwd`

mkdir -p .downloads

cd .downloads



if [ ! -f ${DIR}/blobs/java/openjdk-1.8.0_162.tar.gz ];then
    curl -L -O -J https://download.run.pivotal.io/openjdk-jdk/trusty/x86_64/openjdk-1.8.0_162.tar.gz
    bosh add-blob --dir=${DIR} openjdk-1.8.0_162.tar.gz java/openjdk-1.8.0_162.tar.gz
fi

if [ ! -f ${DIR}/blobs/nexus/nexus-3.12.0-01-unix.tar.gz ];then
    curl -L -O -J https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-3.12.0-01-unix.tar.gz
    bosh add-blob --dir=${DIR} nexus-3.12.0-01-unix.tar nexus/nexus-3.12.0-01-unix.tar.gz
fi

cd -