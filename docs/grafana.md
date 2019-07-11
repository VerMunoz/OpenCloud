# Grafana Dashboards

Para acceder a Grafana, el usuario y contraseña por default es: 

`` Usuario: admin ``

`` Contraseña: admin ``

Si se instaló con [Helm](https://github.com/VerMunoz/OpenCloud/blob/master/docs/grafana-helm.md), la contraseña la puede verificar con el siguiente comando. 
```
kubectl get secret -n monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

****************
```


Para configurar el dashboard de kubernetes, se realizan los siguientes pasos: 

1. Crear un Data Source. 

```
Name: Prometheus-k8s
Type: Prometheus 

Url: http://<ip-master>:30001 
Access: direct 

```

La url es la dirección dónde Grafana recolecta la información, por lo que pertenece a la dirección  donde está expuesto Prometheus. 

![AddSource](https://raw.githubusercontent.com/VerMunoz/OpenCloud/master/images/grafana-addsource.png)


2. Crear un Dashboard. 

Importar dashboard. 

Subir json file `` dashboards/k8s-monitoring.json `` 

```
Options: 
Name: Kubernetes cluster monitoring (via Prometheus)
Prometheus: Pormetheus-k8s

```
![AddSource](https://raw.githubusercontent.com/VerMunoz/OpenCloud/master/images/grafana-createdashboard.png)



Una vez realizados estos pasos, el dashboard está listo, si no muestra datos o aparece N/A en el dashboard, verificar que la url del data source pertenezca a la url de Prometheus y que el servicio esté funcionando. 

![AddSource](https://raw.githubusercontent.com/VerMunoz/OpenCloud/master/images/grafana-dashboard.png)

## Dashboards disponibles: 

Kubernetes Cluster (Prometheus)
``dashboards/k8s-general.json`` 

Kubernetes cluster monitoring (via Promethues)
``k8s-monitoring.json``

Kubernetes: POD Overview
``k8s-pod.json  ``

VM Platform Stats
``k8s-machine.json ``



