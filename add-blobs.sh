#!/bin/sh

DIR=`pwd`

mkdir -p .downloads

cd .downloads


NEXUS_VERSION=3.14.0-04

if [ ! -f ${DIR}/blobs/nexus/nexus-${NEXUS_VERSION}-unix.tar.gz ];then
    curl -L -O -J https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz
    bosh add-blob --dir=${DIR} nexus-${NEXUS_VERSION}-unix.tar.gz nexus/nexus-${NEXUS_VERSION}-unix.tar.gz
fi

cd -
