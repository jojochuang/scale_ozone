#!/bin/bash

source `dirname "$0"`/conf.sh

./delete_from_all_dn.sh

for i in "${DN_HOSTNAME[@]}"; do
	hostname=$i$CLUSTER_DOMAIN
	echo "Create DN data on " $hostname

	ssh $SSH_PASSWORDLESS_USER@$hostname "sudo mkdir /var/lib/hadoop-ozone/fake_datanode; sudo chmod 755 /var/lib/hadoop-ozone/fake_datanode; sudo chown -R hdfs:hdfs /var/lib/hadoop-ozone/fake_datanode" &
done

dn_index=1

for i in "${DN_HOSTNAME[@]}"; do
	hostname=$i$CLUSTER_DOMAIN
	ssh $SSH_PASSWORDLESS_USER@$hostname sudo -u hdfs bash $SCALE_OZONE_SCRIPT_DIR/init_dn.sh ${dn_index} &
	dn_index=$(($dn_index + 1))
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done
