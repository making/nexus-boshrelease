#!/bin/sh

echo y | fly -t home set-pipeline -p nexus-boshrelease -c pipeline.yml -l credentials.yml