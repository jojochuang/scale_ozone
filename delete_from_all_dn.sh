#!/bin/bash

source conf.sh
for dn in ${DN_HOSTNAME[@]}; do
	scp delete_from_all_disks.sh root@$dn$CLUSTER_DOMAIN:/tmp/ &
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done

for dn in ${DN_HOSTNAME[@]}; do
	ssh root@${dn}$CLUSTER_DOMAIN /tmp/delete_from_all_disks.sh &
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done
