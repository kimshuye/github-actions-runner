#!/bin/bash

ORGANIZATION=$ORGANIZATION
ACCESS_TOKEN=$ACCESS_TOKEN
REG_TOKEN=$REG_TOKEN

REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token | jq .token --raw-output)

echo "${env}"

./actions-runner/config.sh --url https://github.com/${ORGANIZATION}/shopping-cart-1 --token ${REG_TOKEN}

cleanup() {
    echo "Removing runner..."
    ./actions-runconfig.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./actions-runner/run.sh & wait $!

