# Dashboard Kubernetes

### Dashboard para Kubernetes v.1.11.1

Para  instalar los componentes del dashboard, se ejecuta el siguiente comando.

```
kubectl apply -f deploys/kubernetes-dashboard.yaml
```

El dashboard se instala con privilegios mínimos de rol de usuario, para acceder completamente con permiso administrativo completo. se crean roles permisos de autentificación RBAC.

```
kubectl apply -f roles/dashboard-admin.yaml
```

Para acceder al dashboard, se debe de crear un canal seguro para el clúster mediante un proxy, este comando se ejecutará en segundo plano.  
```
 nohup kubectl proxy --address="<ip-master>" -p 443 --accept-hosts='^*$' &
```
En la bandera --address ses especifica la dirección IP del servidor master de Kubernetes, y el puerto que se abrirá para el dashboard será el 443. 

Para verificar el estado del proceso se puede realizar con el siguiente comando. 
```
ps -a 
PID   TTY           TIME  CMD 
6124  pts/1     00:00:00  kubectl 
```

Abrir en el navegador web con la siguiente url.
``` 
http://<ip-master>:443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/overview?namespace=default
```
