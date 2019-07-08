# Helm 
Helm es un gestor de paquetes para kubernetes, tiene el principal objetivo de automatizar el despliegue de aplicaciones nativas de nube. 

## Instalación de Helm 
Ejecute el siguiente script. 
```
./helm/get_helm.sh
```
## Intalación de Tiller
Tiller es un complemento de helm, el cual se comunica directamente con la API de Kubernetes para realizar las acciones de crear o eliminar elementos dentro del clúster. 

Es necesario que Tiller cuente con todos los permisos que se requieren para que pueda realizar sus acciones dentro del clúster, para ello se genera un ``serviceaccount`` , ``role-binding`` y ``roles-service``.
```
kubectl apply -f helm/role-binding.yml
kubectl apply -f helm/roles-service.yaml
kubectl apply -f helm/serviceacount.yaml
```

Se inicia helm 
```
helm init --service-account tiller
```

Para verificar que se intaló correctamente el pod de tiller. 
```
kubectl get pods -n kube-system

NAME                                    READY     STATUS    RESTARTS   AGE
. . .
tiller-deploy-5c688d5f9b-lccsk          1/1       Running   0          40s

```

## Comandos básicos de helm 

Listar los despliegues de helm. 
```
helm list
```

Instalar un paquete. 
```
helm install  <nombre_del_paquete_descargar>
```
Se pueden utilizar las siguentes banderas para tener una mayor personalización del despliegue, 

``--name``: nombre del despliegue.

``--namespace``: nombre del namespace.

``--values``: archivo de configuración ``values.yaml``.

``--set``: variables de configuración, dependen de cada aplicativo. 

Eliminar un despliegue. 
```
helm del --purge <nombre_despliegue>
```


