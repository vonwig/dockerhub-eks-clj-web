###########################
# increment version.txt
# package into an OCI image
# deploy to ECR
# update k8s cluster
###########################
BASEDIR=$(dirname "$0")
export DOCKER_CONFIG="$BASEDIR/.docker"

# increment version
bb -e '(spit "version.txt" (format "v%s" (inc (Integer. (str (second (re-find #"v(\d+)" (str/trim (slurp "version.txt")))))))))'
# build OCI image to docker
clj -T:jib build :config "$(./update-jib-config.clj)"
# TODO get rid of this and use jib to push directly to DockerHub
# requires successful login  
#   aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin 111664719423.dkr.ecr.us-west-1.amazonaws.com
docker push slimslenderslacks/dockerhub-eks-clj-web:$(cat version.txt)

# Update K8 cluster
pushd resources/k8s/deployment
kustomize edit set image "slimslenderslacks/dockerhub-eks-clj-web:$(cat ../../../version.txt)"
kustomize build . | kubectl apply -f -
popd

