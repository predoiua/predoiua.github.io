======= run as root ================
- Linux parameters

cp /etc/sysctl.conf /etc/sysctl.conf.bak
sed -i "s/fs\.file-max.*/fs\.file-max=6815744/g" /etc/sysctl.conf
sed -i "s/net\.ipv4\.ip_local_port_range.*/net\.ipv4\.ip_local_port_range=9000 65500/g" /etc/sysctl.conf
sed -i "s/net\.core\.rmem_max.*/net\.core\.rmem_max=4194304/g" /etc/sysctl.conf
sed -i "s/net\.core\.wmem_max.*/net\.core\.wmem_max=1048576/g" /etc/sysctl.conf
sed -i "s/kernel\.shmmax.*/kernel\.shmmax=3129571328/g" /etc/sysctl.conf

echo " 
fs.aio-max-nr=1048576
">>/etc/sysctl.conf

diff /etc/sysctl.conf /etc/sysctl.conf.bak
vi /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
mv /etc/sysctl.conf.bak /etc/sysctl.conf.10g
diff /etc/sysctl.conf /etc/sysctl.conf.10g

- Supplementary packages compare with Oracle 10


rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n"| grep pdksh

yum install libaio-devel
yum install sysstat-7.0.2
yum install pdksh

- backup Oracle 10 configuration file
cp /usr/local/bin/dbhome /usr/local/bin/dbhome.10g
cp /usr/local/bin/oraenv /usr/local/bin/oraenv.10g
cp /usr/local/bin/coraenv /usr/local/bin/coraenv.10g
cp /etc/oratab /etc/oratab.10g

=========== run as oracle ==================
- Install Oracle 11g
runInstall
select software only

- Create DB
#comment 10g line, add 11g line
#set ORACLE_HOME value for 11g home, default 
export ORACLE_HOME=/home/oracle/app/oracle/product/11.2.0/db_1
#comment Oracle 10g line
vi /etc/oratab
. ~/.bashrc

dbca