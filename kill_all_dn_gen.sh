#!/bin/bash
for i in ${DATANODES[@]}; do ssh root@10.12.1.${i} "pkill -f freon"; done
