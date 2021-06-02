#!/bin/bash

source `dirname "$0"`/conf.sh

# this script runs on the SCM host
# run as 'hdfs' user

# clean up SCM directory
if [ ! -d $SCM_DIR ]; then
	mkdir $SCM_DIR
fi
rm -rf $SCM_DIR/data


cat > $OZONE_BINARY_ROOT/etc/hadoop/ozone-site.xml <<EOF

<configuration>
        <property>
                <name>ozone.scm.db.dirs</name>
                <value>$SCM_DIR/data</value>
        </property>
        <property>
                <name>ozone.om.db.dirs</name>
                <value>$OM_DIR/data</value>
        </property>
        <property>
                <name>ozone.scm.names</name>
                <value>$SCM_HOST$CLUSTER_DOMAIN</value>
        </property>
        <property>
                <name>ozone.scm.datanode.id.dir</name>
                <value>/var/lib/hadoop-ozone/datanode</value>
        </property>
        <property>
                <name>ozone.metadata.dirs</name>
                <value>$DN_DIR/ozone-metadata</value>
        </property>
</configuration>

EOF

mkdir -p $SCM_DIR/data/scm/current
cat >  $SCM_DIR/data/scm/current/VERSION <<EOF
#Thu Sep 24 08:50:03 UTC 2020
nodeType=SCM
scmUuid=$SCM_ID
clusterID=$CLUSTER_ID
cTime=1600937403500
layoutVersion=0
EOF

cd $OZONE_BINARY_ROOT/bin
#./ozone scm --init
cat $SCM_DIR/data/scm/current/VERSION

#./ozone scm
