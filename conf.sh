#!/bin/bash

# shared variables 
CLUSTER_DOMAIN=".weichiu.root.hwx.site"
# host name of SCM. Supports one SCM
SCM_HOST="weichiu-2"
# OM host names. Can have more than 1 OM
OM_HOSTS=(weichiu-1 weichiu-2 weichiu-3)

# the set of master nodes
MASTERS=(weichiu-1 weichiu-2 weichiu-3)
# the set of DataNode
DN_HOSTNAME=(weichiu-1 weichiu-2 weichiu-3)

ALL_NODES=("${MASTERS[@]}" "${DN_HOSTNAME[@]}")
DN_TOTAL=${#DN_HOSTNAME[@]}

SSH_PASSWORDLESS_USER="systest"
SSH="ssh "
SCP="scp -o \"StrictHostKeyChecking=no\""

OZONE_TARBALL="hadoop-ozone-1.0.0.7.1.6.0-297.tar.gz"
OZONE_BINARY_ROOT="/tmp/ozone-1.0.0.7.1.6.0-297"
SCALE_OZONE_SCRIPT_DIR="/tmp/scale_ozone"
export JAVA_HOME="/usr/java/jdk1.8.0_232-cloudera/"
# how many disks per DN
DISKS_TOTAL=1
# number of threads 
DATAGEN_THREADS=1
# number of data gen process on each DN
DATA_GEN_INSTANCE_PER_DN=1

CLUSTER_ID=CID-37911495-e721-47f7-9d3b-5ebff2993e01
SCM_ID=59a3fa4a-7c98-4029-9612-a711152509a1
OM_ID=(1490c390-648a-434b-979f-0f93c6ec49dd e2c20c87-f748-4626-bec4-4d380f30c488 43d02b9c-3616-459e-9699-e96f4d9e5afd)

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
TOTAL_CONTAINERS=$((1024))

# either true or false
DRY_RUN=false
