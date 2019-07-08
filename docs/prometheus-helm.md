# Instalación de Prometheus con Helm 
Los elementos que se instalan de Prometheus con Helm son los siguientes: 

- Alertmanager
- Node exporter
- Pushgateway
- Prometheus server 

## Prerequisitos
- Cluster de Kubernetes
- Tener instalado [Helm](https://github.com/VerMunoz/OpenCloud/blob/master/docs/helm.md)

## Instalación 

Dirigirse al directorio.
```
cd helm/prometheus
```
Instalar prometheus
```
helm install --name prometheus stable/prometheus --namespace monitoring  --values=values-prom.yaml
```
En el archivo ``values-prom.yaml`` está una configuración personalizada para la instalación, si se desea saber más vea el git de [helm con prometheus](https://github.com/helm/charts/tree/master/stable/prometheus)

Verificar si el despliegue se realizó correctamente 
```
kubectl get pods -n monitoring

NAME                                             READY   STATUS    AGE
prometheus-alertmanager-784b7f9fc7-8k267         2/2     Running   1m
prometheus-kube-state-metrics-5b549c445f-cwqz2   1/1     Running   1m
prometheus-node-exporter-cq6cb                   1/1     Running   1m       
prometheus-node-exporter-vrd8h                   1/1     Running   1m         
prometheus-pushgateway-5b6b77964c-z6wnc          1/1     Running   1m       
prometheus-server-594b6686c4-w42v6               2/2     Running   1m       
```

