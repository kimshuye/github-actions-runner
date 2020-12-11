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




