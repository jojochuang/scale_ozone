#!/bin/bash

sudo yum install gcc make flex bison byacc git
git clone https://github.com/gregrahn/tpcds-kit.git
cd tpcds-kit/tools
make OS=LINUX

cd ../..
git clone https://github.com/cloudera/impala-tpcds-kit.git

