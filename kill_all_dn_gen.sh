#!/bin/bash

source conf.sh
for i in ${DN_HOSTNAME[@]}; do
	ssh root@${i}$CLUSTER_DOMAIN "pkill -f freon" &
done
