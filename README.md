# scale_ozone
This is the set of scripts that drives the Ozone data generation tool HDDS-4395 (Ozone Data Generator for Fast Scale Test).

# Usage
Clone this repo locally at your cluster. 

The scripts make the following assumption: 
* all hosts are within the same domain
* there is a user that can ssh without password, and this user can sudo.
* one block per per
* All keys are in volume vol1, bucket bucket1, Key name in format /L1-x/L2-y/L3-z/key1234

1. Edit conf.sh. Change these variables: 

| Variable              | Description                          | Example                            |
|-----------------------|--------------------------------------|------------------------------------|
| CLUSTER_DOMAIN        | cluster domain                       | .halxg.cloudera.com                |
| SCM_HOST              | SCM host name                        | vc1504                             |
| OM_HOSTS              | OM host names                        | (vc1502  vc1503 vc1506)            |
| DN_HOSTNAME           | DN host names                        | (vb0213 vb0214 vb0215)             |
| SSH_PASSWORDLESS_USER | Linux user name                      | systest                            |
| OZONE_TARBALL         | Ozone tar ball file name             | hadoop-ozone-1.1.0-SNAPSHOT.tar.gz |
| JAVA_HOME             | path to Java                         | /usr/java/jdk1.8.0_232-cloudera/   |
| DISKS_TOTAL           | number of disks per DN               | 3                                  |
| DATAGEN_THREADS       | number of threads in the DN data gen | 6                                  |
| TOTAL_KEYS            | number of keys. e.g. 100 million     | 100000000                          |
| BLOCKS_PER_CONTAINER  | number of blocks per container       | 100                                |
| KEY_SIZE              | Key file length. e.g. 300KB          | 307200                             |

The tool assumes the DN volumes are mounted at directory /data/1, /data/2, /data3. If the DNs mount volumes at different path, update init_dn.sh.

        for disk_id in $(seq $(( $DISKS_PER_DATAGEN * $datagen_id + 1 )) $(( $DISKS_PER_DATAGEN * ($datagen_id + 1)  ))); do
                paths+=("/data/${disk_id}/hadoop-ozone/datanode/data")
        done
        
2. Run ./remote_sys_init.sh to update ulimits on all nodes.
3. Run ./copy_scripts.sh to copy the scripts to all nodes.
4. Run ./remote_init.sh to generate OM, SCM and DN data.
5. The OM db is generated under /var/lib/hadoop-ozone/fake_om; The SCM db under /var/lib/hadoop-ozone/fake_scm. Make sure to update cluster configuration before start.

That's it!
