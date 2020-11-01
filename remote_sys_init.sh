#!/bin/bash
# This script should only be called once to prepare the machines for the datagen
echo "This script prepared the OS settings for the datagen. Run it only once!"

source `dirname "$0"`/conf.sh

for hostname in "${ALL_NODES[@]}"; do
	$SSH  $SSH_PASSWORDLESS_USER@$hostname$CLUSTER_DOMAIN sudo $SCALE_OZONE_SCRIPT_DIR/init_sys_prop.sh
done


for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done
