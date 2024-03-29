# helm-charts

The helm charts for nxest.com.

一台机器一套 Kubernetes 打造个人工作学习平台。

## 概述

1. 为了节省资源，所有资源只考虑单机部署。

## 基础设施

基础设施使用 `multipass + k3s`，以下所有脚本均以此为基础。

[multipass][] 提供虚拟化技术，虚拟出 ubuntu 虚拟机，在虚拟机上安装 `k3s`。

不管你平时开发是使用 Windows、MacOS 或 Linux，都建议比先虚拟出一个虚拟机，在虚拟上执行操作。

### CA 证书

制作 CA 证书。

```bash
 bash shell/openssl.sh k3s.nxest.local 192.168.1.238
```

Ubuntu 增加信任证书。

```bash
 sudo apt-get install -y ca-certificates
 sudo cp ca.crt /usr/local/share/ca-certificates/k3s-local-ca.crt
 sudo update-ca-certificates
```

Ubuntu 增加信任证书后，Edge 一直未生效还是提示证书无效，重新在 Edge 设置里`edge://settings/privacy/manageCertificates`导入了一次解决了。

### 安装 k8s

使用 multipass 启动一个 ubuntu 虚拟机，然后安装 k3s，安装完成后把 k3s 的 kube config 文件拷贝到本机，以便能执行 helm 和 kubectl 命令。

```bash

# 启动一个新虚拟机，名字叫 k3s，使用 ubuntu 22.04 镜像
multipass launch --name k3s --cpus 8 --memory 16G --disk 256G 22.04

# 查看虚拟机信息
multipass info k3s
# 进入虚拟机
multipass shell k3s

# Install or upgrade k3s as master
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn K3S_KUBECONFIG_MODE=600 INSTALL_K3S_CHANNEL=latest sh -

# or install lastest version
# curl -sfL https://get.k3s.io | INSTALL_K3S_MIRROR=cn K3S_KUBECONFIG_MODE=600 INSTALL_K3S_CHANNEL=latest sh -

#  install as k3s agent
# cat /var/lib/rancher/k3s/server/node-token
# curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -

# curl -sfL https://get.k3s.io | K3S_URL=https://172.29.1.43:6443 K3S_TOKEN=K10addd342daa729d34bfc39a09b87d556bf28f6790b3b88ab6da26e180f4db9ffb::server:74e1581a5a6438baacea88a08e385215 sh -

# copy /etc/rancher/k3s/k3s.yaml as your kube config file

```

注意：修改 kube config 中 context name，与 helmfile 中的使用的 `kubeContext` 保持一致。我这里都改为了`k3s`。

## helmfile

使用 [helmfile](https://helmfile.readthedocs.io) 管理 Helm releases。

使用前需要安装 kubectl、helm3、 helm-diff plugin 和 helmfile。

```bash
# install helm-diff plugin
helm plugin install https://github.com/databus23/helm-diff

#  run helmfile, set `--concurrency 1` for github always EOF
helmfile --environment cool --concurrency 1 apply --file helmfiles/xxx.yaml 

```

## DNS 解析

在 K8S 集群内某些服务必须通过 Ingress 访问，比如 OIDC 相关的，所以可以把 ingress 相关解析手动加到 coredns 里。

```console
kubectl -n kube-system edit cm coredns
# 增加 NodeHosts 解析
data:
  NodeHosts: |
    172.x.x.x keycloak.cool.nxest.local
    172.x.x.x minio.cool.nxest.local

```

研发本地增加 hosts。

```bash

  export CLUSTER_IP="10.104.22.116"
  echo "$CLUSTER_IP keycloak.cool.nxest.local" | sudo tee -a /etc/hosts

```

[multipass]: https://multipass.run/
