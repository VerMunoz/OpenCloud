#!/bin/bash

##Crear storageclass (local)
kubectl apply -f storageclass.yaml

##Eliminar pvc existentes
kubectl delete pvc prometheus-alertmanager  prometheus-server -n monitoring

##Eliminar pv existentes
kubectl delete pv pv-prometheus-server-1 pv-prometheus-server

#Crear PV y PVC
kubectl apply -f pv.yaml

#Instalar prometheus
helm install stable/prometheus --namespace monitoring --name prometheus --values=values-prom.yaml
