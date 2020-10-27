#!/usr/bin/env bash
set -eux
. /usr/local/bin/start-bosh
source /tmp/local-bosh/director/env

bosh env
bosh vms