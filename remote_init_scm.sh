#!/bin/bash

source conf.sh
echo "Create SCM data on " $SCM_HOST

scp init_scm.sh root@$SCM_HOST:/tmp/
scp gen_scm.sh root@$SCM_HOST:/tmp/
scp dn_uuid.txt root@$SCM_HOST:/tmp/

ssh root@$SCM_HOST mkdir /var/lib/hadoop-ozone/fake_scm
ssh root@$SCM_HOST chmod 755 /var/lib/hadoop-ozone/fake_scm
ssh root@$SCM_HOST chown -R hdfs:hdfs /var/lib/hadoop-ozone/fake_scm
ssh root@$SCM_HOST sudo -u hdfs bash /tmp/init_scm.sh $SCM_HOST
ssh root@$SCM_HOST sudo -u hdfs bash /tmp/gen_scm.sh $DN_TOTAL
