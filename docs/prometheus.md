# Prometheus y Grafana en k8s
**Nota: Versión obsoleta, le recomendamos la instalación con Helm**

Instalación de Prometheus v.2.1.0 y Grafana sobre un clúster de kubernetes. El clúster de kubernetes está compuesto por un master y tres nodos worker, basados en VMs montadas sobre OpenStack.
### Prerrequisitos 

- Un clúster de Kubernetes.
- Acceso vía ssh al nodo master.


## Prometheus y Grafana 

### Instalación

Este repositorio contiene la instalación automatizada de Prometheus v.2.1.0 y Grafana. 

 - ConfigMap: las métricas que se extraen de Kubernetes (nodes).
 - Roles: autorización RBCA de kubernetes.
 - Deployment: despliegue de la aplicación 
 - Service: expone el servicio tipo NodePort en el para Prometheus por el puerto 30000 y para grafana por el puerto 30104.

Editar el archivo ``install/prometheus-all.yaml``

En la sección de ConfigMap cambiar la dirección IP en ``replacement`` por la ``IP del master o dominio del cluster``. 

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: monitoring
  labels:
    kubernetes.io/cluster-service: "true"
    kubernetes.io/hostname: "true"
data:
  prometheus.yml: |
    scrape_configs:
    - job_name: kubernetes-nodes-kubelet
      scrape_interval: 10s
      scrape_timeout: 10s
      kubernetes_sd_configs:
      - role: node
      relabel_configs:
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)
      - target_label: __address__
        replacement: 192.10.24.4:443
```


Para la instalación de Prometheus y Grafana, ejecute el siguiente comando.
```
kubectl create -f install/prometheus-all.yaml 
```

### Verifiación de la instalación 

Verifiación de pods. 
```
# kubectl get pods -n monitoring 
NAME                                    READY     STATUS    RESTARTS   AGE
grafana-69c77dd67d-kcjq8                1/1       Running   0          3m
prometheus-deployment-5d4fd5b78-qwclg   1/1       Running   0          3m
```

Verificación de servicios. 
```
# kubectl get svc -n monitoring 
NAME                 TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
grafana-service      NodePort   10.99.103.195   <none>        3000:30105/TCP   3m
prometheus-service   NodePort   10.103.104.72   <none>        8080:30001/TCP   3m
```

Acceder a la interfaz gráfica de Prometheus `` http://<ip_del_master:30001> ``

Acceder a la interfaz gráfica de Grafana `` http://<ip_del_master:30105/login> ``


## Clean up

Remover la instalación ejecutar el script. 

```  
./shell/prom-delete.sh 
```


