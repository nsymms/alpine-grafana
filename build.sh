#!/bin/bash
_grafana_version=$1
_grafana_tag=$2

if [ -z "${_grafana_tag}" ]; then
    source GRAFANA_VERSION   
    _grafana_version=${GRAFANA_VERSION}
    _grafana_tag=${GRAFANA_VERSION}
fi

docker build --build-arg GRAFANA_VERSION=${_grafana_version} --tag "nsymms/alpine-grafana:${_grafana_tag}"  --no-cache=true .
