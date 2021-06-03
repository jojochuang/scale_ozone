#!/bin/bash
./copy_scripts.sh 
./remote_init_scm.sh &
./remote_init_om.sh &
./remote_init_dn.sh &

for job in `jobs -p`
do
	echo "Waiting for completion of job " $job
	wait $job
done
