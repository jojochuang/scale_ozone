#!/bin/bash

scp init_scm.sh root@weichiu-2.weichiu.root.hwx.site:/tmp/
scp gen_scm.sh root@weichiu-2.weichiu.root.hwx.site:/tmp/
scp dn_uuid.txt root@weichiu-2.weichiu.root.hwx.site:/tmp/

ssh root@weichiu-1.weichiu.root.hwx.site mkdir /var/lib/hadoop-ozone/fake_scm
ssh root@weichiu-1.weichiu.root.hwx.site chmod 755 /var/lib/hadoop-ozone/fake_scm
ssh root@weichiu-1.weichiu.root.hwx.site chown -R hdfs:hdfs /var/lib/hadoop-ozone/fake_scm
ssh root@weichiu-2.weichiu.root.hwx.site sudo -u hdfs bash /tmp/init_scm.sh
ssh root@weichiu-2.weichiu.root.hwx.site sudo -u hdfs bash /tmp/gen_scm.sh 3
