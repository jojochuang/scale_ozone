#!/bin/bash

source /tmp/conf.sh

SCM_HOST=$1

# run as 'hdfs' user
# clean up O directory
if [ ! -d "/var/lib/hadoop-ozone/fake_om" ]; then
	mkdir /var/lib/hadoop-ozone/fake_om
fi
rm -rf /var/lib/hadoop-ozone/fake_om/data
chmod 777 -R /var/lib/hadoop-ozone/fake_om
mkdir -p /var/lib/hadoop-ozone/fake_om/data/om/current

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
                <value>/var/lib/hadoop-ozone/fake_datanode/data</value>
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

cat >  /var/lib/hadoop-ozone/fake_om/data/om/current/VERSION <<EOF
#Tue Sep 22 23:33:48 UTC 2020
nodeType=OM
scmUuid=$SCM_ID
clusterID=$CLUSTER_ID
cTime=1600817627795
omUuid=$OM_UUID
layoutVersion=0
EOF

cd /tmp/ozone-1.1.0-SNAPSHOT/bin
export JAVA_HOME=/usr/java/jdk1.8.0_232-cloudera/
./ozone om --init
cat /var/lib/hadoop-ozone/fake_om/data/om/current/VERSION
#./ozone om

