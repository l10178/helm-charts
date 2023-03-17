# helm-charts

The helm charts for nxest.com.

一台机器一套 Kubernetes 打造个人工作学习平台。

## 概述

1. 为了节省资源，所有资源只考虑单机部署。

## 基础设施

基础设施使用 `multipass + k3s`，以下所有脚本均以此为基础。

[multipass][] 提供虚拟化技术，虚拟出 ubuntu 虚拟机，在虚拟机上安装 `k3s`。

不管你平时开发是使用 Windows、MacOS 或 Linux，都建议比先虚拟出一个虚拟机，在虚拟上执行操作。

### 安装k8s

使用multipass启动一个ubuntu虚拟机，然后安装k3s，安装完成后把k3s的 kube config文件拷贝到本机，以便能执行helm和kubectl命令。

```bash
# launch ubuntu 22.04
multipass launch --name k3s --cpus 4 --memory 16G --disk 128G 22.04

# Install or upgrade k3s
curl -sfL https://get.k3s.io | INSTALL_K3S_MIRROR=cn K3S_KUBECONFIG_MODE=644 INSTALL_K3S_CHANNEL=latest sh -

# copy /etc/rancher/k3s/k3s.yaml as your kube config file

```

注意：修改kube config中context name，与helmfile中的使用的 `kubeContext` 保持一致。我这里都改为了`k3s`。

## helmfile

使用 [helmfile](https://helmfile.readthedocs.io) 管理 Helm releases。

使用前需要安装 kubectl、helm3、 helm-diff plugin 和 helmfile。

```bash
# install helm-diff plugin
helm plugin install https://github.com/databus23/helm-diff

#  run helmfile
helmfile apply --file helmfiles/xxx.yaml

```

## GitHub Actions


https://www.cnblogs.com/dandelion/p/14083023.html




[multipass]: https://multipass.run/


