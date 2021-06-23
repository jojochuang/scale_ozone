#!/bin/bash

source `dirname "$0"`/conf.sh

dn_id="$1"

ulimit -n 1024000
ulimit -u 1048576

OZONE_FREON_OPTS_BASE="-Xmx81920M $OZONE_FREON_OPTS"

# run as 'hdfs' user
# clean up O directory
if [ ! -d $DN_DIR ]; then
	mkdir $DN_DIR
fi
if [ "$PRESERVE_EXISTING_DATA" = true ]; then
	echo "preserve existing data"
else
	echo "Removing existing data from datanode directory"
	rm -rf $DN_DIR/data
	#rm -rf $DN_DIR/ratis/data
	rm -rf /data/19/hadoop-ozone/datanode/ratis/data/*
fi

#dn_uuid=`head -n${dn_id} $SCALE_OZONE_SCRIPT_DIR/dn_uuid.txt |tail -n1`

#sed -i "s/  uuid:.*/  uuid: $dn_uuid/" /var/lib/hadoop-ozone/datanode/datanode.id

data_dirs=()

#if [ "$dn_id" -eq "15" ]; then
	# the 15th DN has only 45 mount points
#	DISKS_TOTAL=45
#fi

if [ "$DN_DATA_DIR_TYPE" = "ycloud" ]; then
	data_dirs+=("/hadoop-ozone/datanode/data")
elif [ "$DN_DATA_DIR_TYPE" = "phatcat" ]; then
	for datagen_id in $(seq 0 $(( $DATA_GEN_INSTANCE_PER_DN -1 )) ); do
		DISKS_PER_DATAGEN=$(( $DISKS_TOTAL / $DATA_GEN_INSTANCE_PER_DN ))
		paths=()
		for disk_id in $(seq $(( $DISKS_PER_DATAGEN * $datagen_id + 1 )) $(( $DISKS_PER_DATAGEN * ($datagen_id + 1)  ))); do
			paths+=("/data/${disk_id}/hadoop-ozone/datanode/data")
		done
		paths_string=$(IFS=, ; echo "${paths[*]}")
		
		data_dirs+=($paths_string)

		echo $paths_string
	done
elif [ "$DN_DATA_DIR_TYPE" = "custom" ]; then
	#echo "make sure you update $data_dirs based on the real cluster configuration"
	for datagen_id in $(seq 0 $(( $DATA_GEN_INSTANCE_PER_DN -1 )) ); do
		DISKS_PER_DATAGEN=$(( $DISKS_TOTAL / $DATA_GEN_INSTANCE_PER_DN ))
		paths=()
		for disk_id in $(seq $(( $DISKS_PER_DATAGEN * $datagen_id + 1 )) $(( $DISKS_PER_DATAGEN * ($datagen_id + 1)  ))); do
			if [[ $disk_id -ne 19 ]]; then
				paths+=("/data/${disk_id}/hadoop-ozone/datanode/data")
			fi
		done
		paths_string=$(IFS=, ; echo "${paths[*]}")
		
		data_dirs+=($paths_string)

		echo $paths_string
	done
else
	echo "Unknown DN_DATA_DIR_TYPE"
	return -1
fi

DN_DATAGEN_CONFIG_PATHS=()
for datagen in $(seq 1 $DATA_GEN_INSTANCE_PER_DN); do
	# FIXME: there is a non-zero chance of random number collision
	DN_DATAGEN_CONFIG_PATH=/tmp/dn_datagen_$RANDOM
	DN_DATAGEN_CONFIG_PATHS+=($DN_DATAGEN_CONFIG_PATH)
done

for datagen_id in $(seq 0 $(($DATA_GEN_INSTANCE_PER_DN-1)) ); do
	# add JMX connection to allow profiling
	PROFILER_PORT=$(( 1089 + $datagen_id))
	PROFILER="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=$PROFILER_PORT -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
	export OZONE_FREON_OPTS="$PROFILER $OZONE_FREON_OPTS_BASE"

	DN_DATAGEN_CONFIG_PATH=${DN_DATAGEN_CONFIG_PATHS[$datagen_id]}
	echo "Data Generator instance " $datagen " on DN " $dn_id
	echo "Creating config file in " $DN_DATAGEN_CONFIG_PATH
	cp -R $OZONE_BINARY_ROOT/etc/hadoop $DN_DATAGEN_CONFIG_PATH

	data_dir=${data_dirs[$datagen_id]}
	# reduce log noise
	cat >> $DN_DATAGEN_CONFIG_PATH/log4j.properties <<EOF
