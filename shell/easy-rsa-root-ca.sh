#!/bin/bash

MASTER_IP=192.168.64.2
MASTER_CLUSTER_IP=192.168.64.2
INGRESS_DOMAIN=*.cool.nxest.com

# curl -LO https://storage.googleapis.com/kubernetes-release/easy-rsa/easy-rsa.tar.gz
# tar xzf easy-rsa.tar.gz
# cd easy-rsa-master/easyrsa3

./easyrsa init-pki

./easyrsa --batch "--req-cn=${INGRESS_DOMAIN}@`date +%s`" build-ca nopass

echo yes | ./easyrsa --subject-alt-name="IP:${MASTER_IP},"\
"IP:${MASTER_CLUSTER_IP},"\
"DNS:${INGRESS_DOMAIN},"\
"DNS:kubernetes,"\
"DNS:kubernetes.default,"\
"DNS:kubernetes.default.svc,"\
"DNS:kubernetes.default.svc.cluster,"\
"DNS:kubernetes.default.svc.cluster.local" \
--days=36500 \
build-server-full server nopass