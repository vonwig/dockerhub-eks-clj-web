## install kustomize

```
brew install kustomize
```

## add `.creds.edn`

```edn
{:username "slimslenderslacks"
 :password ""}
```

## create .dockerconfigjson kube secret

```
mkdir .docker
export DOCKER_CONFIG=$(pwd)/.docker
docker login -u slimslenderslacks
# remove osxkeychain if it's there in config.json
docker login -u slimslenderslacks
cp .docker/config.json ./resources/k8s/deployment/.dockerconfigjson
```

