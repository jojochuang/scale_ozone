#!/bin/bash

source `dirname "$0"`/conf.sh

dn_total="$1"
dn_uuid=`head -n${dn_total} $SCALE_OZONE_SCRIPT_DIR/dn_uuid.txt | paste -sd "," -`

echo "Generating SCM for " $dn_total " DataNodes."

cd $OZONE_BINARY_ROOT/bin
TOTAL_CONTAINERS=$(( $TOTAL_KEYS / $BLOCKS_PER_CONTAINER ))
command="./ozone freon cg --user-id=hdfs --cluster-id=$CLUSTER_ID \
	--datanode-id=$dn_uuid \
	--scm-id $SCM_ID \
	--block-per-container $BLOCKS_PER_CONTAINER \
	--size $KEY_SIZE \
	--om-key-batch-size=10000 \
	--write-scm \
	--repl $REPLICATION_FACTOR \
	-t 8 \
	-n $TOTAL_CONTAINERS"
if [ "$DRY_RUN" = true ]; then
	echo $command
else
	`$command`
fi
