# helm-charts

The helm charts for nxest.com.

一台机器一套 Kubernetes 打造个人工作学习平台。

## 概述

1. 为了节省资源，所有资源只考虑单机部署。

## 基础设施

基础设施使用 `multipass + k3s`，以下所有脚本均以此为基础。

[multipass][] 提供虚拟化技术，虚拟出 ubuntu 虚拟机，在虚拟机上安装 `k3s`。

不管你平时开发是使用 Windows、MacOS 或 Linux，都建议比先虚拟出一个虚拟机，在虚拟上执行操作。

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

[multipass]: https://multipass.run/
