#!/bin/bash

source conf.sh
for i in ${ALL_NODES[@]}; do
	ssh root@${i}$CLUSTER_DOMAIN "pkill -f freon" &
done
