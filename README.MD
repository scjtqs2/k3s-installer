# 基于ubuntu 22 快速安装 k3s 1.23.14 环境
> 支持 amd64和 arm64环境

## 一、快速配置环境：
```shell
bash init-config.sh
```
#### 运行上述脚本，将执行下述内容：
+ 配置必要的内核加载
+ 配置必要的网络环境
+ 安装docker-ce
+ 安装1.23.14版本的k8s工具
#### 如果上述部分内容你已经有了，可以查看`init-config.sh`脚本，手动执行部分命令。

## 二、初始化你的 k3s 机器（master)
1. 修改 `config.yaml`文件，为你自己的配置
2. master节点的机器上执行：
```shell
# 安装k3s
bash install-master.sh
# 复制秘钥到当前账号
sudo cp -r /root/.kube ~/
```
3. 安装web控制面板，这里使用的是Kuboard。
```shell
kubectl apply -f kuboard-v3.yaml
```
4. 安装 helm 包管理器
   1. 通过 apt源安装 (国内可能会被墙 或者速度慢)
       ```shell
       bash install-helm.sh
       ```
       #### 卸载方式：
       `sudo apt-get remove helm`
   2. 通过snap包安装 (ubuntu自带snap)
      ```shell
      bash install-helm-snap.sh
      ```
      #### 卸载方式：
      `sudo snap remove helm`
5. 安装证书免费签发工具cert-manager
   `bash install-CRDs-with-customdns.sh`
   #### 卸载方式
   `helm uninstall cert-manager --namespace cert-manager`
6. (可选，非必须) 添加dnspod(实际是腾讯云接口)的dns证书签名验证方式
   > 需要先安装 cert-manager 才能安装该 cert-manager的插件。
   1. 通过 https://console.cloud.tencent.com/cam/capi 获取`secretid`和 `secretkey`.
   2. 修改 `install-qcloud-cm.sh` 中的对应的参数 
   3. 执行 `bash install-qcloud-cm.sh`
   4. 证书申请demo：
      1. 修改 `test-dnspod-cert.yaml` 中的域名、证书名、命名空间
      2. 执行 `kubectl -f test-dnspod-cert.yaml`
   #### 卸载方式：
   `helm uninstall cert-manager-webhook-dnspod -n cert-manager`

## 三、初始化你的 k3s （node节点）机器
1. 修改`install-node.sh` 文件，`K3S_URL`的地址为你的 master的对应地址。
2. 执行`bash install-node.sh` 文件


## 四、 卸载删除你的k3s服务
1. `sudo k3s-killall.sh`
2. `sudo k3s-uninstall.sh` (for master) or `sudo k3s-agent-uninstall.sh` (for node)