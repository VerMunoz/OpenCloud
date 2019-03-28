# Ingress Controller k8s 

## Instalación de Ingress con Nginx 

La instalación contiene la creación de los siguientes elementos.
- Namespace
- Service Account 
- Secret (certificado TLS)
- ConfigMap (configuración de nginx-ingress)
- Autorización RBAC
- Deploy 
- Service (tipo NodePort)

Instalación de ingress con Nginx
```
kubectl create -f install/ingress-nginx.yaml
```




