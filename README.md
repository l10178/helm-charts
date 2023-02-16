# helm-charts

The helm charts for nxest.com.

一台机器一套 Kubernetes 打造个人工作学习平台。

## 准备工作

## helmfile

使用 [helmfile](https://helmfile.readthedocs.io) 管理 Helm releases。

使用前需要安装 kubectl、helm3、 helm-diff plugin 和 helmfile。

```bash
# install helm-diff plugin
helm plugin install https://github.com/databus23/helm-diff

#  run helmfile
helmfile apply --file helmfiles/xxx.yaml

```
