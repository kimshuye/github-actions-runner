#!/bin/bash

ORGANIZATION=${ORGANIZATION}
ACCESS_TOKEN=${ACCESS_TOKEN}
REG_TOKEN=${REG_TOKEN}

REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token | jq .token --raw-output)

echo "${env}"

./config.sh --url https://github.com/${ORGANIZATION}/shopping-cart-1 --token ${REG_TOKEN}

# ./config.sh \
#     --url https://github.com/${ORGANIZATION}/shopping-cart-1 \
#     --token ${REG_TOKEN} \
#     --work ${RUNNER_WORKDIR} \
#     --unattended \
#     --replace

cleanup() {
    echo "Removing runner..."
    ./actions-runconfig.sh remove --unattended --token "${REG_TOKEN}"
}

trap 'remove; exit 130' INT
trap 'remove; exit 143' TERM

./run.sh "$*" & wait $!

# ./svc.sh install
# ./svc.sh start & wait $!

