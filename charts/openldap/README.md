# OpenLDAP Helm Chart

Instantiate an instance of OpenLDAP server.

## Prerequisites Details

- Kubernetes 1.24+
- PV support on the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add nxest https://www.nxest.com/helm-charts
$ helm install --name my-release nxest/openldap
```

## Configuration

We use the docker images provided by <https://github.com/osixia/docker-openldap>. The docker image is highly configurable and well documented. Please consult to documentation for the docker image for more information.
