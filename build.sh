#!/usr/bin/env bash

# dockerhub username
REGISTRY=shubhamtatvamasi

MAGMA_ROOT=${PWD}/magma
PUBLISH=${MAGMA_ROOT}/orc8r/tools/docker/publish.sh
MAGMA_TAG=$(date +%m-%d-%Y--%H-%M-%S)

# Cloning magma repo:
git clone https://github.com/magma/magma.git --depth 1

# Deleting docker login code block:
sed -i '65,71d' ${PUBLISH}

# Building controller and nginx docker images:
cd ${MAGMA_ROOT}/orc8r/cloud/docker
./build.py --all

# Pushing controller and nginx docker images:
# for image in controller nginx
# do
#   ${PUBLISH} -r ${REGISTRY} -i ${image} -v ${MAGMA_TAG}
# done

# Building NMS docker image:
cd ${MAGMA_ROOT}/nms/packages/magmalte
docker-compose build magmalte

# Pushing NMS docker image:
# COMPOSE_PROJECT_NAME=magmalte ${PUBLISH} -r ${REGISTRY} -i magmalte -v ${MAGMA_TAG}

# Building Federation Gateway docker images:
cd ${MAGMA_ROOT}/feg/gateway/docker
docker-compose build --parallel

magma_images=(controller nginx magmalte gateway_python gateway_go)

# Pushing Federation Gateway docker images:
for image in ${magma_images}
do
  ${PUBLISH} -r ${REGISTRY} -i ${image} -v ${MAGMA_TAG}
done
