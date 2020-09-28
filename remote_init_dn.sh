#!/bin/bash

source conf.sh

for i in "${DN_HOSTNAME[@]}"; do
	hostname=$i$CLUSTER_DOMAIN
	echo "Create DN data on " $hostname
	scp conf.sh root@$hostname:/tmp/
	scp init_dn.sh root@$hostname:/tmp/
	scp dn_uuid.txt root@$hostname:/tmp/

	ssh root@$hostname mkdir /var/lib/hadoop-ozone/fake_datanode
	ssh root@$hostname chmod 755 /var/lib/hadoop-ozone/fake_datanode
	ssh root@$hostname chown -R hdfs:hdfs /var/lib/hadoop-ozone/fake_datanode
done

dn_index=1

for i in "${DN_HOSTNAME[@]}"; do
	hostname=$i$CLUSTER_DOMAIN
	ssh root@$hostname sudo -u hdfs bash /tmp/init_dn.sh ${dn_index} &
	dn_index=$(($dn_index + 1))
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done
