#!/bin/bash

source `dirname "$0"`/conf.sh
ulimit -n 1048576
ulimit -u 1048576


OM_INDEX=$1

# run as 'hdfs' user
# clean up O directory
if [ ! -d $OM_DIR ]; then
	mkdir $OM_DIR
fi

if [ "$PRESERVE_EXISTING_DATA" = true ]; then
	echo "preserve existing data"
else
	rm -rf $OM_DIR/ratis/*
	rm -rf $OM_DIR/data/db.checkpoints
	rm -rf $OM_DIR/data/om.db
	rm -rf $OM_DIR/data/omMetrics
fi
chmod 777 -R $OM_DIR
mkdir -p $OM_DIR/data/om/current

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
                <name>ozone.scm.datanode.id.dir</name>
                <value>/var/lib/hadoop-ozone/datanode</value>
        </property>
        <property>
                <name>ozone.metadata.dirs</name>
                <value>$DN_DIR/ozone-metadata</value>
        </property>
        <property>
                <name>ozone.scm.names</name>
                <value>$SCM_HOST$CLUSTER_DOMAIN</value>
        </property>
</configuration>

EOF

OM_UUID=${OM_ID[$OM_INDEX]}

#cat >  $OM_DIR/data/om/current/VERSION <<EOF
##Tue Sep 22 23:33:48 UTC 2020
#nodeType=OM
#scmUuid=$SCM_ID
#clusterID=$CLUSTER_ID
#cTime=1600817627795
#omUuid=$OM_UUID
#layoutVersion=0
#EOF

#cd $OZONE_BINARY_ROOT/bin
#./ozone om --init
#cat $OM_DIR/data/om/current/VERSION
#./ozone om

