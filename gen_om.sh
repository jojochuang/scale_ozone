#!/bin/bash

source /tmp/conf.sh
ulimit -n 1048576
ulimit -u 1048576


dn_total="$1"
dn_uuid=`head -n${dn_total} /tmp/dn_uuid.txt | paste -sd "," -`

echo "Generating OM for " $dn_total " DataNodes."

cd $OZONE_BINARY_ROOT/bin
export JAVA_HOME=/usr/java/jdk1.8.0_261-amd64

if [ "$DRY_RUN" = false ]; then
	PROFILER_PORT="1089"
	PROFILER="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=$PROFILER_PORT -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
	export OZONE_FREON_OPTS="$PROFILER $OZONE_FREON_OPTS_BASE"

	TOTAL_CONTAINERS=$(( $TOTAL_KEYS / $BLOCKS_PER_CONTAINER ))
	#export HADOOP_ROOT_LOGGER="debug,console"
	#export HADOOP_LOGLEVEL="debug"
	./ozone freon cg --user-id hdfs --cluster-id $CLUSTER_ID \
		--datanode-id $dn_uuid \
		--scm-id $SCM_ID \
		--block-per-container $BLOCKS_PER_CONTAINER \
		--size $KEY_SIZE \
		--om-key-batch-size 10000 \
		--write-om \
		--repl $REPLICATION_FACTOR \
		-t 64 \
		-n $TOTAL_CONTAINERS
fi
