#!/bin/bash

source `dirname "$0"`/conf.sh
for i in ${ALL_NODES[@]}; do
	ssh $SSH_PASSWORDLESS_USER@${i}$CLUSTER_DOMAIN "sudo pkill -f freon" &
done
