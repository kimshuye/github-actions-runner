# base
FROM ubuntu:18.04

# set the github runner version
ARG RUNNER_VERSION="2.274.2"

ARG ORGANIZATION
ARG ACCESS_TOKEN
ARG REG_TOKEN
ENV ORGANIZATION=${ORGANIZATION}
ENV ACCESS_TOKEN=${ACCESS_TOKEN}
ENV REG_TOKEN=${REG_TOKEN}

# USER docker

WORKDIR /srv/actions-runner

# update the base packages and add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

# install python and the packages the your code depends on along with jq so we can parse JSON
# add additional packages as necessary
RUN apt-get install -y curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev

# cd into the user directory, download and unzip the github actions runner
RUN curl -O -L curl -O -L https://github.com/actions/runner/releases/download/v2.274.2/actions-runner-linux-x64-2.274.2.tar.gz \
    && tar xzf ./actions-runner-linux-x64-2.274.2.tar.gz

# VOLUME /var/run/docker.sock

# install some additional dependencies
# RUN ./bin/installdependencies.sh
RUN chown -R docker ~docker && ./bin/installdependencies.sh
RUN chown -R docker /srv/actions-runner

# copy over the start.sh script
COPY start.sh ./start.sh

# make the script executable
RUN chmod +x ./start.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]

