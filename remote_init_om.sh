#!/bin/bash

source conf.sh

echo "Create OCM data on " $OM_HOST

scp init_om.sh root@$OM_HOST:/tmp/
scp gen_om.sh root@$OM_HOST:/tmp/
scp dn_uuid.txt root@$OM_HOST:/tmp/

ssh root@$OM_HOST mkdir /var/lib/hadoop-ozone/fake_om
ssh root@$OM_HOST chmod 755 /var/lib/hadoop-ozone/fake_om
ssh root@$OM_HOST chown -R hdfs:hdfs /var/lib/hadoop-ozone/fake_om
ssh root@$OM_HOST sudo -u hdfs bash /tmp/init_om.sh $SCM_HOST
ssh root@$OM_HOST sudo -u hdfs bash /tmp/gen_om.sh $DN_TOTAL

