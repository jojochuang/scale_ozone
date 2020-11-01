#!/bin/bash

source conf.sh

for i in "${ALL_NODES[@]}"; do
	hostname=$i$CLUSTER_DOMAIN
	#if [ "$hostname" = "$first_node" ]; then
	#	continue
	#fi
	#echo "tell the first node to rsync the tarball with " $hostname
	echo "sending scale_ozone scripts to " $hostname
	rsync -aPr -e 'ssh -o StrictHostKeyChecking=no' . $SSH_PASSWORDLESS_USER@$hostname:$SCALE_OZONE_SCRIPT_DIR &
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done
