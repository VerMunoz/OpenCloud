#!/bin/bash

##Eliminar pvc existentes
kubectl delete pvc pvc-grafana pvc-grafana-extra -n monitoring

##Eliminar pv existentes
kubectl delete pv pv-grafana pv-grafana-extra

#Crear PV y PVC
kubectl apply -f pv-pvc.yaml

#Instalar grafana
helm install --name grafana stable/grafana --namespace monitoring --name grafana --values=values-graf.yaml
## Sin PVC 
#helm install --name grafana stable/grafana --namespace monitoring --name grafana --set=ingress.enabled=True,ingress.hosts={grafana.opencloud.amx.com},service.type=NodePort
