#!/bin/bash
# 安装 cert-manager 的 aliyun dns 支持
# 初始化 aliydns.yaml的配置
git checkout alidns.yaml
# 这里用的是阿里云的 accesskey 和 secretkey
export YOUR_ACCESS_KEY=$(echo -n "这里修改你的accesskey" | base64)
export YOUR_SECRET_KEY=$(echo -n "这里修改你的secretkey" | base64)
export YOUR_EMAIL="你的电子邮箱，随意"
sed -i "s|YOUR_ACCESS_KEY|$YOUR_ACCESS_KEY|g" alidns.yaml
sed -i "s|YOUR_SECRET_KEY|$YOUR_SECRET_KEY|g" alidns.yaml
sed -i "s|certmaster@example.com|$YOUR_EMAIL|g" alidns.yaml
kubectl apply -f alidns.yaml
