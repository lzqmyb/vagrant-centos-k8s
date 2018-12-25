#!/bin/bash

config_path=/vagrant/target

#把服务配置文件copy到系统服务目录
#enable服务
#创建工作目录(保存数据的地方)
# 启动服务
# 查看服务日志，看是否有错误信息，确保服务正常
cp ${config_path}/master-node/etcd.service /lib/systemd/system/
systemctl enable etcd.service
mkdir -p /var/lib/etcd
service etcd start
#journalctl -f -u etcd.service

cp ${config_path}/master-node/kube-apiserver.service /lib/systemd/system/
systemctl enable kube-apiserver.service
service kube-apiserver start
#journalctl -f -u kube-apiserver

cp ${config_path}/master-node/kube-controller-manager.service /lib/systemd/system/
systemctl enable kube-controller-manager.service
service kube-controller-manager start
#journalctl -f -u kube-controller-manager

cp ${config_path}/master-node/kube-scheduler.service /lib/systemd/system/
systemctl enable kube-scheduler.service
service kube-scheduler start
#journalctl -f -u kube-scheduler


cp ${config_path}/all-node/kube-calico.service /lib/systemd/system/
systemctl enable kube-calico.service
service kube-calico start
#journalctl -f -u kube-calico

#指定apiserver地址（ip替换为你自己的api-server地址）
#指定设置上下文，指定cluster
#选择默认的上下文
kubectl config set-cluster kubernetes  --server=http://172.17.8.101:8080
kubectl config set-context kubernetes --cluster=kubernetes
kubectl config use-context kubernetes
