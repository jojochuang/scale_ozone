#!/bin/bash

source conf.sh

OZONE_TARBALL="hadoop-ozone-1.1.0-SNAPSHOT.tar.gz"

#first_node=${DN_HOSTNAME[0]}$CLUSTER_DOMAIN
#echo "sending the ozone tarball to the first node " $first_node
#rsync -aP /tmp/$OZONE_TARBALL root@$first_node:/tmp/

for i in "${ALL_NODES[@]}"; do
	hostname=$i$CLUSTER_DOMAIN
	#if [ "$hostname" = "$first_node" ]; then
	#	continue
	#fi
	#echo "tell the first node to rsync the tarball with " $hostname
	echo "sending tarball to " $hostname
	rsync -aP -e 'ssh -o StrictHostKeyChecking=no' /tmp/$OZONE_TARBALL root@$hostname:/tmp/ &
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done

for i in "${ALL_NODES[@]}"; do
	hostname=$i$CLUSTER_DOMAIN
	echo "untar at host " $hostname
	ssh root@$hostname "cd /tmp && tar zxf /tmp/$OZONE_TARBALL" &
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done

for i in "${ALL_NODES[@]}"; do
	hostname=$i$CLUSTER_DOMAIN
	echo "update ownership at host " $hostname
	ssh root@$hostname "chmod -R 777 $OZONE_BINARY_ROOT" &
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done
