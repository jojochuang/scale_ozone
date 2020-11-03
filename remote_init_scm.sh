#!/bin/bash

source `dirname "$0"`/conf.sh
echo "Create SCM data on " $SCM_HOST$CLUSTER_DOMAIN

ssh $SSH_PASSWORDLESS_USER@$SCM_HOST$CLUSTER_DOMAIN sudo mkdir /var/lib/hadoop-ozone/fake_scm
ssh $SSH_PASSWORDLESS_USER@$SCM_HOST$CLUSTER_DOMAIN sudo chmod 755 /var/lib/hadoop-ozone/fake_scm
ssh $SSH_PASSWORDLESS_USER@$SCM_HOST$CLUSTER_DOMAIN sudo chown -R hdfs:hdfs /var/lib/hadoop-ozone/fake_scm
ssh $SSH_PASSWORDLESS_USER@$SCM_HOST$CLUSTER_DOMAIN sudo -u hdfs bash $SCALE_OZONE_SCRIPT_DIR/init_scm.sh
ssh $SSH_PASSWORDLESS_USER@$SCM_HOST$CLUSTER_DOMAIN sudo -u hdfs bash $SCALE_OZONE_SCRIPT_DIR/gen_scm.sh $DN_TOTAL
