# Demo Spinnaker Multicloud

La demo consiste en el despliegue de una aplicación multicloud, es decir, se realizará el despliegue sobre una nube privada (kubernetes local) y una nube pública (GCP). 

Este ejemplo, está conformado por dos partes: integración continua y entrega contínua, para realizar la integración contínua se requiere del apoyo de herramientas para la automatización del proceso, se ocupará GitHub como repositorio de código, Google Container Registry para la administración de imágenes, Google Triggers para lanzar la imagen hacia Spinnaker. Y en la parte de entrega contínua se ocupará Spinnaker.  


## Arquitecura

![Demoapp](https://raw.githubusercontent.com/VerMunoz/OpenCloud/master/images/demo-appweb.png)

Los eventos que ocurren en esta demo son los siguientes: 
1. El desarrollador guarda el código en Github, si realiza un cambio o modificación en el código, empuja la etiqueta ``release ``. 
2. Google Container Registry, recibe la etiqueta ``release `` y genera un nuevo contenedor. 
3. Google Triggers, lanza la imagen hacia Spinnaker. 
4. Spinnaker realiza automáticamente el despliegue de la aplicación en un entorno de prueba de Kubernetes (kubernetes local).
5. Usuario valida el despliegue. 
6. Spinnaker realiza automáticamente el despliegue de la aplicación en un entorno de productivo de Kubernetes (GCP).

## Prerrequisitos
 - Spinnaker
    - Cuentas de [Kubernetes local](https://github.com/VerMunoz/OpenCloud/blob/master/docs/spinnaker.md#id2-1y) y [Google Kubernetes Engine](https://github.com/VerMunoz/OpenCloud/blob/master/docs/spinnaker.md#gke), configuradas en Spinnaker.
    - Configurar docker registry [GCR](https://github.com/VerMunoz/OpenCloud/blob/master/docs/spinnaker.md#gcr) y vincularlo con las cuentas anteriormente mencionadas. 
- Cuenta en Github.
- Proyecto en GCP. 


## Código de la aplicación 
Para obtener el código de la aplicación, clonar el siguiente repositorio.
```
git clone https://github.com/VerMunoz/demo-appweb.git
```
Dentro del directorio demo-appweb, existe un archivo llamado cloudbuild.yaml
```
steps:
  - name: "gcr.io/cloud-builders/go"
    args: ["install", "github.com/{GITHUB_HANDLE}/gcp-cd-codelab"]
    env: ["PROJECT_ROOT=github.com/{GITHUB_HANDLE}/gcp-cd-codelab"]
  - name: "gcr.io/cloud-builders/docker"
    args: ["build", "-t", "gcr.io/{GCP_PROJECT_ID}/gcp-cd-codelab:$REVISION_ID", "-f", "Dockerfile", "."]
images:
  - "gcr.io/{GCP_PROJECT_ID}/gcp-cd-codelab:$REVISION_ID"
```
Reemplazar `` {GITHUB_HANDLE}`` por el username de Github y ``{GCP_PROJECT_ID}`` con el id del proyecto en GCP. 

Una vez hecho estos cambios, crear un repositorio y subir todo el directorio demo-appweb a Github.

## Crear un Triger en GCP 

Dentro de la interfaz de GCP, en ``Cloud Container Registry Build Triggers `` seleccionar  ``Create Trigger ``
En fuente seleccionar ``Github `` y el repositorio en donde se guardó el código. 

Triggers settings: 
```
Nombre: demo-appweb
Tipo de activador: Etiqueta
Etiqueta: release 
Build configuration: cloudbuild.yamlrele
cloudbuild.yaml location: /cloudbuild.yaml
```
Seleccionar `` Create trigger ``.

Para probar la compilación y generar el registro del contenedor, realizar los siguientes pasos. 

```
git checkout -b release

git add -A 

git commit -m 'First build!'

git push origin release
```
## Spinnaker pipelines

### Crear una nueva aplicación. 
```
Name: demo-appweb
Owner Email: user@spinnaker.com
```
![NewApp](https://raw.githubusercontent.com/VerMunoz/OpenCloud/master/images/demo-createapp.png)

### Crear LoadBalancers. 
Se van a crear dos tipos de loadbalancer, uno será para el entorno de prueba (k8s local)  y otro para el entorno de produccción (GKE). 

LoadBalancer de entorno de prueba.
```
Basic Settings:
    Account: my-k8s-account  #Es la cuenta configurada con k8s local
    Namespace: default
    Stack: stage 
...
Advanced Settings: 
    Type: NodePort
```
![Loadbalancer](https://raw.githubusercontent.com/VerMunoz/OpenCloud/master/images/demo-createlb.png)

LoadBalancer de entorno de productivo. 
```
Basic Settings:
    Account: my-k8s-account-google  # Es la cuenta configurada con GKE
    Namespace: default
    Stack: prod
...
Advanced Settings: 
    Type: LoadBalancer
```
### Crear Pipelines
#### Pipeline ambiente de prueba 
Para el despliegue en el ambiente de prueba se creará un pipeline, en donde se despliega la aplicación sobre el clúster de kubernetes local.

Seleccionar la opción de Pipeline dentro de la aplicación, y haga clic en el botón ``Crear ``, asignar un nombre de pipeline: Deploy to Stage. 

Del lado izquierdo aparecerá un menú con las opciones a editar, seleccionar ``Automated Triggers `` y agregar un Trigger ``Add Trigger``. 
```
Automated Triggers
    Type: Docker Registry 
    Registry Name: registry-gcr 
    Organization: <id-project-gcp>
    Image: <id-project-gcp>/demo-appweb
```
![Demo-triggers](https://raw.githubusercontent.com/VerMunoz/OpenCloud/master/images/demo-triggers.png)
Agregar una etapa
Seleccionar `` Add stage `` 
```
Type: Deploy 
Stage Name: Deploy 
```
Seleccionar `` Deploy Configuration`` y `` Add server group`` 
```
Basic Settings:
    Account: my-k8s-account 
    Namespace: default
    Stack: stage
    Containers: gcr.io/<id-project-gcp>/demo-appweb (Tag resolved at runtime)
    Strategy: Red/black
    select Scale down replaced server groups to zero instances
    4 Maximun number of server groups to leave
...
Load Balancers
    Load Balancers: demo-appweb-stage
```
![DeployStage](https://raw.githubusercontent.com/VerMunoz/OpenCloud/master/images/demo-deploystage.png)

#### Pipeline validación 
Crear un pipeline, en donde el usuario valida el despliegue en prueba, para poder mandarlo a producción. 

Seleccionar la opción de Pipeline dentro de la aplicación, y haga clic en el botón ``Crear ``, asignar un nombre de pipeline: Validate 

Del lado izquierdo aparecerá un menú con las opciones a editar, seleccionar ``Automated Triggers `` y agregar un Trigger ``Add Trigger``. 
```
Type: Pipeline
Application: demoappweb
Pipeline: Deploy to Stage
Pipeline Status: successful y trrigger enabled. 
```

Para la asignación manual de la validación. Agregar un Stage: 
- Manual Judgment

Seleccionar `` Add Stage``
```
Type: Manual Judgment 
```

#### Pipeline ambiente de producción 

De la misma forma que se crearon los pipelines de ambiente de prueba y validación, crear un pipeline con los siguientes stages: 
- Find image form Cluster.
- Deploy.
- Wait.
- Resize server group.
- Wait.
- Destroy server group.

