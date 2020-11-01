#!/bin/bash

# shared variables 
CLUSTER_DOMAIN=".halxg.cloudera.com"
# host name of SCM. Supports one SCM
SCM_HOST="vc1504"$CLUSTER_DOMAIN
# OM host names. Can have more than 1 OM
OM_HOSTS=("vc1501"$CLUSTER_DOMAIN "vc1502"$CLUSTER_DOMAIN  "vc1503"$CLUSTER_DOMAIN)

# the set of master nodes
MASTERS=(vc1501 vc1502 vc1503 vc1504)
# the set of DataNode
DN_HOSTNAME=()
for hostn in $(seq 217 242); do
  DN_HOSTNAME=(${DN_HOSTNAME[@]} "vb0$hostn" )
done
for hostn in $(seq 1 9); do
  DN_HOSTNAME=(${DN_HOSTNAME[@]} "vc150$hostn" )
done
DN_HOSTNAME=(${DN_HOSTNAME[@]} "vc1510" )
#printf '<%s>\n' $DN_HOSTNAME
#for i in ${DN_HOSTNAME[@]}; do
#	echo $i
#done
#DN_HOSTNAME=(vb0217 vb0218 vb0219 vb0220 vb0221 vb0222 vb0223 vb0224 )
# do not use  rhel16

ALL_NODES=("${MASTERS[@]}" "${DN_HOSTNAME[@]}")
DN_TOTAL=${#DN_HOSTNAME[@]}

SSH_PASSWORDLESS_USER="systest"
SSH="ssh "
SCP="scp -o \"StrictHostKeyChecking=no\""

OZONE_TARBALL="hadoop-ozone-1.1.0-SNAPSHOT.tar.gz"
OZONE_BINARY_ROOT="/tmp/ozone-1.1.0-SNAPSHOT"
SCALE_OZONE_SCRIPT_DIR="/tmp/scale_ozone"
export JAVA_HOME="/usr/java/jdk1.8.0_232-cloudera/"

CLUSTER_ID=CID-8599c3c8-b959-49fa-afd9-1b172d1c7f8e
SCM_ID=89d97b84-7f6f-4bd6-950e-f091ee3b98d7
OM_ID=(60ed85c6-5279-40db-a9eb-8f6718a21ae3 60ed85c6-5279-40db-a9eb-8f6718a21ae3 60ed85c6-5279-40db-a9eb-8f6718a21ae3)

# 10M keys, 100k blocks per chunk, each key 1024 bytes
# 10M keys, 1k blocks per chunk, each key 1024 bytes
# 1B keys, 100k blocks per chunk, each key 1024 bytes (10k containers)
TOTAL_KEYS=100000
BLOCKS_PER_CONTAINER=1024
KEY_SIZE=$((1048576 / 1))
REPLICATION_FACTOR=3

# either true or false
DRY_RUN=false
