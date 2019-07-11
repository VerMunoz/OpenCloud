# OpenCloud

El objetivo de este repositorio es la integración de herramientas open source, orientadas a la inovación de tecnologías nativas de la nube.

Está compuesto por una guía para la instalación de un clúster privado basado en kubernetes y la instalación de aplicaciones nativas de nube, para tener una administración y visibilidad completa de nuestro entorno, basados en el landscape de la CNCF. 

### Conteinerization 
- Docker
### Orchestration 
- Kubernetes 
    - Instalación   
        - [Paso a paso](https://github.com/VerMunoz/OpenCloud/blob/master/docs/k8s-local.md)
        - [Automatizado (Kubespray)](https://github.com/VerMunoz/OpenCloud/blob/master/docs/Kubespray.md)
    - [Dashboard](https://github.com/VerMunoz/OpenCloud/blob/master/docs/dashboard-k8s.md)
    - [Ingress](https://github.com/VerMunoz/OpenCloud/blob/master/docs/ingress.md)
    - [High availability](https://github.com/VerMunoz/OpenCloud/blob/master/docs/ha.md)
    - [Despliegue de una aplicación](https://github.com/VerMunoz/OpenCloud/blob/master/docs/k8s-app-demo.md)
### Automatization 
- [Helm](https://github.com/VerMunoz/OpenCloud/blob/master/docs/helm.md)
- [Kubespray](https://github.com/VerMunoz/OpenCloud/blob/master/docs/Kubespray.md)
- [Tareas programadas](https://github.com/VerMunoz/OpenCloud/blob/master/docs/tareas_programadas.md)
### Observability
- Metrics
    - [Prometheus y Grafana](https://github.com/VerMunoz/OpenCloud/blob/master/docs/prometheus.md)
    - [Prometheus (helm)](https://github.com/VerMunoz/OpenCloud/blob/master/docs/prometheus-helm.md)
    - [Grafana (helm)](https://github.com/VerMunoz/OpenCloud/blob/master/docs/grafana-helm.md)
    - [Dashboards](https://github.com/VerMunoz/OpenCloud/blob/master/docs/grafana.md)
### Storage 
- [Minio](https://github.com/VerMunoz/OpenCloud/blob/master/docs/minio.md)
### Container Registry
- [Harbor](https://github.com/VerMunoz/OpenCloud/blob/master/docs/harbor.md)
- GCR
### CI/CD
- Spinnaker
    - [Instalación](https://github.com/VerMunoz/OpenCloud/blob/master/docs/spinnaker.md)
    - [Canary](https://github.com/VerMunoz/OpenCloud/blob/master/docs/kayenta-spinnaker.md)
    - Multicloud
        - [GCP](https://github.com/VerMunoz/OpenCloud/blob/master/docs/gcp.md)
    - [Demo](https://github.com/VerMunoz/OpenCloud/blob/master/docs/demo-spinnaker.md)
- [Gitlab]()
### Service Mesh 
- [Istio](https://github.com/VerMunoz/OpenCloud/blob/master/docs/istio.md)

### Versiones

| Aplicacion    | Version 1              | Version 2   |
| :------------ | :--------------------- | :---------- |
| Docker        | v.13.1                 | v.18.06.1   | 
| Kubernetes    | v.11.3                 | v.1.13.2    |
| Dashboard k8s | v.1.10.0               |             |
| Helm          | v.2.14.1               |             |
| Grafana       | v.4.4.3                | v.6.2.4     |
| Prometheus    | v.2.1.0                | v.2.10.0    |
| Harbor        | v.1.7.5                |             |
| Istio         | v.1.0.5                |             |
| Halyard       | v.1.19.2               |             |
| Spinnaker     | v.1.10.4               |             |
| Minio         | 2018-10-18T00-28-58Z   |             |




