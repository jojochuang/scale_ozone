#!/bin/bash

scp init_om.sh root@weichiu-1.weichiu.root.hwx.site:/tmp/
scp gen_om.sh root@weichiu-1.weichiu.root.hwx.site:/tmp/
scp dn_uuid.txt root@weichiu-1.weichiu.root.hwx.site:/tmp/

ssh root@weichiu-1.weichiu.root.hwx.site mkdir /var/lib/hadoop-ozone/fake_om
ssh root@weichiu-1.weichiu.root.hwx.site chmod 755 /var/lib/hadoop-ozone/fake_om
ssh root@weichiu-1.weichiu.root.hwx.site chown -R hdfs:hdfs /var/lib/hadoop-ozone/fake_om
ssh root@weichiu-1.weichiu.root.hwx.site sudo -u hdfs bash /tmp/init_om.sh
ssh root@weichiu-1.weichiu.root.hwx.site sudo -u hdfs bash /tmp/gen_om.sh 3

