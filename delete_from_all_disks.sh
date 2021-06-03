#!/bin/bash
source `dirname "$0"`/conf.sh
if [ "$DN_DATA_DIR_TYPE" = "ycloud" ]; then
	echo "delete from /hadoop-ozone/datanode/data/"
	for scmid in /hadoop-ozone/datanode/data/hdds/*; do
		echo $scmid
		if [[ "$scmid" =~ "VERSION" ]]; then
			echo "skip VERSION fie"
		else
			rm -rf $scmid/* &
		fi
	done
elif [ "$DN_DATA_DIR_TYPE" = "phatcat" ]; then
	for disk in /data/*; do
		if [[ "$scmid" =~ "VERSION" ]]; then
			echo "skip VERSION fie"
		else
			rm -rf $disk/hadoop-ozone/datanode/data/hdds/* &
		fi
	done
elif [ "$DN_DATA_DIR_TYPE" = "custom" ]; then
	#echo "don't know what to do with data dir type " $DN_DATA_DIR_TYPE
	for disk in /data/*; do
		for scmid in $disk/hadoop-ozone/datanode/data/hdds/*; do
			echo $scmid
			if [[ "$scmid" =~ "VERSION" ]]; then
				echo "skip VERSION fie"
			else
				rm -rf $scmid/* &
			fi
		done
	done
else
	echo "don't know what to do with data dir type " $DN_DATA_DIR_TYPE
fi

wait
