# Dockerfile for a basic environment with Python 3
A dockerfile to build a basic environment of `python3.6` with `venv`. To append other python modules via `pip`, `requirements.txt` needs to be configured before you build the image. The `requirements.txt` is written in the `python` requirements format given by `pip freeze` in your desired environment.

## How to build the docker image from the Dockerfile
```
$ cd path/to/dockerfile_directory
$ docker build -t image_name .
```

## How to create a container from the image
The following commands connects the port 10000 of localhost to the container's port 22 for SSH. The container mounts `$PWD/share` into `/home/${USER}/share`.
```
$ docker run --name container_name -it -d -p 10000:22 -v $PWD/share:/home/ubuntu/share image_name
```
## How to login the container via SSH
The initial user is `${USER}` defined in the Dockerfile.
```
$ ssh -p 10000 user_name@localhost
```

## How to login the container directly from your shell

```
$ docker exec -u ubuntu -it container_name /bin/bash -c "cd ~ && /bin/bash"
```

## Where is `venv` directory?
It is specified by `${VENV_DIR}` in the Dockerfile and the default location is `/home/user_name/.pythonenv`. Before you run your python code in the container, you should activate the virtual environment as follows.
```
$ source .pythonenv/bin/activate
(.pythonenv) python path/to/your/python/code.py
(.pythonenv) deactivate
$
```
