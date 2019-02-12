# Despliegue de una aplicación en Kubernetes

Para iniciar el aprendizaje de kubernetes, se levanta una aplicación sencilla montada sobre una imagen que contiene un Hello World, el nombre del pod y la dirección IP. 

Se realiza un deploy, el cual tendrá la información del deploy, se especificará sobre el tipo, nombre, el número de réplicas, la imagen que previamente se debe de subir a docker hub, el puerto, entre otros parámetros. 
```
kubectl create -f demo/hello-world-deploy.yaml
```

Para exponer esta aplicación, se crea un servicio, en donde se especifica el nombre, tipo, puerto que se desea exponer la aplicación , protocolo, entre otros parámetros. 
```
kubectl create -f demo/hello-world-service.yaml
```

Para verificar el servicio ejecutado.
```
kubectl get svc 
NAME                TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
hello-world         NodePort    10.98.69.221   <none>        80:32513/TCP   2m
```

Para consultar la aplicación en el navegador `` http://<ip_del_master:32513> ``





