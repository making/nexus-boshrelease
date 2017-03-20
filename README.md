# BOSH Release for Nexus Repository Manager

## How to deploy nexus-boshrelease

```
VERSION=0.0.1
bosh upload release https://github.com/making/nexus-boshrelease/releases/download/${VERSION}/nexus-${VERSION}.tgz
```

A sample manifest is following:

``` yml
---
name: nexus

director_uuid: <%= `bosh status --uuid` %>

releases:
- name: nexus
  version: latest

stemcells:
- alias: trusty
  os: ubuntu-trusty
  version: latest

instance_groups:
- name: nexus
  instances: 1
  vm_type: default
  persist_disk: default
  stemcell: trusty
  azs: [az1]
  networks:
  - name: default
  jobs:
  - name: nexus
    release: nexus

update:
  canaries: 1
  max_in_flight: 1
  serial: false
  canary_watch_time: 1000-60000
  update_watch_time: 1000-60000
```

then,

```
bosh deployment manifest.yml
bosh -n deploy
```
