#!/bin/bash

source `dirname "$0"`/conf.sh
for i in ${ALL_NODES[@]}; do
	echo $i
	#for jar in /tmp/hadoop*.jar; do
		rsync /tmp/hadoop*.jar $SSH_PASSWORDLESS_USER@$i$CLUSTER_DOMAIN:$OZONE_BINARY_ROOT/share/ozone/lib/ 
		rsync /tmp/hadoop*.jar $SSH_PASSWORDLESS_USER@$i$CLUSTER_DOMAIN:/opt/cloudera/parcels/CDH/jars/ 
	#done
done

