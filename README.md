# OpenCloud

El objetivo de este repositorio es la integración de herramientas open source, orientadas a la inovación de tecnologías nativas de la nube.

Está compuesto por una guía para la instalación de un clúster privado basado en kubernetes y la instalación de aplicaciones nativas de nube, para tener una administración y visibilidad completa de nuestro entorno, basados en el landscape de la CNCF. 

### Conteinerization 
- [Docker]()
### Orchestration 
- Kubernetes 
    - Instalación   
        - [Paso a paso](https://github.com/VerMunoz/OpenCloud/blob/master/docs/k8s-local.md)
        - [Automatizado (Kubespray)]()
        - [En GCP](https://github.com/VerMunoz/OpenCloud/blob/master/docs/gcp.md)
    - [Dashboard](https://github.com/VerMunoz/OpenCloud/blob/master/docs/dashboard-k8s.md)
    - [Ingress](https://github.com/VerMunoz/OpenCloud/blob/master/docs/ingress.md)
    - [High availability]()
    - [Despliegue de una aplicación](https://github.com/VerMunoz/OpenCloud/blob/master/docs/k8s-app-demo.md)
### Automatization 
- [Helm]()
- [Kubespray]()
- [Tareas programadas]()
### Observability
- Monitoring 
    - [Prometheus y Grafana](https://github.com/VerMunoz/OpenCloud/blob/master/docs/prometheus.md)
    - [Prometheus (helm)]()
    - [Grafana (helm)]()
    - [Dashboards](https://github.com/VerMunoz/OpenCloud/blob/master/docs/grafana.md)
### Storage s3
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

