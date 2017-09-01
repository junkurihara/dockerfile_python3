# Dockerfile for a basic environment with Python 3
A dockerfile to build a basic environment of `python3.6` with `venv`.

## How to build the docker image from the Dockerfile
```
$ cd path/to/dockerfile_directory
$ docker build -t basic_python3 .
```

## How to create a container from the image
The following commands connects the port 10000 of localhost to the container's port 22 for SSH. The container mounts `$PWD/share` into `/home/ubuntu/share`.
```
$ docker run --name basic_python3 -it -d -p 10000:22 -v $PWD/share:/home/ubuntu/share basic_python3
```
## How to login the container via SSH
The initial user is `${USER}` defined in the Dockerfile.
```
$ ssh -p 10000 ubuntu@localhost
```

## How to login the container directly from your shell

```
$ docker exec -u ubuntu -it basic_python3 /bin/bash -c "cd ~ && /bin/bash"
```
