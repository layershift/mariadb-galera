FROM bbania/centos:base
MAINTAINER "Layershift" <jelastic@layershift.com>

COPY ./MariaDB.repo /etc/yum.repos.d/

RUN yum install -q -y rsync bind-utils socat m4 mailx sendmail sendmail-cf
RUN rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
RUN yum -q -y install http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm
RUN yum -q --enablerepo=mariadb -y install MariaDB-Galera-server MariaDB-client galera percona-xtrabackup.x86_64
RUN yum -q clean all

RUN /sbin/chkconfig mysql on && /sbin/chkconfig sendmail on

RUN mkdir /root/scripts

COPY ./checker ./galeramonitor /root/scripts/
COPY ./server.cnf /etc/my.cnf.d/server.cnf
COPY ./iptables /etc/sysconfig/iptables
COPY ./user.sql ./clusterdown ./clustersize ./clusterstatus /tmp/
COPY ./crontab /var/spool/cron/root

VOLUME /var/lib/mysql /etc/my.cnf.d/ /root/ /var/spool/cron/

EXPOSE 3306 4567 4444

