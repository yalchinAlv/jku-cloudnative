#!/bin/bash
#create a k3d cluster with definition file
k3d cluster create --config ./k3d/k3d-local-dev-cluster.yaml
#create namespace for the argocd installation
kubectl create namespace argocd
# install argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# the argo-cd intial admin password can be read with the following command:
# kubectl get secret argocd-initial-admin-secret -n argocd -o yaml
# OR
# replace it with your own fixed admin password
# https://www.browserling.com/tools/bcrypt
kubectl -n argocd patch secret argocd-secret -p '{"stringData": {"admin.password": "$2a$10$hxs3iL9r9VzrTZNKbz1X.eh3P9KBqgonN6agkdE2Ndd7goMJxIqU2","admin.passwordMtime": "'$(date +%FT%T%Z)'"}}'

# start the GitOps with creation of argo-cd app
kubectl -n argocd apply -f ./argo-cd/argo-cd-app.yaml