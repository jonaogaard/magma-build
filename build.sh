#!/usr/bin/env bash

set -ex

# dockerhub username:
REGISTRY=jonaoegaard

# magma variables:
MAGMA_ROOT=${PWD}/magma
PUBLISH=${MAGMA_ROOT}/orc8r/tools/docker/publish.sh

# Cloning magma repo:
git clone https://github.com/magma/magma.git --depth 1

cd ${MAGMA_ROOT}
MAGMA_TAG=$(git rev-parse --short HEAD)

# Deleting docker login code block:
sed -i '64,73d' ${PUBLISH}

orc8r() {

  # Building Orchestrator docker images:
  cd ${MAGMA_ROOT}/orc8r/cloud/docker
  ./build.py --all

  # Pushing Orchestrator docker images:
  for image in controller nginx
  do
    ${PUBLISH} -r ${REGISTRY} -i ${image} -v ${MAGMA_TAG}
  done
}

nms() {

  # Building NMS docker image:
  cd ${MAGMA_ROOT}/nms
  export COMPOSE_PROJECT_NAME=magmalte
  docker-compose build magmalte

  # Pushing NMS docker image:
  ${PUBLISH} -r ${REGISTRY} -i magmalte -v ${MAGMA_TAG}
}

feg() {

  # Building Federation Gateway docker images:
  cd ${MAGMA_ROOT}/feg/gateway/docker
  docker-compose build --parallel

  # Pushing Federation Gateway docker images:
  for image in gateway_python gateway_go
  do
    ${PUBLISH} -r ${REGISTRY} -i ${image} -v ${MAGMA_TAG}
  done  
}

cwf() {

  # Building CWF docker images:
  cd ${MAGMA_ROOT}/cwf/gateway/docker
  docker-compose build --parallel

  # Pushing CWF docker images:
  for image in cwag_go gateway_pipelined gateway_sessiond
  do
    ${PUBLISH} -r ${REGISTRY} -i ${image} -v ${MAGMA_TAG}
  done  
}

operator() {

  # Building Operator docker image:
  cd ${MAGMA_ROOT}/cwf/k8s/cwf_operator/docker
  docker-compose build

  # Pushing Operator docker image:
  for image in operator
  do
    ${PUBLISH} -r ${REGISTRY} -i ${image} -v ${MAGMA_TAG}
  done
}

agw() {

  # Building AGW docker images:
  cd ${MAGMA_ROOT}/lte/gateway/docker
  export DOCKER_BUILDKIT=1
  docker-compose build --parallel

  # Pushing AGW docker images:
  for image in agw_gateway_python agw_gateway_c
  do
    docker tag ${image} ${REGISTRY}/${image}:${MAGMA_TAG}
    docker push ${REGISTRY}/${image}:${MAGMA_TAG}
  done
}

dp() {

  # Building Domain Proxy docker images:
  cd ${MAGMA_ROOT}/dp
  make _install_skaffold_ci
  skaffold build --default-repo="${REGISTRY}" --tag="${MAGMA_TAG}" --push --profile=remote-push
}

${1}

# if ! docker manifest inspect ${REGISTRY}/magmalte:${MAGMA_TAG} &> /dev/null
# then
#   ${1}
# fi
