# Grafana con Helm
Se instalará grafana v6.2.4

## Prerequisitos
- Cluster de Kubernetes
- Tener instalado [Helm](https://github.com/VerMunoz/OpenCloud/blob/master/docs/helm.md)

## Instalación 

Instalar grafana
```
./helm/grafana/runit-graf.sh 
```
En el archivo ``values-prom.yaml`` está una configuración personalizada para la instalación, si se desea saber más vea el git de [helm con grafana](https://github.com/helm/charts/tree/master/stable/grafana)
O instalar directamente mediante el comando.

Verificar si el despliegue se realizó correctamente 
```
kubectl get pods -n monitoring

NAME                                             READY   STATUS    AGE
. . .   
grafana-54f8cc5dd-t6hsv                          1/1     Running   1m
```

## Automatización de Datasource y Dashboards. 

### Añadir Datasource 
Para agregar automáticamente el campo de datasource, es necesario configurar el archivo `` configmaps/grafana-datasource.yaml ``

``` 
vim configmaps/grafana-datasource.yaml 
```
Modificar el campo de  ``url`` y añadir la url con la que se accede a Prometheus ``Prometheus``.

Crear el ``configmap`` en el clúster de Kubernetes
```
kubectl apply -f configmaps/grafana-datasource.yaml
```
Verificar que fue creado el ``configmap``
```
kubectl get configmap -n monitoring
```

En el archivo ``helm/grafana/values-prom.yaml`` modificar o agregar las siguientes lineas. 
```
sidecar:
  image: kiwigrid/k8s-sidecar:0.0.16
  imagePullPolicy: IfNotPresent
  datasources:
    enabled: true
    label: grafana_datasource
```
Reiniciar el despliegue de Grafana 
1. Eliminar el despliegue de grafana. 
```
helm delete --purge grafana
```
2. Instalar Grafana 
```
./helm/grafana/runit-graf.sh 
```


### Añadir Dashboards 
Para añadir dashboards a grafana es necesario crear un ``configmap``.

Crear un archivo llamado ``grafana-dashboards.yaml``. 
```
vim grafana-dashboards.yaml
```
En ese archivo se tendrá en formato ``.json`` los dashboards que se requiera agregar. 
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-grafana-dashboard
  namespace: monitoring
  labels:
    grafana_dashboard: '1'
data:
  prometheus-dashboard.json: |-
    {
        <copy_json_file>
    }
  prometheus-dashboard-2.json: |-
    {
        <copy_json_file>
    }
  . 
  . 
  . 
  prometheus-datasource.json: |
    {
      "name": "Prometheus",
      "type": "Prometheus",
      "url": "<url_prometheus>",
      "access": "server",
      "basicAuth": false
    }    
```
En el archivo ``helm/grafana/values-prom.yaml`` modificar o agregar las siguientes lineas. 
```
sidecar:
  image: kiwigrid/k8s-sidecar:0.0.16
  imagePullPolicy: IfNotPresent
  dashboards:
    enabled: true
    label: grafana_dashboard
```
Reiniciar el despliegue de Grafana 
1. Eliminar el despliegue de grafana. 
```
helm delete --purge grafana
```
2. Instalar Grafana 
```
./helm/grafana/runit-graf.sh 
```


