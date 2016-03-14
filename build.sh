#!/bin/bash
_grafana_version=$1
_grafana_tag=$2

docker build --tag "orangesys/alpine-s6-grafana:${_grafana_tag}"  --no-cache=true .
