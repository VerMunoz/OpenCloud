# Minio 

Se instalará Minio en una máquina virtual independiente al cluster de kubernetes, la instalación se realizará de manera local. 

## Prerrequisitos 
- Halyard: 
      Una máquina virtual: 4 CPU, 4 GB de RAM y 50 GB , con sistema operativo Centos 7.4.

## Instalación de Minio 
Para la instalación se cambia el puerto en el que se expone la aplicación debido a que Spinnaker utiliza el puerto 9000 que es el mismo que utiliza default de minio.
```
./shell/minio server /data --address ":9001" 
```
Al finalizar la instalación de minio, se muestra un AccessKey y un SecretKey, es importante que se guarden estas llaves, ya que por medio de ellas, halyard se comunicará con minio. 
```
AccessKey: GHNYVL1836UA590ZH7D8
SecretKey: 6bsOsIRNTXde8VGg0C0btCRgLQBmLmXek75tWd-I
```
Para poner el servicio en segundo plano. 
```
nohup ./shell/minio server /data --address ":9001" & 
```



