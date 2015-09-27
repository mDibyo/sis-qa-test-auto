#!/usr/bin/env bash

PROJECT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
: ${CC_TEST_DIR:=${PROJECT_DIR}/test}

DOCKER_NAMESPACE=ucberkeley

docker run \
    --rm \
    --net=host \
    -t \
    -e DISPLAY=${DISPLAY} \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ${CC_TEST_DIR}:/test \
    ${DOCKER_NAMESPACE}/sis-qa-test-auto
