#!/bin/bash
# master节点初始化安装
curl -sfL https://get.k3s.io | K3S_TOKEN=myPassw0rd123456 INSTALL_K3S_VERSION="v1.23.14+k3s1" K3S_CONFIG_FILE=`pwd`/config.yaml INSTALL_K3S_EXEC="--kube-apiserver-arg service-node-port-range=1-65535  --write-kubeconfig ~/.kube/config --write-kubeconfig-mode 666 --disable traefik" sudo sh -s -