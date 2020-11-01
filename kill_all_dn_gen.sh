#!/bin/bash

source `dirname "$0"`/conf.sh
for i in ${ALL_NODES[@]}; do
	ssh root@${i}$CLUSTER_DOMAIN "pkill -f freon" &
done
