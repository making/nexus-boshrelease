# BOSH Release for Nexus Repository Manager

## How to deploy nexus-boshrelease

A sample manifest is following:

``` yml
---
name: nexus

releases:
- name: nexus
  version: 0.11.0
  url: https://github.com/making/nexus-boshrelease/releases/download/0.11.0/nexus-boshrelease-0.11.0.tgz
  sha1: d186a8affb161a4b282079de16080d8aaa4c5132
- name: openjdk
  version: 0.1.1
  url: https://github.com/making/openjdk-boshrelease/releases/download/0.1.1/openjdk-boshrelease-0.1.1.tgz
  sha1: 06e397150e924755421d21452bd8d42e4f4bed60
  
stemcells:
- alias: trusty
  os: ubuntu-trusty
  version: latest

instance_groups:
- name: nexus
  instances: 1
  vm_type: default
  persistent_disk: default
  stemcell: trusty
  azs: [z1]
  networks:
  - name: default
    static_ips: [((internal_ip))]
  jobs:
  - name: java
    release: openjdk
  - name: nexus
    release: nexus
    properties:
      nexus:
        heap_size: 768M
        max_direct_memory_size: 512M
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
bosh deploy -d nexus nexus.yml -v internal_ip=<your_static_ip>
```

You will be able to access `http://<your_static_ip>:8081`


## How to enable SSL

A sample manifest is following:

``` yml
---
name: nexus

releases:
- name: nexus
  version: 0.11.0
  url: https://github.com/making/nexus-boshrelease/releases/download/0.11.0/nexus-boshrelease-0.11.0.tgz
  sha1: d186a8affb161a4b282079de16080d8aaa4c5132
- name: openjdk
  version: 0.1.1
  url: https://github.com/making/openjdk-boshrelease/releases/download/0.1.1/openjdk-boshrelease-0.1.1.tgz
  sha1: 06e397150e924755421d21452bd8d42e4f4bed60

stemcells:
- alias: trusty
  os: ubuntu-trusty
  version: latest

instance_groups:
- name: nexus
  instances: 1
  vm_type: default
  persistent_disk: default
  stemcell: trusty
  azs: [z1]
  networks:
  - name: default
    static_ips: [((internal_ip))]
  jobs:
  - name: java
    release: openjdk
  - name: nexus
    release: nexus
    properties:
      nexus:
        heap_size: 768M
        max_direct_memory_size: 512M
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
bosh deploy -d nexus nexus.yml -v internal_ip=<your_static_ip>
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

## How to create stand-alone vm on VirtualBox

Download [nexus.yml](deployment/nexus.yml).

```
$ bosh create-env nexus.yml -v internal_ip=192.168.230.40  --vars-store ./nexus-creds.yml
```

https://192.168.230.40

You can get `admin` user's password as follows:

```
bosh int nexus-creds.yml --path /admin_password
```

## How to develop this bosh release

This bosh release uses local blobstore and blobs/pacakges are not shared among developers.
Instead of not sharing, this bosh release assumes using Concourse to build and test this.

You can deploy this to a bosh director in docker with the following command:

```
fly -t <target-name> tj -j <pipeline-name>/bosh-deploy-dev-in-docker --watch
```
