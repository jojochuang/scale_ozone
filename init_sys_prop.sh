#!/bin/bash

# set OS properties

# Linux THP

# ulimit max user process
cp /etc/security/limits.conf /etc/security/limits.conf.old
cat >> /etc/security/limits.conf <<EOF
*               hard    memlock         unlimited
*               hard    nofile          1048576
EOF


cp /etc/security/limits.d/20-nproc.conf /etc/security/limits.d/20-nproc.conf.old
cat >> /etc/security/limits.d/20-nproc.conf <<EOF
*               hard    nproc           1048576
EOF

