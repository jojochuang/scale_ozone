#!/bin/bash

DATANODES=$(seq 71 86)
for i in ${DATANODES[@]}; do ssh root@10.12.1.${i} "rm -rf /data/*/hadoop-ozone/datanode/data/hdds/*"; done
