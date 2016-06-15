#!/usr/bin/env bash

: ${SIS_QATSERVER_PORT:=8421}

source /etc/profile.d/rvm.sh
cd /test && bundle install --jobs $(nproc) --retry 3
PYTHONPATH=/qatserver \
  SIS_TEST_DIR=/test \
  SIS_LOGS_DIR=/logs \
  python3 -m qatserver ${SIS_QATSERVER_PORT} ${SIS_QATSERVER_EXTRA_ARGS}
