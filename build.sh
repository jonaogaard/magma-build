#!/usr/bin/env bash

echo "Starting Magma Build..."

git clone https://github.com/magma/magma.git --depth 1

MAGMA_ROOT=${PWD}/magma
PUBLISH=${MAGMA_ROOT}/orc8r/tools/docker/publish.sh
REGISTRY=shubhamtatvamasi
MAGMA_TAG=$(date +%m-%d-%Y-%s)

echo "Building controller and nginx docker image:"
cd ${MAGMA_ROOT}/orc8r/cloud/docker
./build.py -a

