#!/bin/bash

# set environment variables used in deploy.sh and AWS task-definition.json:
export IMAGE_NAME=personal-api
export IMAGE_VERSION=latest

export AWS_DEFAULT_REGION=ap-southeast-2
export AWS_ECS_CLUSTER_NAME=default
export AWS_VIRTUAL_HOST=3.105.90.113
