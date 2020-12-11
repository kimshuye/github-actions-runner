# base
FROM ubuntu:18.04

# set the github runner version
ARG RUNNER_VERSION="2.274.2"

# ENV ORGANIZATION=$ORGANIZATION
# ENV ACCESS_TOKEN=$ACCESS_TOKEN
# ENV REG_TOKEN=$REG_TOKEN

WORKDIR /home/docker

# update the base packages and add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

# install python and the packages the your code depends on along with jq so we can parse JSON
# add additional packages as necessary
RUN apt-get install -y curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev tar jq

# cd into the user directory, download and unzip the github actions runner
RUN mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

VOLUME /var/run/docker.sock

# install some additional dependencies
# RUN ./actions-runner/bin/installdependencies.sh

RUN chown -R docker ~docker && ./actions-runner/bin/installdependencies.sh

# copy over the start.sh script
COPY start.sh ./actions-runner/start.sh

# make the script executable
RUN chmod +x ./actions-runner/start.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./actions-runner/start.sh"]

