#!/bin/bash

source `dirname "$0"`/config.sh

cd tpcds-kit/tools
for size in "${DATASET_SIZE_GB[@]}"
do
	mkdir /tmp/impala_tpcds_query_${size}gb
	./dsqgen -DIRECTORY ../../impala-tpcds-kit/query-templates/ -INPUT ../../impala-tpcds-kit/query-templates/templates.lst -VERBOSE Y -QUALIFY Y -SCALE $size -DIALECT impala -OUTPUT_DIR /tmp/impala_tpcds_query_${size}gb
${size}done
