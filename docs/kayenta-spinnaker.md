# Kayenta 

Kayenta es una plataforma que Spinnaker utiliza para el Análisis Canario Automatizado (ACA), como una estrategia de despligue de aplicaciones. 

### Prerequisitos
- [Prometheus](https://github.com/VerMunoz/OpenCloud/blob/master/docs/prometheus.md).
- [Minio](https://github.com/VerMunoz/OpenCloud/blob/master/docs/minio.md). 


## Instalación

Habilitar canary. 
```
hal config canary enable
```
(Opcional) Habilitar JUDGE, es una opción de kayenta que sirve para evaluar la calidad de un despliegue de canary comparandolo con una línea de base. El proceso con el que se ejecuta es la validación de datos, preparación de las métricas para su comparación, comparación de métricas y el cálculo de puntuación. 

```
hal config canary edit --default-judge JUDGE
```
### Configurar el proveedor de métricas 
Se crea una cuenta con los datos de Prometheus, que será el proveedor de métricas. 
```
hal config canary prometheus account add canary-prometheus --base-url http://<ip-master>:30001
```

### Configurar el proveedor de storage
Se configura como proveedor de storage a Minio.

Debido a que se utiliza S3 se debe de habilitar AWS.
```
hal config canary aws enable
```
Se crea una cuenta con los datos de Minio. 
```
hal config canary aws account add MinioS3 --bucket spinnaker --secret-access-key --access-key-id GHNYVL1836UA590ZH7D8 --endpoint http://<ip-master>:9001
```
Se habilita S3. 
```
hal config canary aws edit --s3-enabled true
```
Se agrega la cuenta creada a canary. 
```
hal config canary edit --default-storage-account MinioS3
```


