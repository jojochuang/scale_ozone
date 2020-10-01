#!/bin/bash
for disk in /data/disk*; do
	rm -rf $disk/hadoop-ozone/datanode/data/hdds/* &
done

wait
