#!/bin/bash

dn_total="$1"
dn_uuid=`head -n${dn_total} /tmp/dn_uuid.txt | paste -sd "," -`

echo "Generating SCM for " $dn_total " DataNodes."

cd /tmp/ozone-1.1.0-SNAPSHOT/bin
export JAVA_HOME=/usr/java/jdk1.8.0_232-cloudera/
./ozone freon cg --user-id hdfs --cluster-id CID-020e0a3f-13e2-4f36-89b2-065b6667b78e \
	--datanode-id $dn_uuid \
	--scm-id 2245531e-8737-4d7b-879d-7e8af82ccf56 \
	--block-per-container 10 \
	--size 1024 \
	--om-key-batch-size 10 \
	--write-scm \
	--repl 3 \
	-t 2 \
	-n 10

