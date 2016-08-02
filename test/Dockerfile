FROM centos:centos6
MAINTAINER Jason Capriotti <jason.capriotti@gmail.com>

RUN yum clean all
RUN yum install -y curl
RUN curl -L https://omnitruck.chef.io/install.sh | bash

RUN yum update -y && \
    yum install -y wget

# Preinstall Java
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.rpm" && \
    yum localinstall -y jdk-7u80-linux-x64.rpm && \
    rm -f jdk-7u80-linux-x64.rpm

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
    service sshd start

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
