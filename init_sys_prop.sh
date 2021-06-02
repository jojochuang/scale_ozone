#!/bin/bash

# set OS properties

# Linux THP

# ulimit max user process

# Due to a bug in CentOS7, can't set nofile to 1048576
# https://unix.stackexchange.com/questions/432057/pam-limits-so-making-problems-for-sudo
cp /etc/security/limits.conf /etc/security/limits.conf.old
cat >> /etc/security/limits.conf <<EOF
*               hard    memlock         unlimited
*               hard    nofile          1024000
EOF


cp /etc/security/limits.d/20-nproc.conf /etc/security/limits.d/20-nproc.conf.old
cat >> /etc/security/limits.d/20-nproc.conf <<EOF
*               hard    nproc           1048576
EOF

