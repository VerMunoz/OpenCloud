# GCP  - Spinnaker

Este documento está orientado a la preparación de GCP para utilizarlo con Docker Registry ([GCR](#id1)) y una cuenta de Kubernetes ([GKE](#id2)) para vincularlo con Spinnaker y probar un ambiente multicloud.

## Prerrequisitos 
- Tener una cuenta en GCP.
- Crear una proyecto dentro de GCP.

## Install SDK 
Se instala SDK para poder tener acceso desde un servidor linux (servidor de Halyard) a la consola de Google.

Se agrega en yum, los datos del repositorio de SDK
```
sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM     
```
Instalar SDK
```
yum install google-cloud-sdk 
```
Ejecuta el siguiente comando para comenzar a utilizar gcloud. 
```
gcloud init   
```
Para iniciar sesión dentro de la consola, primero se autentifica con la sesión de google. 
```
gcloud auth login    
```
En esta parte, se arrojará un link que se abrirá en el navegador y se accede con la cuenta anteriormente creada. 

Vincular el proyecto en el que se está trabajando.
```
gcloud config set project <nombre-del-proyecto>
```
<div id='id1' />

## GCR 

GCR (Google Container Registry) se utilizará como un repositorio de imagenes que se utilizará para almacenar las imagenes que se desplegarán con Spinnaker. 

Debido a que son repositorios privados, se tiene que descargar las credenciales para acceder a GCR.
Se ejecutarán los siguientes comandos en el servidor donde está instalado Halyard.
```
SERVICE_ACCOUNT_NAME=spinnaker-gcr-account
SERVICE_ACCOUNT_DEST=~/.gcp/gcr-account.json

gcloud iam service-accounts create \
    $SERVICE_ACCOUNT_NAME \
    --display-name $SERVICE_ACCOUNT_NAME

SA_EMAIL=$(gcloud iam service-accounts list \
    --filter="displayName:$SERVICE_ACCOUNT_NAME" \
    --format='value(email)')

PROJECT=$(gcloud info --format='value(config.project)')

gcloud projects add-iam-policy-binding $PROJECT \
    --member serviceAccount:$SA_EMAIL \
    --role roles/browser

gcloud projects add-iam-policy-binding $PROJECT \
    --member serviceAccount:$SA_EMAIL \
    --role roles/storage.admin

mkdir -p $(dirname $SERVICE_ACCOUNT_DEST)

gcloud iam service-accounts keys create $SERVICE_ACCOUNT_DEST \
    --iam-account $SA_EMAIL

PASSWORD_FILE=$SERVICE_ACCOUNT_DEST
```
<div id='id2' />

## Creación de un clúster GKE 
Se creará un clúster de Kubernetes en GKE (Google Kubernetes Engine).
En la interfáz de GCP se selecciona la opción, crear cluster de kubernetes estándar. 
```
Nombre: kube-gke
Tipo de Ubicación: Zona 
Zona: us-central1-f
Versión maestra: 1.11.2-gke.15
Grupo de nodos: 
     Número de nodos: 3
     Tipo de máquina: 1 vCPU
```
Una vez que se configuraron las anteriores especificaciones, seleccionar **Crear**. 

![GKE-create](https://raw.githubusercontent.com/VerMunoz/OpenCloud/master/images/gke-createcluster.png)

### Conexión del servidor Halyard al cluster GKE
Una vez creado el cluster de kubernetes, se conectará al clúster mediante el comando que genera en la parte de “Conectarse al clúster mediante la línea de comando". 

![GKE-create](https://raw.githubusercontent.com/VerMunoz/OpenCloud/master/images/gke-connectcluster.png)

En el servidor de halyard, se configura la opción "use client certificate", para que cambiar las certificados.
```
gcloud config unset container/use_client_certificate
```
Posteriormente, se copia el comando generado en la consola de GCP “Conectarse al clúster mediante la línea de comando"
```
gcloud container clusters get-credentials standard-cluster-1 --zone us-central1-a --project spin-test-230020 
```
Al ejecutar este comando, se genera el archivo de configuración que requiere halyard para poderse comunicar con el cluster, en este caso, el comando se ejecutó desde /root/, por lo que el archivo de configuración se creará en la misma ubicación que se ejecutó el comando, es decir /root/admin.conf

### Acceso a GKE 
Para tener total acceso al cluster de kubernetes, es necesario crear una cuenta de servicio.

Identificar el nombre del contexto del cluster. 
```
CONTEXT=$(kubectl config current-context)
```
Crear la cuenta de servicio 
```
kubectl apply --context $CONTEXT \
    -f https://spinnaker.io/downloads/kubernetes/service-account.yml
```
Generar un token y configurarlo en la cuenta de kubernetes 
```
TOKEN=$(kubectl get secret --context $CONTEXT \
   $(kubectl get serviceaccount spinnaker-service-account \
       --context $CONTEXT \
       -n spinnaker \
       -o jsonpath='{.secrets[0].name}') \
       -n spinnaker \
       -o jsonpath='{.data.token}' | base64 --decode)

kubectl config set-credentials ${CONTEXT}-token-user --token $TOKEN

kubectl config set-context $CONTEXT --user ${CONTEXT}-token-user
```



