#!/bin/bash
for disk in /data/*; do
	rm -rf $disk/hadoop-ozone/datanode/data/hdds/* &
done

wait
