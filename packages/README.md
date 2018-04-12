
```
wget https://download.run.pivotal.io/openjdk-jdk/trusty/x86_64/openjdk-1.8.0_162.tar.gz
wget https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-3.10.0-04-unix.tar.gz
```

### Old CLI

```
bosh add blob openjdk-1.8.0_162.tar.gz java
bosh add blob nexus-3.10.0-04-unix.tar.gz nexus
```

If you have an access for the S3

```
bosh upload blobs
```

### New CLI (might work)

```
bosh add-blob --dir=.. openjdk-1.8.0_162.tar.gz java/openjdk-1.8.0_162.tar.gz
bosh add-blob --dir=.. nexus-3.10.0-04-unix.tar.gz nexus/nexus-3.10.0-04-unix.tar.gz
```

If you have an access for the S3 of cloudfoundry-community

```
bosh upload-blobs --dir=..
```

