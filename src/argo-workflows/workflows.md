# Argo Workflows

Argo Workflows。

## Prepare

create gitlab secret

```bash

kubectl -n argo create secret generic gitlab-creds --from-file=ssh-private-key=~/.ssh/id_rsa


DOCKER_USERNAME=xxx
DOCKER_PASSWORD=xxx
AUTH=$(echo -n "${DOCKER_USERNAME}:${DOCKER_PASSWORD}" | base64)
cat << EOF > config.json
{
    "auths": {
        "https://domain/v1/": {
            "auth": "${AUTH}"
        }
    }
}
EOF

kubectl -n argo create secret generic docker-config --from-file=config.json=config.json

```
