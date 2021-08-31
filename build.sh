#!/usr/bin/env bash

# dockerhub username
REGISTRY=shubhamtatvamasi

MAGMA_ROOT=${PWD}/magma
PUBLISH=${MAGMA_ROOT}/orc8r/tools/docker/publish.sh
MAGMA_TAG=$(date +%m-%d-%Y--%H-%M-%S)

echo "Cloning magma repo:"
git clone https://github.com/magma/magma.git --depth 1

echo "Deleting docker login code block:"
sed -i '65,71d' ${PUBLISH}

echo "Building controller and nginx docker images:"
cd ${MAGMA_ROOT}/orc8r/cloud/docker
./build.py --all

echo "Pushing controller and nginx docker images:"
for image in controller nginx
do
  ${PUBLISH} -r ${REGISTRY} -i ${image} -v ${MAGMA_TAG}
done

echo "Building NMS docker image:"
cd ${MAGMA_ROOT}/nms/packages/magmalte
docker-compose build magmalte

echo "Pushing NMS docker image:"
COMPOSE_PROJECT_NAME=magmalte ${PUBLISH} -r ${REGISTRY} -i magmalte -v ${MAGMA_TAG}
