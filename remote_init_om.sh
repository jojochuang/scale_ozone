#!/bin/bash

source conf.sh

for OM_HOST in "${OM_HOSTS[@]}"; do
	echo "Copy files to " $OM_HOST " to prepare for OM init"

	scp conf.sh root@$OM_HOST:/tmp/
	scp init_om.sh root@$OM_HOST:/tmp/
	scp gen_om.sh root@$OM_HOST:/tmp/
	scp dn_uuid.txt root@$OM_HOST:/tmp/

	ssh root@$OM_HOST mkdir /var/lib/hadoop-ozone/fake_om
	ssh root@$OM_HOST chmod 755 /var/lib/hadoop-ozone/fake_om
	ssh root@$OM_HOST chown -R hdfs:hdfs /var/lib/hadoop-ozone/fake_om
done

om_index=0

for OM_HOST in "${OM_HOSTS[@]}"; do
	echo "Run init_om.sh " $OM_HOST
	ssh root@$OM_HOST sudo -u hdfs bash /tmp/init_om.sh $SCM_HOST ${om_index} &
	om_index=$(($om_index + 1))
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done

for OM_HOST in "${OM_HOSTS[@]}"; do
	echo "Run gen_om.sh " $OM_HOST
	ssh root@$OM_HOST sudo -u hdfs bash /tmp/gen_om.sh $DN_TOTAL &
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done
