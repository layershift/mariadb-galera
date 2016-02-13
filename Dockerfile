FROM bbania/centos:galera
MAINTAINER "Layershift" <jelastic@layershift.com>

VOLUME /var/lib/mysql /etc/my.cnf.d/ /root/ /var/spool/cron/

RUN /sbin/chkconfig mysql on && /sbin/chkconfig sendmail on

RUN mkdir /root/scripts

COPY ./checker ./galeramonitor /root/scripts/
COPY ./server.cnf /etc/my.cnf.d/server.cnf
COPY ./iptables /etc/sysconfig/iptables
COPY ./user.sql ./clusterdown ./clustersize ./clusterstatus /tmp/
COPY ./crontab /var/spool/cron/root

EXPOSE 3306 4567 4444

