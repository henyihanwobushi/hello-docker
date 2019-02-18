FROM centos/s2i-base-centos7

ENV NAME=nginx \
    NGINX_VERSION=1.14 \
    NGINX_SHORT_VER=114 \
    VERSION=0

# install base packages
RUN yum update -y && \
    INSTALL_PKGS="yum-utils hostname which centos-release-scl" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    yum clean all

# install mysql
RUN INSTALL_PKGS="mariadb-server" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all

# install nginx
RUN INSTALL_PKGS="nginx" && \
    rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all

# install python2.7
RUN INSTALL_PKGS="python27 python27-python-devel python27-python-setuptools python27-python-pip " && \
    yum -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all

# install supervisor
RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y python-setuptools && \
    yum clean all && \
    easy_install supervisor

COPY container-files /

USER root
ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]