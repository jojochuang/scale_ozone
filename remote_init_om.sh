#!/bin/bash

source `dirname "$0"`/conf.sh

for OM_HOST in "${OM_HOSTS[@]}"; do
	hostname=$OM_HOST$CLUSTER_DOMAIN
	echo "setting up OM metadata directory for " $hostname
	ssh $SSH_PASSWORDLESS_USER@$hostname sudo mkdir $OM_DIR
	ssh $SSH_PASSWORDLESS_USER@$hostname sudo chmod 755 $OM_DIR
	ssh $SSH_PASSWORDLESS_USER@$hostname sudo chown -R hdfs:hdfs $OM_DIR
done

om_index=0

for OM_HOST in "${OM_HOSTS[@]}"; do
	hostname=$OM_HOST$CLUSTER_DOMAIN
	echo "Run init_om.sh " $hostname
	ssh $SSH_PASSWORDLESS_USER@$hostname sudo -u hdfs bash $SCALE_OZONE_SCRIPT_DIR/init_om.sh ${om_index} &
	om_index=$(($om_index + 1))
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done

for OM_HOST in "${OM_HOSTS[@]}"; do
	hostname=$OM_HOST$CLUSTER_DOMAIN
	echo "Run gen_om.sh " $hostname
	ssh $SSH_PASSWORDLESS_USER@$hostname sudo -u hdfs bash  $SCALE_OZONE_SCRIPT_DIR/gen_om.sh $DN_TOTAL &
done

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done
