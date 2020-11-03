#!/bin/bash

source `dirname "$0"`/conf.sh
ulimit -n 1048576
ulimit -u 1048576


OM_INDEX=$1

# run as 'hdfs' user
# clean up O directory
if [ ! -d "/var/lib/hadoop-ozone/fake_om" ]; then
	mkdir /var/lib/hadoop-ozone/fake_om
fi
rm -rf /var/lib/hadoop-ozone/om/ratis/*
rm -rf /var/lib/hadoop-ozone/fake_om/data
chmod 777 -R /var/lib/hadoop-ozone/fake_om
mkdir -p /var/lib/hadoop-ozone/fake_om/data/om/current

cat > $OZONE_BINARY_ROOT/etc/hadoop/ozone-site.xml <<EOF

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
                <name>ozone.metadata.dirs</name>
                <value>/var/lib/hadoop-ozone/fake_datanode/ozone-metadata</value>
        </property>
        <property>
                <name>ozone.scm.names</name>
                <value>$SCM_HOST$CLUSTER_DOMAIN</value>
        </property>
</configuration>

EOF

OM_UUID=${OM_ID[$OM_INDEX]}

cat >  /var/lib/hadoop-ozone/fake_om/data/om/current/VERSION <<EOF
#Tue Sep 22 23:33:48 UTC 2020
nodeType=OM
scmUuid=$SCM_ID
clusterID=$CLUSTER_ID
cTime=1600817627795
omUuid=$OM_UUID
layoutVersion=0
EOF

cd $OZONE_BINARY_ROOT/bin
./ozone om --init
cat /var/lib/hadoop-ozone/fake_om/data/om/current/VERSION
#./ozone om

