#!/bin/bash
echo "配置内核模块加载"
sudo tee /etc/modules-load.d/containerd.conf<<EOF
overlay
br_netfilter
EOF

sudo tee /etc/modules-load.d/ipvs.conf<<EOF
ip_vs
ip_vs_rr
ip_vs_wrr
ip_vs_sh
nf_conntrack
EOF

sudo modprobe overlay

sudo modprobe br_netfilter

echo "执行网络配置"
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0
net.ipv6.conf.all.forwarding=1
fs.inotify.max_user_instances=81920
fs.inotify.max_user_watches=2621440
EOF

sudo sysctl --system

sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
## 安装docker
echo "开始安装docker"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install containerd.io

# 不需要完整的docker。只需要有containerd就行

# 安装k8s
echo "开始安装k8s 命令工具"
#curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/k8s.list
sudo apt-get update
sudo apt install -y kubectl=1.23.14-00 --allow-downgrades --allow-change-held-packages
sudo apt-mark hold kubectl

