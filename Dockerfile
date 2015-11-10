FROM centos:7
MAINTAINER "Layershift" <jelastic@layershift.com>

COPY MariaDB.repo /etc/yum.repos.d/MariaDB.repo

RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB \
    && yum install -y http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm \
    && yum install -y MariaDB-server MariaDB-client galera percona-xtrabackup.x86_64 
    
VOLUME /var/lib/mysql /etc/my.cnf.d/

COPY galera.cnf /etc/my.cnf.d/galera.cnf
COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306 4567
CMD ["mysqld"]
