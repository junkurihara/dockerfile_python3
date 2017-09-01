FROM ubuntu:xenial

LABEL maintainer "Jun Kurihara <kurihara@ieee.org>"

# initial user is ubuntu and its password is password.
ENV USER=ubuntu PASSWORD=password PYTHONIOENCODING="utf-8"

# SHARE_DIR: Shared directory to the host machine, VENV_DIR: venv directory is ~/.pythonenv
ENV SHARE_DIR=/home/${USER}/share VENV_DIR=/home/${USER}/.pythonenv

VOLUME ${SHARE_DIR}
EXPOSE 22

ADD requirements.txt /tmp/
ADD entrypoint.sh /tmp/
WORKDIR /root/

#
# install ssh and sudo. curl and software-properties-common and curl will be removed.
#
RUN apt-get -qy update &&\
    apt-get install -y openssh-server sudo software-properties-common curl && \
    add-apt-repository ppa:jonathonf/python-3.6 &&\
    apt-get remove -y software-properties-common &&\
    apt -qy autoremove &&\
    apt-get clean\
#
# setting up the initial user
#
    && mkdir -p ${SHARE_DIR} &&\
    useradd -d /home/${USER} -m -s /bin/bash ${USER} &&\
    echo "${USER}:${PASSWORD}" | chpasswd && adduser ubuntu sudo &&\
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
#
# install python 3.6 and pip
#
    && apt-get update &&\
    apt-get install -y python3.6 python3.6-venv &&\
    curl -o /tmp/get-pip.py "https://bootstrap.pypa.io/get-pip.py" &&\
    python3.6 /tmp/get-pip.py &&\
    apt-get remove -y curl &&\
    apt-get autoremove -y &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* \
#
# setting up venv for the initial user
#
    && su  ${USER} &&\
    /bin/bash -c "python3.6 -m venv ${VENV_DIR} &&\
        source ${VENV_DIR}/bin/activate &&\
	pip install --upgrade pip &&\
	pip install -r /tmp/requirements.txt &&\
	deactivate" &&\
    exit

CMD sh /tmp/entrypoint.sh