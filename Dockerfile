FROM centos:7
MAINTAINER "Layershift" <jelastic@layershift.com>

COPY MariaDB.repo /etc/yum.repos.d/MariaDB.repo

RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB \
    && yum update -y \
    && yum -y install http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm \
    && yum -y install which net-tools rsync hostname bind-utils socat \
    && yum --enablerepo=mariadb -y install MariaDB-Galera-server MariaDB-client galera percona-xtrabackup.x86_64

RUN /sbin/chkconfig mysql on

VOLUME /var/lib/mysql /etc/my.cnf.d/

COPY server.cnf /etc/my.cnf.d/server.cnf
COPY iptables /etc/sysconfig/iptables
COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306 4567 4444
