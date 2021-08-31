#!/usr/bin/env bash

echo "Starting Magma Build..."

git clone https://github.com/magma/magma.git --depth 1

MAGMA_ROOT=$PWD/magma
PUBLISH=$MAGMA_ROOT/orc8r/tools/docker/publish.sh
REGISTRY=shubhamtatvamasi
MAGMA_TAG=$(date +%m-%d-%Y-%s)

echo $MAGMA_ROOT
echo $PUBLISH
echo $REGISTRY
echo $MAGMA_TAG

ls $MAGMA_ROOT

