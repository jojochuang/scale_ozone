#!/bin/bash

source /tmp/conf.sh

SCM_HOST=$1

# this script runs on the SCM host
# run as 'hdfs' user

# clean up SCM directory
if [ ! -d "/var/lib/hadoop-ozone/fake_scm" ]; then
	mkdir /var/lib/hadoop-ozone/fake_scm
fi
rm -rf /var/lib/hadoop-ozone/fake_scm/data


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
                <name>ozone.scm.names</name>
                <value>$SCM_HOST</value>
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
</configuration>

EOF

mkdir -p /var/lib/hadoop-ozone/fake_scm/data/scm/current
cat >  /var/lib/hadoop-ozone/fake_scm/data/scm/current/VERSION <<EOF
#Thu Sep 24 08:50:03 UTC 2020
nodeType=SCM
scmUuid=$SCM_ID
clusterID=$CLUSTER_ID
cTime=1600937403500
layoutVersion=0
EOF

cd /tmp/ozone-1.1.0-SNAPSHOT/bin
export JAVA_HOME=/usr/java/jdk1.8.0_261-amd64
#./ozone scm --init
cat /var/lib/hadoop-ozone/fake_scm/data/scm/current/VERSION

#./ozone scm
