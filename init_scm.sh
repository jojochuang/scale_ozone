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
                <value>/var/lib/hadoop-ozone/fake_datanode/data</value>
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
export JAVA_HOME=/usr/java/jdk1.8.0_232-cloudera/
#./ozone scm --init
cat /var/lib/hadoop-ozone/fake_scm/data/scm/current/VERSION

#./ozone scm
