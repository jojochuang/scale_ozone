#!/bin/bash

source conf.sh

OZONE_TARBALL="hadoop-ozone-1.1.0-SNAPSHOT.tar.gz"

first_node=${DN_HOSTNAME[0]}$CLUSTER_DOMAIN
echo "sending the ozone tarball to the first node " $first_node
rsync -aP /Users/weichiu/sandbox/ozone/hadoop-ozone/dist/target/$OZONE_TARBALL systest@$first_node:/tmp/

for i in "${DN_HOSTNAME[@]}"; do
	hostname=$i$CLUSTER_DOMAIN
	if [ "$hostname" = "$first_node" ]; then
		continue
	fi
	echo "tell the first node to rsync the tarball with " $hostname
	ssh systest@$first_node "rsync -aP -e 'ssh -o StrictHostKeyChecking=no' /tmp/$OZONE_TARBALL systest@$hostname:/tmp/" &
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done

for i in "${DN_HOSTNAME[@]}"; do
	hostname=$i$CLUSTER_DOMAIN
	echo "untar at host " $hostname
	ssh root@$hostname "cd /tmp && tar zxf /tmp/$OZONE_TARBALL" &
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done

for i in "${DN_HOSTNAME[@]}"; do
	hostname=$i$CLUSTER_DOMAIN
	echo "update ownership at host " $hostname
	ssh root@$hostname "chmod -R 777 /tmp/ozone-1.1.0-SNAPSHOT/" &
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done
