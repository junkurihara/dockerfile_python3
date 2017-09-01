FROM alpine:3.6

LABEL maintainer "Jun Kurihara <kurihara@ieee.org>"

# initial user is alpine and its password is password.
ENV USER=alpine PASSWORD=password PYTHONIOENCODING="utf-8"

# SHARE_DIR: Shared directory to the host machine, VENV_DIR: venv directory is ~/.pythonenv
ENV SHARE_DIR=/home/${USER}/share VENV_DIR=/home/${USER}/.pythonenv

VOLUME ${SHARE_DIR}
EXPOSE 22

ADD requirements.txt /tmp/
ADD entrypoint.sh /tmp/
WORKDIR /root/

#
# install ssh, sudo, bash, python3.
#
RUN apk --update --no-cache add openrc bash openssh sudo g++ musl-dev linux-headers python3 python3-dev &&\
    python3 -m ensurepip\
#
# setting up the initial user
#
    && mkdir mkdir -p ${SHARE_DIR} &&\
    adduser -h /home/${USER} -s /bin/bash -D ${USER} &&\
    echo "${USER}:${PASSWORD}" | chpasswd &&\
    echo "${USER} ALL=(ALL) ALL" >> /etc/sudoers\
#
# setting up venv for the initial user
#
    && sudo -u ${USER}\
        /bin/bash -c "python3 -m venv ${VENV_DIR} &&\
	source ${VENV_DIR}/bin/activate &&\
	pip install --upgrade pip setuptools &&\
	pip install -r /tmp/requirements.txt &&\
	rm -r ~/.cache &&\
	deactivate"

CMD sh /tmp/entrypoint.sh