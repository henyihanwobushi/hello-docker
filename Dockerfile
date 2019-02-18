FROM centos/s2i-base-centos7

ENV NAME=nginx \
    NGINX_VERSION=1.14 \
    NGINX_SHORT_VER=114 \
    VERSION=0

RUN yum install -y yum-utils && \
    yum install -y centos-release-scl && \
    INSTALL_PKGS="rsync tar gettext hostname bind-utils groff-base shadow-utils rh-mysql57" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all && \
    mkdir -p /var/lib/mysql/data && chown -R mysql.0 /var/lib/mysql && \
    test "$(id mysql)" = "uid=27(mysql) gid=27(mysql) groups=27(mysql)"

# install supervisor
RUN \
    yum update -y && \
    yum install -y epel-release && \
    yum install -y iproute python-setuptools hostname inotify-tools yum-utils which jq && \
    yum clean all && \
    easy_install supervisor

# install nginx
RUN yum install -y yum-utils gettext hostname && \
    yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="nss_wrapper bind-utils rh-nginx${NGINX_SHORT_VER} rh-nginx${NGINX_SHORT_VER}-nginx" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all

# install python2.7
RUN INSTALL_PKGS="libjpeg-turbo libjpeg-turbo-devel python27 python27-python-devel python27-python-setuptools \
    python27-python-pip nss_wrapper httpd24 httpd24-httpd-devel httpd24-mod_ssl \
    httpd24-mod_auth_kerb httpd24-mod_ldap httpd24-mod_session atlas-devel gcc-gfortran \
    libffi-devel libtool-ltdl enchant" && \
    yum install -y centos-release-scl && \
    yum -y --setopt=tsflags=nodocs install --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    # Remove centos-logos (httpd dependency) to keep image size smaller.
    rpm -e --nodeps centos-logos && \
    yum -y clean all --enablerepo='*'

COPY container-files /

ENTRYPOINT [ "/config/bootstrap.sh" ]