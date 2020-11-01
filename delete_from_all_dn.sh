#!/bin/bash

source `dirname "$0"`/conf.sh
for dn in ${DN_HOSTNAME[@]}; do
	ssh root@${dn}$CLUSTER_DOMAIN $SCALE_OZONE_SCRIPT_DIR/delete_from_all_disks.sh &
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done
