*automatically start Oracle 10g on CentOS 5 ?
A: 
1. /etc/oratab. At the end should be Y
2. vi $ORACLE_HOME/bin/dbstart
line 78 set ORACLE_HOME_LISTNER=$ORALCE_HOME
3.
> /etc/rc.d/init.d/oracle
echo '
#!/bin/bash
# chkconfig: 345 99 10
# description: Oracle auto start-stop script.
case "$1" in
  start)
        su - oracle -c dbstart >> /var/log/oracle
        su - oracle -c "lsnrctl start" >> /var/log/oracle
        ;;
  stop)
        su - oracle -c "lsnrctl stop" >> /var/log/oracle
        su - oracle -c dbshut >> /var/log/oracle
        ;;
  restart)
        su - oracle -c dbshut >> /var/log/oracle
        su - oracle -c dbstart >> /var/log/oracle
        su - oracle -c "lsnrctl stop" >> /var/log/oracle
        su - oracle -c "lsnrctl start" >> /var/log/oracle
        ;;
  *)
        echo "Usage: oracle {start|stop|restart}"
        exit 1
esac
'>> /etc/rc.d/init.d/oracle

chmod 750 /etc/rc.d/init.d/oracle

#chkconfig --add oracle
chkconfig --level 2345 oracle on
chkconfig --list oracle
