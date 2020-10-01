#!/bin/bash

source conf.sh
for i in ${ALL_NODES[@]}; do
	echo $i
	scp /tmp/hadoop-ozone-tools-1.1.0-SNAPSHOT.jar root@$i$CLUSTER_DOMAIN:$OZONE_BINARY_ROOT/share/ozone/lib/hadoop-ozone-tools-1.1.0-SNAPSHOT.jar
done

