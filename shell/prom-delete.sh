#!/bin/bash 
kubectl delete namespace monitoring
kubectl delete serviceAccount default -n monitoring
kubectl delete clusterrole prometheus 
kubectl delete clusterrolebinding prometheus



