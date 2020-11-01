#!/bin/bash

source `dirname "$0"`/conf.sh

for i in "${ALL_NODES[@]}"; do
	hostname=$i$CLUSTER_DOMAIN
	#if [ "$hostname" = "$first_node" ]; then
	#	continue
	#fi
	#echo "tell the first node to rsync the tarball with " $hostname
	if [ $hostname != `hostname` ]; then
		echo "sending tarball to " $hostname
		rsync -aP -e 'ssh -o StrictHostKeyChecking=no' /tmp/$OZONE_TARBALL $SSH_PASSWORDLESS_USER@$hostname:/tmp/ &
	fi
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done

for i in "${ALL_NODES[@]}"; do
	hostname=$i$CLUSTER_DOMAIN
	echo "untar at host " $hostname
	$SSH $SSH_PASSWORDLESS_USER@$hostname "cd /tmp && tar zxf /tmp/$OZONE_TARBALL" &
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done

for i in "${ALL_NODES[@]}"; do
	hostname=$i$CLUSTER_DOMAIN
	echo "update ownership at host " $hostname
	$SSH $SSH_PASSWORDLESS_USER@$hostname "chmod -R 777 $OZONE_BINARY_ROOT" &
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done
