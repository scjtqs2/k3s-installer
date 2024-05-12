#!/bin/bash
# node节点安装 并加入到master集群
#!/bin/bash
curl -sfL https://get.k3s.io | INSTALL_K3S_MIRROR=cn K3S_TOKEN=myPassw0rd123456 INSTALL_K3S_VERSION="v1.26.15+k3s1" K3S_URL="https://10.0.0.122:6443"  sh -s -