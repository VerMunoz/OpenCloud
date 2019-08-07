## GitLab 

Se instalará Gitlab Omnibus Enterprise en un contenedor Docker y Gitlab Runners en un pod de Kubernetes. 

## Prerequisitos
Gitlab Omnibus Enterprise:

- Una máquina virtual, dependiendo de los usarios varía las [especificaciones](https://docs.gitlab.com/ee/install/requirements.html)
- Docker instalado. 

Gitlab Runneres Kubernetes:

- Cluster de Kubernetes.
- Tener instalado [Helm](https://github.com/VerMunoz/OpenCloud/blob/master/docs/helm.md) en el cluster de Kubernetes. 

## Instalación Gitlab Omnibus Enterprise

Para la instalación de Gitlab Omnibus en docker, es necesario tener en cuenta los puntos de montaje que estarán destinados a Gitlab, en este caso se creó un punto de montaje en la ruta `` /mnt/vero/gitlab/ ``. 

Descargar la imagen de Gitlab Omnibus EE
```
docker pull gitlab/gitlab-ee
```
Correr el contenedor

```
docker run --detach   --hostname <hostname>   --publish 443:443 --publish 80:80 --publish 1022:22   --name gitlab   --restart always   --volume /mnt/vero/gitlab/config:/etc/gitlab:Z   --volume /mnt/vero/gitlab/logs:/var/log/gitlab:Z   --volume /mnt/vero/gitlab/data:/var/opt/gitlab:Z   gitlab/gitlab-ee:latest
```

Verificar que está instalado Gitlab
```
docker ps

CONTAINER ID        IMAGE                     COMMAND             CREATED             STATUS               . . .  e6c827f6f634        gitlab/gitlab-ee:latest   "/assets/wrapper"   7 weeks ago         Up 7 weeks (healthy) . . . 
```

## Instalación Gitlab Runners en Kubernetes

Agregar el repositorio de Gitlab
```
helm repo add gitlab https://charts.gitlab.io
```
Instalar gitlab Runner 
Modificar el archivo `` values.yaml ``.

Ingresar en el parámetro  ``gitlabUrl`` que es el hostname con el que se levantó GitLab.
Ingresar el token en el parámetro ``runnerRegistrationToken`` que está en la UI de GitLab en la sección ``Admin Area -> Runners -> Copy Token `` 
```
gitlabUrl: http://<hostame.com>
runnerRegistrationToken: MZURVL8bhhsoGGVGhY-z
```





En dado caso que se presente un issue de que el runner no reconoce el nombre de dominio del servicio, agregar: 
```
runners: []
  cloneUrl: http://<ip-servidor-gitlab>
```


```
helm install --namespace gitlab --name gitlab-runner -f values.yaml gitlab/gitlab-runner
```