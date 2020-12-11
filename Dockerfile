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

ENV RUNNER_NAME "runner"
ENV GITHUB_PAT ""
ENV GITHUB_OWNER ""
ENV GITHUB_REPOSITORY ""
ENV RUNNER_WORKDIR "_work"

# update the base packages and add a non-sudo user
RUN apt-get update \
    && apt-get install -y \
        curl \
        sudo \
        git \
        jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

RUN apt-get update -y && apt-get upgrade -y && useradd -m docker \
    && usermod -aG sudo docker \
    && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER docker
WORKDIR /home/docker/actions-runner

# install python and the packages the your code depends on along with jq so we can parse JSON
# add additional packages as necessary
RUN sudo apt-get install -y curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev

# VOLUME /var/run/docker.sock

# install some additional dependencies
# RUN sudo ./bin/installdependencies.sh
RUN sudo chown -R docker ~docker && sudo ./bin/installdependencies.sh

# cd into the user directory, download and unzip the github actions runner
RUN curl -O -L curl -O -L https://github.com/actions/runner/releases/download/v2.274.2/actions-runner-linux-x64-2.274.2.tar.gz \
    && tar xzf ./actions-runner-linux-x64-2.274.2.tar.gz

# copy over the start.sh script
COPY start.sh ./start.sh

# make the script executable
RUN sudo chmod +x ./start.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
# USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]

