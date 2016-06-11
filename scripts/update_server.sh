#!/usr/bin/env bash

SIS_SERVER_ADDRESS=sis-testing.ist.1918.berkeley.edu
SIS_SERVER_PROJECT_DIR=/workspace/sis-test-qa-auto
SIS_SERVER_REMOTE=sis-testing

: ${DOCKER_NAMESPACE:=ucberkeley}

update_repository_branch() {
  git remote get-url ${SIS_SERVER_REMOTE} > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    git remote add ${SIS_SERVER_REMOTE} \
        ${SIS_SERVER_ADDRESS}:${SIS_SERVER_PROJECT_DIR}
  fi

  git push ${SIS_SERVER_REMOTE}
}

update_credentials() {
  pass
}

update_docker_images_component() {
  local component=$1

  echo "Updating ${component} Docker image"
  sudo docker save -o=${component}.tar ${DOCKER_NAMESPACE}/sis-qa-test-auto-${component} \
      && scp ${component}.tar ${SIS_SERVER_ADDRESS}:~/ \
      && ssh -t ${SIS_SERVER_ADDRESS} "sudo docker load -i=${component}.tar; rm ${component}.tar"
  rm ${component}.tar
}

update_docker_images() {
  update_docker_images_component server
  update_docker_images_component dashboard
}

update_docker_images
