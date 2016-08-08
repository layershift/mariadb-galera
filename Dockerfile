FROM bbania/centos:base
MAINTAINER "Layershift" <jelastic@layershift.com>   

COPY ./configs/MariaDB.repo /etc/yum.repos.d/
RUN rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB

RUN yum install -y rsync bind-utils socat m4 mailx sendmail sendmail-cf && \
    yum -y install http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm && \
    yum --enablerepo=mariadb -y install MariaDB-server MariaDB-client galera percona-xtrabackup.x86_64 && \
    yum clean all

RUN systemctl enable sendmail
RUN mkdir /root/scripts

COPY ./configs/checker ./configs/galeramonitor /root/scripts/
COPY ./configs/server.cnf /etc/my.cnf.d/server.cnf
COPY ./configs/iptables /etc/sysconfig/iptables
COPY ./configs/user.sql ./configs/clusterdown ./configs/clustersize ./configs/clusterstatus /tmp/
COPY ./configs/crontab /var/spool/cron/root

VOLUME /var/lib/mysql/ /etc/my.cnf.d/ /root/ /var/spool/cron/

EXPOSE 3306 4567 4444

