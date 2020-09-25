#!/bin/bash

scp /Users/weichiu/sandbox/ozone/hadoop-ozone/dist/target/hadoop-ozone-1.1.0-SNAPSHOT.tar.gz root@weichiu-1.weichiu.root.hwx.site:/tmp/
ssh root@weichiu-1.weichiu.root.hwx.site scp /tmp/hadoop-ozone-1.1.0-SNAPSHOT.tar.gz root@weichiu-2.weichiu.root.hwx.site:/tmp/
ssh root@weichiu-1.weichiu.root.hwx.site scp /tmp/hadoop-ozone-1.1.0-SNAPSHOT.tar.gz root@weichiu-3.weichiu.root.hwx.site:/tmp/
