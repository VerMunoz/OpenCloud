# Harbor (Container Registry)

## Instalación con Docker compose 
Los elementos que se instalarán con docker compose son los siguientes: 

- Harbor adminserver
- Harbor core
- Harbor db (base de datos)
- Harbor jobservice 
- Harbor log
- Harbor portal
- Nginx
- Redis
- Registry
- Registryctl 

### Prerrequisitos
- Tener instalado [docker-compose](https://docs.docker.com/compose/install/) en su VM. 

**Hardware**

| Recurso | Capacidad     | Descripción           |
| :------ | :------------ | :-------------------- |
| CPU     | mínimo 2 CPU  | De preferencia 4 CPU  | 
| Memoria | mínimo 4 GB   | De preferencia 8 GB   |
| Disco   | mínimo 40 GB  | De preferencia 160 GB |


### Instalación 
Descomprimir el paquete install/harbor-online-installer-v1.7.5.tgz
```
tar xvf install/harbor-online-installer-v1.7.5.tgz 
```

Situarse en el directorio harbor
```
cd harbor 
```
Editar el archivo ``harbor.cfg``, en la parte de hostname indicar el nombre de dominio o IP. 
```
hostname = <dominio.com_o_direccionIP>
```
Si desea personalizar la instación, modificar los [parámetros adicionales](https://github.com/goharbor/harbor/blob/master/docs/installation_guide.md#optional-parameters) del archivo ``harbor.cfg``.

Ejecutar docker-compose.
```
docker-compose up -d
```
Verificar que todos los contenedores están activos. 
```
       Name                     Command                  State                                    Ports                              
-------------------------------------------------------------------------------------------------------------------------------------
harbor-adminserver   /harbor/start.sh                 Up (healthy)                                                                   
harbor-core          /harbor/start.sh                 Up (healthy)                                                                   
harbor-db            /entrypoint.sh postgres          Up (healthy)   5432/tcp                                                        
harbor-jobservice    /harbor/start.sh                 Up                                                                             
harbor-log           /bin/sh -c /usr/local/bin/ ...   Up (healthy)   127.0.0.1:1514->10514/tcp                                       
harbor-portal        nginx -g daemon off;             Up (healthy)   80/tcp                                                          
nginx                nginx -g daemon off;             Up (healthy)   0.0.0.0:443->443/tcp, 0.0.0.0:4443->4443/tcp, 0.0.0.0:80->80/tcp
redis                docker-entrypoint.sh redis ...   Up             6379/tcp                                                        
registry             /entrypoint.sh /etc/regist ...   Up (healthy)   5000/tcp                                                        
registryctl          /harbor/start.sh                 Up (healthy)
```

Iniciar sesión con registry de harbor 
```
docker login <hostname>:80

username: Harbor
Password: ****
```
Si configuró el registry con http, debe de configurar docker para que pueda acceder a un docker registry inseguro. 

### Insecure Docker registry 
Agregar la siguiente línea en el archivo de configuración ``/etc/docker/daemon.json`` para agregar un registry inseguro. 

```
{
    "insecure-registries" : [ "<hostname_registry>:80" ]
}
```


Reiniciar docker
```
systemctl daemon-reload
systemctl restart docker
```
