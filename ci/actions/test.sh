#!/usr/bin/env bash
set -eux
. /usr/local/bin/start-bosh -o $PWD/manifests/operations/enable-dns.yml
source /tmp/local-bosh/director/env

bosh env
bosh vms