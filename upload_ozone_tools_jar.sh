#!/bin/bash

for i in {1..3}; do
	scp /Users/weichiu/sandbox/ozone/hadoop-ozone/tools/target/hadoop-ozone-tools-1.1.0-SNAPSHOT.jar root@weichiu-${i}.weichiu.root.hwx.site:/tmp/ozone-1.1.0-SNAPSHOT/share/ozone/lib/hadoop-ozone-tools-1.1.0-SNAPSHOT.jar
done

