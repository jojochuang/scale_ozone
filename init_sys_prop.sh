#!/bin/bash

# set OS properties

# Linux THP

# ulimit max user process
cp /etc/security/limits.conf /etc/security/limits.conf.old
cat >> /etc/security/limits.conf <<EOF
*               hard    memlock         unlimited
*               hard    nproc           unlimited
EOF


