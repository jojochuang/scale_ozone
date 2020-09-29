#!/bin/bash

source /tmp/conf.sh

dn_id="$1"

# run as 'hdfs' user
# clean up O directory
if [ ! -d "/var/lib/hadoop-ozone/fake_datanode" ]; then
	mkdir /var/lib/hadoop-ozone/fake_datanode
fi
rm -rf /var/lib/hadoop-ozone/fake_datanode/data

cat > /tmp/ozone-1.1.0-SNAPSHOT/etc/hadoop/ozone-site.xml <<EOF

<configuration>
        <property>
                <name>ozone.scm.db.dirs</name>
                <value>/var/lib/hadoop-ozone/fake_scm/data</value>
        </property>
        <property>
                <name>ozone.om.db.dirs</name>
                <value>/var/lib/hadoop-ozone/fake_om/data</value>
        </property>
        <property>
                <name>ozone.scm.datanode.id.dir</name>
                <value>/var/lib/hadoop-ozone/datanode</value>
        </property>
        <property>
                <name>hdds.datanode.dir</name>
                <value>/data/disk1/hadoop-ozone/datanode/data,/data/disk10/hadoop-ozone/datanode/data,/data/disk11/hadoop-ozone/datanode/data,/data/disk12/hadoop-ozone/datanode/data,/data/disk13/hadoop-ozone/datanode/data,/data/disk14/hadoop-ozone/datanode/data,/data/disk15/hadoop-ozone/datanode/data,/data/disk16/hadoop-ozone/datanode/data,/data/disk17/hadoop-ozone/datanode/data,/data/disk18/hadoop-ozone/datanode/data,/data/disk19/hadoop-ozone/datanode/data,/data/disk2/hadoop-ozone/datanode/data,/data/disk20/hadoop-ozone/datanode/data,/data/disk21/hadoop-ozone/datanode/data,/data/disk22/hadoop-ozone/datanode/data,/data/disk23/hadoop-ozone/datanode/data,/data/disk24/hadoop-ozone/datanode/data,/data/disk25/hadoop-ozone/datanode/data,/data/disk26/hadoop-ozone/datanode/data,/data/disk27/hadoop-ozone/datanode/data,/data/disk28/hadoop-ozone/datanode/data,/data/disk29/hadoop-ozone/datanode/data,/data/disk3/hadoop-ozone/datanode/data,/data/disk30/hadoop-ozone/datanode/data,/data/disk31/hadoop-ozone/datanode/data,/data/disk32/hadoop-ozone/datanode/data,/data/disk33/hadoop-ozone/datanode/data,/data/disk34/hadoop-ozone/datanode/data,/data/disk35/hadoop-ozone/datanode/data,/data/disk36/hadoop-ozone/datanode/data,/data/disk37/hadoop-ozone/datanode/data,/data/disk38/hadoop-ozone/datanode/data,/data/disk39/hadoop-ozone/datanode/data,/data/disk4/hadoop-ozone/datanode/data,/data/disk40/hadoop-ozone/datanode/data,/data/disk41/hadoop-ozone/datanode/data,/data/disk42/hadoop-ozone/datanode/data,/data/disk43/hadoop-ozone/datanode/data,/data/disk44/hadoop-ozone/datanode/data,/data/disk45/hadoop-ozone/datanode/data,/data/disk46/hadoop-ozone/datanode/data,/data/disk47/hadoop-ozone/datanode/data,/data/disk48/hadoop-ozone/datanode/data,/data/disk5/hadoop-ozone/datanode/data,/data/disk6/hadoop-ozone/datanode/data,/data/disk7/hadoop-ozone/datanode/data,/data/disk8/hadoop-ozone/datanode/data,/data/disk9/hadoop-ozone/datanode/data</value>
        </property>
        <property>
                <name>ozone.metadata.dirs</name>
                <value>/var/lib/hadoop-ozone/fake_datanode/ozone-metadata</value>
        </property>
        <property>
                <name>ozone.scm.names</name>
                <value>$SCM_HOST</value>
        </property>
</configuration>

EOF


dn_uuid=`head -n${dn_id} /tmp/dn_uuid.txt |tail -n1`

sed -i "s/  uuid:.*/  uuid: $dn_uuid/" /var/lib/hadoop-ozone/datanode/datanode.id


cd /tmp/ozone-1.1.0-SNAPSHOT/bin
export JAVA_HOME=/usr/java/jdk1.8.0_261-amd64

CONTAINERS=$(( $TOTAL_KEYS / $BLOCKS_PER_CONTAINER ))
CONTAINERS_PER_DN=$(( $CONTAINERS / ($DN_TOTAL / 3) ))
#container_id_offset=$(( $CONTAINERS_PER_DN * (($dn_id - 1) / 3) ))
container_id_offset=$(( (($dn_id - 1) / 3) ))
container_id_increment=$(( $DN_TOTAL / 3 ))

echo "CONTAINERS=$CONTAINERS"
echo "CONTAINERS_PER_DN=$CONTAINERS_PER_DN"
echo "container_id_offset=$container_id_offset"
echo "container_id_increment=$container_id_increment"

echo "Running Freon to generate data chunks and db"
./ozone freon cg --user-id hdfs --cluster-id $CLUSTER_ID \
	--datanode-id $dn_uuid \
	--scm-id $SCM_ID \
	--block-per-container $BLOCKS_PER_CONTAINER \
	--size $KEY_SIZE \
	--om-key-batch-size 10000 \
	--write-dn \
	--repl $REPLICATION_FACTOR \
	-t 8 \
	-n $TOTAL_KEYS \
	--container-id-offset $container_id_offset \
	--container-id-increment $container_id_increment

#--write-scm \
#--write-om \
