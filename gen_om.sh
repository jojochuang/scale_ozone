#!/bin/bash

source `dirname "$0"`/conf.sh
ulimit -n 1024000
ulimit -u 1048576


dn_total="$1"
dn_uuid=`head -n${dn_total} $SCALE_OZONE_SCRIPT_DIR/dn_uuid.txt | paste -sd "," -`
OZONE_FREON_OPTS_BASE="-Xmx8192M $OZONE_FREON_OPTS"

echo "Generating OM for " $dn_total " DataNodes."

cd $OZONE_BINARY_ROOT/bin

PROFILER_PORT="1089"
PROFILER="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=$PROFILER_PORT -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
export OZONE_FREON_OPTS="$PROFILER $OZONE_FREON_OPTS_BASE"

#TOTAL_CONTAINERS=$(( $TOTAL_KEYS / $BLOCKS_PER_CONTAINER ))
#export HADOOP_ROOT_LOGGER="debug,console"
#export HADOOP_LOGLEVEL="debug"
command="./ozone freon cgom --user hdfs \
	--size $CONTAINER_SIZE \
        --key-size $KEY_SIZE \
	-t 64 \
	--from $CONTAINER_OFFSET \
	-n $TOTAL_CONTAINERS"
	#--om-key-batch-size 10000 \
	#--repl $REPLICATION_FACTOR \
        #--cluster-id $CLUSTER_ID \
	#--datanode-id $dn_uuid \
	#--scm-id $SCM_ID \
	#--block-per-container $BLOCKS_PER_CONTAINER \
if [ "$DRY_RUN" = true ]; then
	echo $command
else
	`$command`
fi
