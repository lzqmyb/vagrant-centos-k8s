#!/usr/bin/env bash

# install cfssl

#下载
wget -q --show-progress --https-only --timestamping \
  https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
  https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
#修改为可执行权限
chmod +x cfssl_linux-amd64 cfssljson_linux-amd64
#移动到bin目录
mv cfssl_linux-amd64 ./kubernetes-bins/cfssl
mv cfssljson_linux-amd64 ./kubernetes-bins/cfssljson
#验证
./kubernetes-bins/cfssl version
