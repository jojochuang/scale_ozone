#!/bin/bash

source conf.sh

./delete_from_all_dn.sh

for dn in ${DN_HOSTNAME[@]}; do
	#for i in $(seq 1 48); do
		#echo "delete data from DN " $dn " disk " $i
		echo "delete data from DN " $dn 
		#ssh root@${dn}$CLUSTER_DOMAIN "for disk in /data/disk*; do rm -rf $disk/hadoop-ozone/datanode/data/hdds/* & done" &
		ssh root@${dn}$CLUSTER_DOMAIN "rm -rf /data/disk*/hadoop-ozone/datanode/data/hdds/*" &
	#done
done

for job in `jobs -p`
do
	echo "Waiting for completion of data delete " $job
	wait $job
done

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
