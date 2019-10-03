#!/bin/bash

#Delete pvc
kubectl delete pvc -n harbor pvc-hrb-registry
kubectl delete pvc -n harbor pvc-hrb-chartmuseum
kubectl delete pvc -n harbor pvc-hrb-jobservice
kubectl delete pvc -n harbor pvc-hrb-database
kubectl delete pvc -n harbor pvc-hrb-redis


# Delete pv
kubectl delete pv pv-hrb-registry
kubectl delete pv pv-hrb-chartmuseum
kubectl delete pv pv-hrb-jobservice
kubectl delete pv pv-hrb-database
kubectl delete pv pv-hrb-redis  

#Create pv & pvc
#kubectl apply -f pv-harbor.yaml 
