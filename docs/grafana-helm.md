# Grafana con Helm
Se instalará grafana v6.2.4

## Prerequisitos
- Cluster de Kubernetes
- Tener instalado [Helm](https://github.com/VerMunoz/OpenCloud/blob/master/docs/helm.md)

## Instalación 

Dirigirse al directorio.
```
cd helm/grafana
```
Instalar grafana
```
./helm/grafana/runit-graf.sh 
```
En el archivo ``values-prom.yaml`` está una configuración personalizada para la instalación, si se desea saber más vea el git de [helm con grafana](https://github.com/helm/charts/tree/master/stable/grafana)

Verificar si el despliegue se realizó correctamente 
```
kubectl get pods -n monitoring

NAME                                             READY   STATUS    AGE
. . .   
grafana-54f8cc5dd-t6hsv                          1/1     Running   1m
```