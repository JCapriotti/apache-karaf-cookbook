FROM centos:7
MAINTAINER Jason Capriotti <jason.capriotti@gmail.com>

RUN yum clean all
RUN yum install -y curl
RUN curl -L https://omnitruck.chef.io/install.sh | bash

RUN yum update -y && yum install -y \
    sudo \
    wget

# Preinstall Java
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jre-8u121-linux-x64.rpm" && \
    yum localinstall -y jre-8u121-linux-x64.rpm && \
    rm -f jre-8u121-linux-x64.rpm

# Setup kitchen user with passwordless sudo
RUN useradd -d /home/kitchen -m -s /bin/bash kitchen && \
    (echo kitchen:kitchen | chpasswd) && \
    mkdir -p /etc/sudoers.d && \
    echo 'kitchen ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/kitchen

# Setup SSH daemon so test-kitchen can access the container
RUN yum -y install openssh-server openssh-clients && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N '' && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \
    echo 'OPTIONS="-o UseDNS=no -o UsePAM=no -o PasswordAuthentication=yes"' >> /etc/sysconfig/sshd && \
    systemctl start sshd

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
