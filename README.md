# github-actions-runner


### Reference

https://testdriven.io/blog/github-actions-docker/


## Install Docker Machine


If you are running macOS:


```
base=https://github.com/docker/machine/releases/download/v0.16.0 &&
curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/usr/local/bin/docker-machine &&
chmod +x /usr/local/bin/docker-machine
```


If you are running Linux:


```
base=https://github.com/docker/machine/releases/download/v0.16.0 &&
curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
sudo mv /tmp/docker-machine /usr/local/bin/docker-machine &&
chmod +x /usr/local/bin/docker-machine
```


If you are running Windows with Git BASH:


```
base=https://github.com/docker/machine/releases/download/v0.16.0 &&
mkdir -p "$HOME/bin" &&
curl -L $base/docker-machine-Windows-x86_64.exe > "$HOME/bin/docker-machine.exe" &&
chmod +x "$HOME/bin/docker-machine.exe"
```


## Add script install docker

```
sudo chmod +x install-etc-2.sh
```

## Run install-etc-2.sh

```
./install-etc-2.sh
```

## Add Start bash

```
sudo chmod +x start.sh
```


## Login docker hub registry


```
docker login --username tokdev 
```


## Env

```
export IMG_NAME=tokdev/runner
export TAG_IMG=dev0.0.1
export CONTAINER_NAME=runner

export ORGANIZATION=kimshuye
export ACCESS_TOKEN=xxx
export REG_TOKEN=xxx
```


## Create docker image


```
docker build --tag ${IMG_NAME}:${TAG_IMG} --build-arg ORGANIZATION=$ORGANIZATION --build-arg ACCESS_TOKEN=$ACCESS_TOKEN  . 
```

## Test Run runner

```sh
docker run  \
    --env ORGANIZATION=${ORGANIZATION} \
    --env ACCESS_TOKEN=${ACCESS_TOKEN} \
    --name ${CONTAINER_NAME}  ${IMG_NAME} \
    -v /var/run/docker.sock:/var/run/docker.sock 
```


## Start docker by compose

```
docker-compose up
# or
docker-compose up --scale runner=2 -d
```

