#!/bin/bash

# shared variables 
CLUSTER_DOMAIN=".weichiu.root.hwx.site"
SCM_HOST="weichiu-2.weichiu.root.hwx.site"
OM_HOST="weichiu-1.weichiu.root.hwx.site"
DN_HOSTNAME=(weichiu-1 weichiu-2 weichiu-3)

DN_TOTAL=3

CLUSTER_ID=CID-020e0a3f-13e2-4f36-89b2-065b6667b78e
SCM_ID=2245531e-8737-4d7b-879d-7e8af82ccf56
OM_ID=216f270f-aa3a-4a7b-bc81-27baa5cdd108

# 10M keys, 100k blocks per chunk, each key 1024 bytes
# 10M keys, 1k blocks per chunk, each key 1024 bytes
# 1B keys, 100k blocks per chunk, each key 1024 bytes (10k containers)
TOTAL_KEYS=1000000000
BLOCKS_PER_CONTAINER=100000
KEY_SIZE=1024
REPLICATION_FACTOR=3
