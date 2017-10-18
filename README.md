# BOSH Release for Nexus Repository Manager

## How to deploy nexus-boshrelease

A sample manifest is following:

``` yml
---
name: nexus

releases:
- name: nexus
  version: 0.4.0
  url: https://github.com/making/nexus-boshrelease/releases/download/0.4.0/nexus-0.4.0.tgz
  sha1: 20222ddbbec1e38874a6ab737268d25e6574ca29

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
  azs: [z1]
  networks:
  - name: default
    static_ips: [((internal_ip))]
  jobs:
  - name: nexus
    release: nexus
  - name: nexus-backup
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
bosh2 deploy -d nexus nexus.yml -v internal_ip=<your_static_ip>
```

You will be able to access `http://<your_static_ip>:8081`


## How to enable SSL

A sample manifest is following:

``` yml
---
name: nexus

releases:
- name: nexus
  version: 0.4.0
  url: https://github.com/making/nexus-boshrelease/releases/download/0.4.0/nexus-0.4.0.tgz
  sha1: 20222ddbbec1e38874a6ab737268d25e6574ca29

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
  azs: [z1]
  networks:
  - name: default
    static_ips: [((internal_ip))]
  jobs:
  - name: nexus
    release: nexus
    properties:
      nexus:
        ssl_cert: ((nexus_ssl.certificate))
        ssl_key: ((nexus_ssl.private_key))
        ssl_only: true
  - name: nexus-backup
    release: nexus

update:
  canaries: 1
  max_in_flight: 1
  serial: false
  canary_watch_time: 1000-60000
  update_watch_time: 1000-60000

variables:
- name: nexus_pkcs12_password
  type: password
- name: nexus_keystore_password
  type: password
- name: default_ca
  type: certificate
  options:
    is_ca: true
    common_name: ca
- name: nexus_ssl
  type: certificate
  options:
    ca: default_ca
    common_name: ((internal_ip))
    alternative_names: 
    - ((internal_ip))
```

then,

```
bosh2 deploy -d nexus nexus.yml -v internal_ip=<your_static_ip>
```

You will be able to access `https://<your_static_ip>:8443`


## Backup and Restore with [BBR](http://www.boshbackuprestore.io/)

### Backup

```
$ BOSH_CLIENT_SECRET=<BOSH_CLIENT_SECRET> \
  bbr deployment \
  --target <BOSH_TARGET_IP> \
  --username <BOSH_CLIENT> \
  --deployment nexus \
  --ca-cert <PATH_TO_BOSH_SERVER_CERTIFICATE> \
    backup
```

### Restore

```
$ BOSH_CLIENT_SECRET=<BOSH_CLIENT_SECRET> \
  bbr deployment \
  --target <BOSH_TARGET_IP> \
  --username <BOSH_CLIENT> \
  --deployment nexus \
  --ca-cert <PATH_TO_BOSH_SERVER_CERTIFICATE> \
    backup \
  --artifact-path <PATH_TO_ARTIFACT_TO_RESTORE>
```

## How to develop this bosh release

This bosh release uses local blobstore and blobs/pacakges are not shared among developers.
Instead of not sharing, this bosh release assumes using Concourse to build and test this.

You can deploy this to a bosh director in docker with the following command:

```
fly -t <target-name> tj -j <pipeline-name>/bosh-deploy-dev-in-docker --watch
```