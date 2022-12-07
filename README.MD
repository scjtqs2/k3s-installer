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

### ！！！！！！文件后缀说明！！！！！！
+ `cnproxy`： 国内网络环境，套了一层代理，防止出现github等访问失败的特殊处理脚本
+ `dual-stack`: 增加了对ipv6的支持。ipv4和ipv6双栈支持。
## 二、初始化你的 k3s 机器（master)
1. 修改 `config.yaml`文件，为你自己的配置
2. master节点的机器上执行：
```shell
# 安装k3s
sudo  ./install-master.sh
# 复制秘钥到当前账号
mkdir -p $HOME/.kube
sudo cp -i /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
> 如果你的网络对github的release下载不友好。
> 
> 请使用 `sudo ./install-master-cnproxy.sh`代替。

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
   3. 通过二进制包安装：
      去`https://github.com/helm/helm/releases`下载安装即可
5. 安装证书免费签发工具cert-manager
   `bash install-CRDs-with-customdns.sh`
   #### 卸载方式
   `helm uninstall cert-manager --namespace cert-manager`
6. 安装ingress(1.3.0)，这里有两种方式安装,二选一:
   1. hostport。会占用本机的80和443端口。如果本机不需要nginx或者nginx配置成其他端口，可以使用。
   > `kubectl apply -f ingress_hostport.yaml`
   2. nodeport。会随机生成两个端口，分别代表http和https端口。不会占用本机的80和443。
   > `kubectl apply -f ingress_nodeport.yaml`
   >
   > 安装完成后，执行 `kubectl get svc -n ingress-nginx` 可以看到 80和443分别映射出来的端口。
   >
   > 输入 `kubectl get pod -n ingress-nginx` 查看ingress的安装进度。等所有pod都ok了，就可以了。
   #### 卸载说明
   > `kbuectl delete -f ingress_hostport.yaml` 或者  `kbuectl delete -f ingress_nodeport.yaml` 填你安装的时候选择的方式。
7. (可选，非必须) 添加dnspod(实际是腾讯云接口)的dns证书签名验证方式
   > 需要先安装 cert-manager 才能安装该 cert-manager的插件。
   1. 通过 https://console.cloud.tencent.com/cam/capi 获取`secretid`和 `secretkey`.
   2. 修改 `install-qcloud-cm.sh` 中的对应的参数 
   3. 执行 `bash install-qcloud-cm.sh`
   4. 证书申请demo：
      1. 修改 `test-dnspod-cert.yaml` 中的域名、证书名、命名空间
      2. 执行 `kubectl -f test-dnspod-cert.yaml`
   #### 卸载方式：
   `helm uninstall cert-manager-webhook-dnspod -n cert-manager`
8. (可选，非必须) 添加cloudflare 方式进行dns证书签名
   1. 打开`clouflare-cm.yaml` 填入你的对应信息。
   2. `apiTokenSecretRef` 和 `apiKeySecretRef` 二选一。注释掉另一方。
   3. 执行 `kubectl apply -f clouflare-cm.yaml`
   4. 证书申请demo：
      1. 修改 `test-cf-cert.yaml` 中的域名、证书名、命名空间
      2. 执行 `kubectl -f test-cf-cert.yaml`
   #### 卸载方式：
   `kubectl delete -f clouflare-cm.yaml`
9. (可选，非必须) 添加aliyun的dns证书签名验证方式
   > 需要先安装 cert-manager 才能安装该 cert-manager的插件。
   1. 通过 https://ak-console.aliyun.com/?spm=5176.2020520001.0.0.dCHOyj#/accesskey 获取`Access Key ID`和 `Access Key Secret`.
   2. 修改 `install-aliyun-cm.sh` 中的对应的参数
   3. 执行 `bash install-aliyun-cm.sh`
   4. 证书申请demo：
      1. 修改 `test-alidns-cert.yaml` 中的域名、证书名、命名空间
      2. 执行 `kubectl -f test-alidns-cert.yaml`
   #### 卸载方式：
   `kubectl delete -f alidns.yaml`

## 三、初始化你的 k3s （node节点）机器
1. 修改`install-node.sh` 文件，`K3S_URL`的地址为你的 master的对应地址。
2. 执行`sudo ./install-node.sh` 文件
> 如果你的网络对github的release下载不友好。
>
> 请使用 `sudo ./install-node_cnproxy.sh`代替。

## 四、 卸载删除你的k3s服务
1. `sudo k3s-killall.sh`
2. `sudo k3s-uninstall.sh` (for master) or `sudo k3s-agent-uninstall.sh` (for node)

## 五、 关于ingress
进入到 ingress-nginx命名空间。
推荐使用hostport方式安装。如果你有2台机器，那么请将`ingress-nginx-controller`的副本数调整为2。
如果你是5台设备，对应副本数调整为5.确保每台机器上都运行一个`ingress-nginx-controller`。