log4j.logger.org.apache.hadoop.ozone.container.common.interfaces.Container=WARN
EOF
	cat > $DN_DATAGEN_CONFIG_PATH/ozone-site.xml <<EOF

	<configuration>
		<property>
			<name>ozone.scm.db.dirs</name>
			<value>$DN_DIR/data</value>
		</property>
		<property>
			<name>ozone.om.db.dirs</name>
			<value>$OM_DIR/data</value>
		</property>
		<property>
			<name>ozone.scm.datanode.id.dir</name>
			<value>/var/lib/hadoop-ozone/datanode</value>
		</property>
		<property>
			<name>hdds.datanode.dir</name>
			<value>$data_dir</value>
		</property>
		<property>
			<name>ozone.metadata.dirs</name>
			<value>$DN_DIR/ozone-metadata</value>
		</property>
		<property>
			<name>ozone.scm.names</name>
			<value>$SCM_HOST$CLUSTER_DOMAIN</value>
		</property>
		<!-- evict containers from memory quickly -->
		<property>
			<name>ozone.container.cache.size</name>
			<value>100</value>
		</property>
		<!-- turn off disk checker -->
		<property>
			<name>dfs.datanode.disk.check.timeout</name>
			<value>7d</value>
		</property>
		<!-- don't run du -->
		<property>
			<name>hdds.datanode.du.refresh.period</name>
			<value>7d</value>
		</property>
		<property>
			<name>hdds.datanode.df.refresh.period</name>
			<value>7d</value>
		</property>
		<property>
			<name>hdds.datanode.du.factory.classname</name>
			<value>org.apache.hadoop.hdds.fs.DedicatedDiskSpaceUsageFactory</value>
		</property>
	</configuration>

EOF

	cd $OZONE_BINARY_ROOT/bin

        
	#TOTAL_CONTAINERS=$(( $TOTAL_KEYS / $BLOCKS_PER_CONTAINER ))
	container_id_increment=$(( $DN_TOTAL / 3 ))
	#CONTAINERS_PER_DN=$(( $TOTAL_CONTAINERS / $container_id_increment ))
	#container_id_offset=$(( $CONTAINERS_PER_DN * (($dn_id - 1) / 3) ))
	#container_id_offset=$(( (($dn_id - 1) / 3) ))

	#TOTAL_KEYS_FOR_THIS_DATAGEN_INSTANCE=$(( $TOTAL_KEYS / $DATA_GEN_INSTANCE_PER_DN ))
	TOTAL_CONTAINERS_FOR_THIS_DATAGEN_INSTANCE=$((  TOTAL_CONTAINERS / $DN_TOTAL * 3 ))
	#key_id_offset=$(( $TOTAL_KEYS_FOR_THIS_DATAGEN_INSTANCE * $datagen_id ))

	echo "TOTAL_CONTAINERS=$TOTAL_CONTAINERS"
	echo "KEY_SIZE=$KEY_SIZE"
	echo "DN_TOTAL=$DN_TOTAL"
	echo "dn_id=$dn_id"
	echo "TOTAL_CONTAINERS_FOR_THIS_DATAGEN_INSTANCE=$TOTAL_CONTAINERS_FOR_THIS_DATAGEN_INSTANCE"
	#echo "CONTAINERS_PER_DN=$CONTAINERS_PER_DN"
	#echo "container_id_offset=$container_id_offset"
	#echo "container_id_increment=$container_id_increment"
	#echo "key_id_offset=$key_id_offset"

	echo "Running Freon to generate data chunks and db"

	if [ "$DRY_RUN" = true ]; then
		cat <<EOF
 ./ozone --config $DN_DATAGEN_CONFIG_PATH freon cgdn \
			--user hdfs \
	                --size $CONTAINER_SIZE \
			--key-size $KEY_SIZE \
			-t $DATAGEN_THREADS \
			-n $TOTAL_CONTAINERS_FOR_THIS_DATAGEN_INSTANCE \
                        --datanodes $DN_TOTAL \
                        --index $dn_id \
                        --from $CONTAINER_OFFSET \
                        --zero
EOF
	else
		./ozone --config $DN_DATAGEN_CONFIG_PATH freon cgdn \
			--user hdfs \
	                --size $CONTAINER_SIZE \
			--key-size $KEY_SIZE \
			-t $DATAGEN_THREADS \
			-n $TOTAL_CONTAINERS_FOR_THIS_DATAGEN_INSTANCE \
                        --datanodes $DN_TOTAL \
                        --index $dn_id \
                        --from $CONTAINER_OFFSET \
                        --zero \
                        2>&1 | tee $DN_DATAGEN_CONFIG_PATH/init_dn.log &
			#--datanode-id $dn_uuid \
			#--cluster-id $CLUSTER_ID \
			#--scm-id $SCM_ID \
			#--block-per-container $BLOCKS_PER_CONTAINER \
			#--write-dn \
			#--om-key-batch-size 10000 \
			#--repl $REPLICATION_FACTOR \
			#--container-id-offset $container_id_offset \
			#--container-id-increment $container_id_increment \
			#--key-id-offset $key_id_offset \
	fi

done

for job in `jobs -p`
do
	echo "Waiting for completion of data generator " $job
	wait $job
done
