# Latest version of centos
FROM centos:latest
MAINTAINER Petr Ruzicka <petr.ruzicka@gmail.com>

# Update base image
RUN yum -y update; yum clean all

RUN yum -y install epel-release; yum clean all

RUN yum -y install gcc git make openssh-clients openssl-devel python-devel python-pip sudo; yum clean all

#Newer setuptools are needed for installing ansible using "make install" to fill requirement setuptools>=11.3
RUN pip install --upgrade awscli azure boto boto3 docker-py pywinrm setuptools

RUN git clone https://github.com/ansible/ansible.git --recursive && \
    cd ./ansible && \
    source ./hacking/env-setup -q && \
    pip install -r ./requirements.txt && \
    make install && \
    cd .. && \
    rm -rf ansible

RUN groupadd -r ansible -g 433 && \
    useradd -u 431 -r -g ansible -d /home/ansible -s /sbin/nologin -c "Ansible Docker image user" ansible && \
    mkdir -p /home/ansible/.ansible/{tmp,cp}

ENV HOME=/home/ansible
ENV USER=ansible

USER root

VOLUME /home/ansible/ansible_project

WORKDIR /home/ansible/ansible_project

# default command:
CMD [ "ansible-playbook" ]
