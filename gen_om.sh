#!/bin/bash

source /tmp/conf.sh

dn_total="$1"
dn_uuid=`head -n${dn_total} /tmp/dn_uuid.txt | paste -sd "," -`

echo "Generating OM for " $dn_total " DataNodes."

cd /tmp/ozone-1.1.0-SNAPSHOT/bin
export JAVA_HOME=/usr/java/jdk1.8.0_232-cloudera/
./ozone freon cg --user-id hdfs --cluster-id $CLUSTER_ID \
	--datanode-id $dn_uuid \
	--scm-id $SCM_ID \
	--block-per-container $BLOCKS_PER_CONTAINER \
	--size $KEY_SIZE \
	--om-key-batch-size 10000 \
	--write-om \
	--repl $REPLICATION_FACTOR \
	-t 8 \
	-n $TOTAL_KEYS

#--write-dn \
#--write-scm \
