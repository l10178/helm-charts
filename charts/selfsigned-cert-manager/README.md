# selfsigned-cert-manager

快速启动一个自签名的 cert-manager。

## Install

```bash
helm install my-release selfsigned-cert-manager --set-file secret.key=path/to/ca.key --set-file secret.crt=path/to/ca.crt
```
