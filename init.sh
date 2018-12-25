
# one

yum install -y wget curl conntrack-tools vim net-tools socat ntp kmod ceph-common
echo 'sync time'
systemctl start ntpd
systemctl enable ntpd
echo 'disable selinux'
# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

echo 'enable iptable kernel parameter'
cat >> /etc/sysctl.conf <<EOF
net.ipv4.ip_forward=1
EOF
sysctl -p

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

echo 'set host name resolution'
cat > /etc/hosts <<EOF
172.17.8.101 node1
172.17.8.102 node2
172.17.8.103 node3
EOF

cat /etc/hosts

echo 'set nameserver'
echo "nameserver 8.8.8.8">/etc/resolv.conf
cat /etc/resolv.conf

echo 'disable swap'
swapoff -a
sed -i '/swap/s/^/#/' /etc/fstab

#echo "unzip kubernetes-server-linux-amd64.tar.gz "
#tar -xzvf /vagrant/kubernetes-server-linux-amd64.tar.gz -C /vagrant > /dev/null 2>&1
cp /vagrant/kubernetes-bins/* /usr/local/bin

#create group if not exists
egrep "^docker" /etc/group >& /dev/null
if [ $? -ne 0 ]
then
groupadd docker
fi

usermod -aG docker vagrant
rm -rf ~/.docker/
yum install -y docker.x86_64 >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "install doTcker failed"
    exit 0
fi

cat > /etc/docker/daemon.json <<EOF
{
"registry-mirrors" : ["http://2595fda0.m.daocloud.io"]
}
EOF

node_ip=$2
cat > /vagrant/config.properties <<EOF
#kubernetes二进制文件目录,eg: /home/michael/bin
BIN_PATH=/usr/local/bin

#当前节点ip, eg: 192.168.1.102
NODE_IP=${node_ip}

#etcd服务集群列表, eg: http://192.168.1.102:2379
#如果已有etcd集群可以填写现有的。没有的话填写：http://MASTER_IP:2379 （MASTER_IP自行替换成自己的主节点ip）
ETCD_ENDPOINTS=http://172.17.8.101:2379

#kubernetes主节点ip地址, eg: 192.168.1.102
MASTER_IP=172.17.8.101
EOF


# etcd
cd /vagrant
gen-config.sh simple



# 初始话master
if [[ $1 -eq 1 ]];then
./master-init.sh
fi

# 初始话node
if [[ $1 -ge 2 ]];then
./node-init.sh
fi


