#!/bin/bash
# This script should only be called once to prepare the machines for the datagen
echo "This script prepared the OS settings for the datagen. Run it only once!"

source conf.sh

for hostname in "${ALL_NODES[@]}"; do
	scp init_sys_prop.sh root@$hostname$CLUSTER_DOMAIN:/tmp/init_sys_prop.sh &
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done

for hostname in "${ALL_NODES[@]}"; do
	ssh root@$hostname$CLUSTER_DOMAIN /tmp/init_sys_prop.sh
done


for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done
