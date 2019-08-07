#!/bin/bash 

## Instalar Helm
./helm/get_helm.sh

## Roles and service account
kubectl apply -f helm/role-binding.yml
kubectl apply -f helm/roles-service.yaml
kubectl apply -f helm/serviceacount.yaml Helm

## Iniciar Helm
helm init --service-account tiller

## Instalar ingress Controller
kubectl apply -f install/ingress-nginx.yaml

## Instalar Kubernetes Dashboard 
kubectl apply -f deploys/kubernetes-dashboard.yaml
kubectl apply -f roles/dashboard-admin.yaml

## Exponer Dashboard Kubernetes (address master) 
nohup kubectl proxy --address="192.168.1.186" -p 443 --accept-hosts='^*$' &

## Instalar Gitlab Runners
helm repo add gitlab https://charts.gitlab.io
helm install --namespace gitlab --name gitlab-runner -f values.yaml gitlab/gitlab-runner

## Instalar prometheus with Helm
./helm/prometheus/runit-prom.sh 

## Instalar grafana with Helm 
#./helm/grafana/runit-graf.sh 
helm install --name grafana stable/grafana --namespace monitoring --name grafana
