FROM centos:centos6
MAINTAINER Jason Capriotti <jason.capriotti@gmail.com>

RUN yum clean all
RUN yum install -y curl
RUN curl -L https://omnitruck.chef.io/install.sh | bash

RUN yum update -y && \
yum install -y wget && \
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.rpm" && \
yum localinstall -y jdk-7u80-linux-x64.rpm && \
rm -f jdk-7u80-linux-x64.rpm

RUN yum -y install openssh-server openssh-clients
RUN chkconfig sshd on
RUN service sshd start

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
