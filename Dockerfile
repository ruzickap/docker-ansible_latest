# Latest version of centos
FROM centos:latest
MAINTAINER Petr Ruzicka <petr.ruzicka@gmail.com>

# Update base image and install EPEL
RUN yum -y update; yum -y install epel-release; yum clean all

RUN yum -y install git python-pip; yum clean all

RUN pip install --upgrade boto boto3 docker-py pywinrm git+https://github.com/ansible/ansible.git@devel

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
