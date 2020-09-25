#!/bin/bash

for i in {1..3}; do
	scp init_dn.sh root@weichiu-${i}.weichiu.root.hwx.site:/tmp/
	scp dn_uuid.txt root@weichiu-${i}.weichiu.root.hwx.site:/tmp/
	ssh root@weichiu-${i}.weichiu.root.hwx.site sudo -u hdfs bash /tmp/init_dn.sh ${i}
done
