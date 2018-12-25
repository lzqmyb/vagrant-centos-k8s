#!/bin/bash

config_path=/vagrant/target

#确保相关目录存在
mkdir -p /var/lib/kubelet
mkdir -p /etc/kubernetes
mkdir -p /etc/cni/net.d

#复制kubelet服务配置文件
#复制kubelet依赖的配置文件
#复制kubelet用到的cni插件配置文件
cp ${config_path}/worker-node/kubelet.service /lib/systemd/system/
cp ${config_path}/worker-node/kubelet.kubeconfig /etc/kubernetes/
cp ${config_path}/worker-node/10-calico.conf /etc/cni/net.d/

cp ${config_path}/all-node/kube-calico.service /lib/systemd/system/
systemctl enable kube-calico.service
service kube-calico start

systemctl enable kubelet.service
service kubelet start

#确保工作目录存在
#复制kube-proxy服务配置文件
#复制kube-proxy依赖的配置文件
#mkdir -p /var/lib/kube-proxy
#cp ${config_path}/worker-node/kube-proxy.service /lib/systemd/system/
#cp ${config_path}/worker-node/kube-proxy.kubeconfig /etc/kubernetes/
#
#systemctl enable kube-proxy.service
#service kube-proxy start
#journalctl -f -u kube-proxy


