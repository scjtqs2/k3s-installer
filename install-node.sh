#!/bin/bash
# node节点安装 并加入到master集群
#!/bin/bash
curl -sfL https://get.k3s.io | K3S_TOKEN=myPassw0rd123456 INSTALL_K3S_VERSION="v1.23.14+k3s1" K3S_URL="https://10.0.0.122:6443" sudo sh -s -