# Spinnaker 

Instalación de Spinnaker sobre un clúster local de kubernetes. El clúster de kubernetes está compuesto por un master y tres nodos worker, basados en VMs montadas sobre OpenStack. Adicionalmente, se requieren dos VMs, en una montará halyard, que es una herramienta para la instalación, configuración y actualización de Spinnaker. Y otra VM, en donde se montará Minio, que es el servicio de almacenamiento de Spinnaker. 


## Arquitectura
![Arquitectura](https://raw.githubusercontent.com/VerMunoz/OpenCloud/master/images/Spinnaker-arquitectura.png)

## Prerrequisitos 
- Halyard: 
      Una máquina virtual: 4 CPU, 4 GB de RAM y 50 GB , con sistema operativo Centos 7.4.
- [Cluster de kubernetes](https://github.com/VerMunoz/OpenCloud/blob/master/docs/k8s-local.md "Title"):
    - Para el nodo master: 
      Una máquina virtual: 4 CPU, 4 GB de RAM y 50 GB , con sistema operativo Centos 7.4.
    - Para nodos worker: 
      Tres máquinas virtuales: 4 CPU, 4 GB de RAM y 50 GB Cloud Hard Disk, con sistema operativo Centos 7.4.
- [Minio](https://github.com/VerMunoz/OpenCloud/blob/master/docs/minio.md "Title").
  
   Es necesario verificar la ruta del archivo de configuración de kubernetes, por default se crea en ~/.kube/config o en /etc/kubernetes/admin.conf

Todas las VMs deben de tener salida a internet y comunicación con las VMs del  clúster de kubernetes. 

## Instalación de Halyard 

Se instalará Halyard v.1.14.0 en una máquina virtual independiente al cluster de kubernetes, la instalación se realizará de manera local. 

Es necesario que se tenga un usuario diferente de root, para iniciar la instalación. 
```
sudo useradd -d /home/halyard -m halyard
sudo passwd halyard
```

Se ejucta el siguiente comando para comenzar la instalación.
```
sudo bash InstallHalyard.sh 
```
A continuación el programa le pedirá un usuario diferente de root y configuraciones de la instalación. 

Verificar que la herramienta ya está instalada correctamente.
```
hal -v
```
Ejecutar el siguiente comando para habilitar la finalización de hal. 
```
. ~/.bashrc  
```


## Configuración de Halyard 

Se configurará halyard para que se pueda instalar correctamente todos los componentes de Spinnaker. Los elementos a configurar son los siguientes. 
- [Docker Registry.](#id1)
- [Cuenta de Kuberentes.](#id2)
- [Configuración de almacenamiento Minio.](#id3)

<div id='id1' />

### Docker Registry 
Se requiere un docker registry para que almacenar las imágenes que tendrá acceso Spinnaker, se pueden configurar  diferentes tipos  de repositorios con el GRC, Docker Hub, Quay, ECR (Amazon). En este repositorio se configurarán: 
- [Docker Hub](#id1-1)
- [GCR](#id1-2)

<div id='id1-1' />

#### Docker Hub

En la página oficial de [Docker Hub](https://hub.docker.com/ "Title"), es necesario que crear una cuenta y recordar el username y password. 

En la VM donde se instaló Halyard, habilitar el proveedor docker-registry. 
```
hal config provider docker-registry enable
```
Agregar una cuenta a docker-registry.
```
hal config provider docker-registry account add my-docker-registry \
     --address https://index.docker.io/v2 \
     --repositories library/nginx \
     --username Username-dockerhub \
     --password 
```
Verificar que la cuenta fue agregada exitosamente. 
```
hal config provider docker-registry account list
```

<div id='id1-2' />

#### GCR 
Para poder utilizar el GCR, se debe de configurar los permisos y prerrequisitos de [GCP](https://github.com/VerMunoz/OpenCloud/blob/master/docs/gcp.md "Title")

Configurar GCR en el servidor halyard. 

Habilitar el proveedor docker-registry en hal. 
```
hal config provider docker-registry enable
```
Agregar una cuenta a docker-registry 
```
hal config provider docker-registry account add my-docker-registry-gcr\
 --address https://gcr.io \
 --username _json_key \
 --password-file $PASSWORD_FILE
```
Verificar que las dos cuentas de docker-registry han sido creadas. 
```
hal config provider docker-registry account list
```
<div id='id2' />

### Cuenta de Kubernetes 

En halyard hay dos tipos de configuración para una cuenta de Kuberentes: 
- [Kubernetes v1 (legacy)](#id2-1)
- [Kubernetes v2 (basado en manifiesto)](#id2-2)

<div id='id2-1' />

#### Kubernetes v1 (legacy)

La configuración kubernetes legacy, consiste en darle acceso a todos los elementos de kubernetes a Spinnaker. Es necesario como prerrequisito, tener un [docker registry](#id1), para depositar en el las imagenes que se desplegarán en esta cuenta.

Habilitar el proveedor kubernetes en hal. 
```
hal config provider kubernetes enable
```
Crear una cuenta de kubernetes vinculando con los docker registries anteriormente creados.
```
hal config provider kubernetes account add my-k8s-account \
    --docker-registries my-docker-registry my-docker-registry-gcr
```
Es necesario verificar la ruta del archivo de configuración de kubernetes, por default se crea en ~/.kube/config. Si el archivo está en otra ruta, agregar la bandera `` --kubeconfig-file /ruta-de-kubeconfig/ ``

<div id='id2-2' />

#### Kubernetes v2 (basado en manifiesto)
Kubernetes V2 basada en manifiestos, es la versión que soporta Spinnaker, para tener toda la configuración como código o manifiestos (json). 
Habilitar el proveedor kubernetes en hal. 
```
hal config provider kubernetes enable
```
Crear una cuenta de kubernets 
```
hal config provider kubernetes account add k8s-manifest \
    --provider-version v2 \
    --context $(kubectl config current-context)
```
Habilitar los artifactos.
```
hal config features edit --artifacts true
```
Es necesario verificar la ruta del archivo de configuración de kubernetes, por default se crea en ~/.kube/config. Si el archivo está en otra ruta, agregar la bandera `` --kubeconfig-file /ruta-de-kubeconfig/ ``

<div id='id3' />

### Configuración de almacenamiento Minio 

Minio no admite la versión de objetos, por eso se necesita deshabilitarla en Spinnaker. En ~/.hal/$DEPLOYMENT/profiles/front50-local.yml agregar la siguiente línea 
```
spinnaker.s3.versioning: false
```
Configurar y conectar con el servidor de minio, se tiene que tomar en cuenta, la dirección IP pública del servidor en donde se instaló minio y las llaves de acceso que se generaron al momento de levantar el servicio de minio.
```
hal config storage s3 edit --endpoint http://192.10.24.21:9001 \
    --access-key-id GHNYVL1... \
    --secret-access-key 

    Your AWS Secret Key.:
                       *****

hal config storage edit --type s3

```
Para agregar un bucket definido se agrega el siguiente comando. Si no se agrega, por default se crea un bucket con un nombre aleatorio. 
```
hal config storage s3 edit --bucket spinnaker
```

## Despliegue de Spinnaker
Se instalará de forma distribuida en kubernetes (local), se debe configurar la forma de instalación (distribuido) y la cuenta de kubernetes en la cual se desea instalar.
```
hal config deploy edit --type distributed --account-name k8s-manifest
```
Listar el tipo de versiones de instalación.
```
hal version list  
```
Establecer una versión para el despliegue. 
```
hal config version edit --version $VERSION  
```
Realizar el despliegue de los componentes de Spinnaker. 
```
hal deploy apply -d  
```
La bandera -d ayuda a visualizar todos los pasos que realiza halyard en la ejecución del deploy. 

Verificar que la instalación se haya ejecutado correctamente. 
```
kubectl get pods -n spinnaker
NAME                                READY   STATUS   
spin-clouddriver-7596556b67-sq5rh   1/1     Running   
spin-deck-d68685c86-2wb8m           1/1     Running   
spin-echo-67d69dfbd8-hqrrh          1/1     Running   
spin-front50-6b6b9b5f56-r8rct       1/1     Running   
spin-gate-769795bdd-q5tm8           1/1     Running   
spin-igor-789cf48876-pvkvv          1/1     Running   
spin-orca-5d44f885d8-7jvbt          1/1     Running  
spin-redis-567b85bbbd-jz4m4         1/1     Running   
spin-rosco-686844ddf8-b8pr5         1/1     Running   
```

## Interfaz de Spinnaker 
Se puede exponer el servicio de Spinnaker de dos maneras: 
- [Conectar con la interfaz mediante ssh ](#id4)
- [Exponer servicio en Kubernetes](#id5)


<div id='id4' />

### Conectar con la interfaz mediante ssh 
Desde el servidor halyard, realizar un ssh forwarding con los puertos expuestos de spinnaker (9000 y 8084). 
```
ssh -L 8084:localhost:8084 -L 9000:localhost:9000 root@<ip-halyard>
```
Conectar el servidor de halyard.
```
hal deploy connect 

  Forwarding from 127.0.0.1:8084 -> 8084
  Forwarding from [::1]:8084 -> 8084
  Forwarding from 127.0.0.1:9000 -> 9000
  Forwarding from [::1]:9000 -> 9000       
```
Verificar la interfaz gráfica en el navegador `` localhost:9000``

<div id='id5' />

### Exponer servicio en Kubernetes

Edite el servicio ``spin-deck`` ejecutando el siguiente comando.
```
kubectl edit svc spin-deck -n spinnaker
```
Cambiar el tipo a ``NodePort`` y especifique el puerto en que se desea exponer. 
```
spec:
  type: NodePort
  ports:
  - port: 9000
    protocol: TCP
    targetPort: 9000
    nodePort: 30900
  selector:
    app: spin
    cluster: spin-deck
```
De la misma manera, editar el servicio ``spin-gate``
```
kubectl edit svc spin-gate -n spinnaker
```
Cambiar el tipo a ``NodePort`` y especifique el puerto en que se desea exponer. 
```
spec:
  type: NodePort
  ports:
  - port: 8084
    protocol: TCP
    targetPort: 8084
    nodePort: 30808
  selector:
    app: spin
    cluster: spin-deck
```
En el servidor halyard, modificar los servidores IU y API para que se puedan recibir las solicitudes entrantes, con la nueva configuración de puertos. Como está montado sobre kuberntes, la url estará conformada por la IP del master. 
```
hal config security ui edit \ 
    --override-base-url "http://<ip-master>:30900" 

hal config security api edit \ 
    --override-base-url "http://<ip-master>:30808"  
```
Verificar la interfaz gráfica en el navegador `` http://<ip-master>:30900``