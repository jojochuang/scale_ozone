#!/bin/bash

source `dirname "$0"`/conf.sh
for i in ${ALL_NODES[@]}; do
	echo $i
	scp /tmp/hadoop-ozone-tools-1.1.0-SNAPSHOT.jar $SSH_PASSWORDLESS_USER@$i$CLUSTER_DOMAIN:$OZONE_BINARY_ROOT/share/ozone/lib/hadoop-ozone-tools-1.1.0-SNAPSHOT.jar
done

