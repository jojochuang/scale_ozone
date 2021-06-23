#!/bin/bash

# shared variables 
CLUSTER_DOMAIN=".weichiu-scale.root.hwx.site"
# host name of SCM. Supports one SCM
SCM_HOST="weichiu-scale-2"
# OM host names. Can have more than 1 OM
OM_HOSTS=(weichiu-scale-1 weichiu-scale-2 weichiu-scale-3)

# the set of master nodes
MASTERS=(weichiu-scale-1 weichiu-scale-2 weichiu-scale-3)
# the set of DataNode
DN_HOSTNAME=(weichiu-scale-1 weichiu-scale-2 weichiu-scale-3)

ALL_NODES=("${MASTERS[@]}" "${DN_HOSTNAME[@]}")
DN_TOTAL=${#DN_HOSTNAME[@]}

SSH_PASSWORDLESS_USER="systest"
SSH="ssh "
SCP="scp -o \"StrictHostKeyChecking=no\""

OZONE_TARBALL="ozone-1.2.0-SNAPSHOT.tar.gz"
OZONE_BINARY_ROOT="/tmp/ozone-1.2.0-SNAPSHOT"
SCALE_OZONE_SCRIPT_DIR="/tmp/scale_ozone"
export JAVA_HOME="/usr/java/jdk1.8.0_232-cloudera/"
# how many disks per DN
DISKS_TOTAL=1
# number of threads 
DATAGEN_THREADS=1
# number of data gen process on each DN
DATA_GEN_INSTANCE_PER_DN=1

#CLUSTER_ID=CID-37911495-e721-47f7-9d3b-5ebff2993e01
#SCM_ID=59a3fa4a-7c98-4029-9612-a711152509a1
#OM_ID=(1490c390-648a-434b-979f-0f93c6ec49dd e2c20c87-f748-4626-bec4-4d380f30c488 43d02b9c-3616-459e-9699-e96f4d9e5afd)

OM_DIR=/var/lib/hadoop-ozone/om
SCM_DIR=/var/lib/hadoop-ozone/scm
DN_DIR=/var/lib/hadoop-ozone/dn

# "ycloud", "phatcat" or "custom"
# if custom, go to init_dn.sh and update the $data_dirs variable
DN_DATA_DIR_TYPE="ycloud" 

# 10M keys, 100k blocks per chunk, each key 1024 bytes
# 10M keys, 1k blocks per chunk, each key 1024 bytes
# 1B keys, 100k blocks per chunk, each key 1024 bytes (10k containers)
CONTAINER_SIZE=$((5 * 1024 * 1024))
KEY_SIZE=$((100 * 1024))
TOTAL_CONTAINERS=$((100))
CONTAINER_OFFSET=$((1))
PRESERVE_EXISTING_DATA=false

# either true or false
DRY_RUN=false
