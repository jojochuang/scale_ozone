#!/bin/bash

# shared variables 
CLUSTER_DOMAIN=".ozone.cisco.local"
# host name of SCM. Supports one SCM
SCM_HOST="rhelnn02"$CLUSTER_DOMAIN
# OM host names. Can have more than 1 OM
OM_HOSTS=("rhelnn01"$CLUSTER_DOMAIN "rhelnn02"$CLUSTER_DOMAIN)

# the set of master nodes
MASTERS=(rhelnn01 rhelnn02 rhelnn03 rhelnn04)
# the set of DataNode
DN_HOSTNAME=(rhel01 rhel02 rhel03 rhel04 rhel05 rhel06 rhel07 rhel08 rhel09 rhel10 rhel11 rhel12 rhel13 rhel14 rhel15)
# do not use  rhel16

ALL_NODES=("${MASTERS[@]}" "${DN_HOSTNAME[@]}")
DN_TOTAL=${#DN_HOSTNAME[@]}

OZONE_BINARY_ROOT="/tmp/ozone-1.1.0-SNAPSHOT"

CLUSTER_ID=CID-32cf6a03-d481-4ba9-9b40-ba5bb36b1dce
SCM_ID=6bce64a2-935c-4ff9-a7f2-05f4c73987e0
OM_ID=(c4af5c13-a967-4c83-8ae2-9e9e485085ac 470cc641-5ac9-479a-90b8-dbe3d8962eec)

# 10M keys, 100k blocks per chunk, each key 1024 bytes
# 10M keys, 1k blocks per chunk, each key 1024 bytes
# 1B keys, 100k blocks per chunk, each key 1024 bytes (10k containers)
TOTAL_KEYS=1000000
BLOCKS_PER_CONTAINER=1000
KEY_SIZE=$((1024 * 1))
REPLICATION_FACTOR=3

# either true or false
DRY_RUN=false
