#!/bin/bash

dn_id="$1"
SCM_HOST=$2

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


dn_uuid=`head -n${dn_id} /tmp/dn_uuid.txt |tail -n1`

sed -i "s/  uuid:.*/  uuid: $dn_uuid/" /var/lib/hadoop-ozone/datanode/datanode.id


cd /tmp/ozone-1.1.0-SNAPSHOT/bin
export JAVA_HOME=/usr/java/jdk1.8.0_232-cloudera/
./ozone freon cg --user-id hdfs --cluster-id CID-020e0a3f-13e2-4f36-89b2-065b6667b78e \
	--datanode-id $dn_uuid \
	--scm-id 2245531e-8737-4d7b-879d-7e8af82ccf56 \
	--block-per-container 10 \
	--size 1024 \
	--om-key-batch-size 10 \
	--write-dn \
	--repl 3 \
	-t 2 \
	-n 10

#--write-scm \
#--write-om \
