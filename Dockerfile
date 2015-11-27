FROM centos:7
MAINTAINER "Layershift" <jelastic@layershift.com>

COPY MariaDB.repo /etc/yum.repos.d/MariaDB.repo

RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB \
    && yum update -y \
    && yum -y install http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm \
    && yum -y install which net-tools rsync hostname bind-utils socat \
    && yum --enablerepo=mariadb -y install MariaDB-Galera-server MariaDB-client galera percona-xtrabackup.x86_64 \
    && yum -y install m4 mailx sendmail sendmail-cf \
    && yum clean all

RUN /sbin/chkconfig mysql on
RUN /sbin/chkconfig sendmail on
RUN mkdir /root/scripts

VOLUME /var/lib/mysql /etc/my.cnf.d/ 

COPY galeramonitor /root/scripts/galera_monitor
COPY checker /root/scripts/checker
COPY server.cnf /etc/my.cnf.d/server.cnf
COPY iptables /etc/sysconfig/iptables
COPY user.sql /tmp/user.sql
COPY crontab /var/spool/cron/root

EXPOSE 3306 4567 4444
