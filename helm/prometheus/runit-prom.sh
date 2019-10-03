#!/bin/bash

##Crear storageclass (local)
kubectl apply -f helm/prometheus/storageclass.yaml

##Eliminar pvc existentes
kubectl delete pvc prometheus-alertmanager  prometheus-server -n monitoring

##Eliminar pv existentes
kubectl delete pv pv-prometheus-server-1 pv-prometheus-server

#Crear PV y PVC
kubectl apply -f helm/prometheus/pv.yaml

#Instalar prometheus
helm install stable/prometheus --namespace monitoring --name prometheus --values=helm/prometheus/values-prom.yaml
