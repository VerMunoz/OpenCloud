# Harbor (Container Registry)

## Instalación con Docker



### Docker registry 
Agregar la siguiente línea en el archivo de configuración ``/etc/docker/daemon.json`` para agregar un registry inseguro. 

```
{
    "insecure-registries" : [ "<hostname_registry>:80" ]
}

Reiniciar docker
```
systemctl daemon-reload
systemctl restart docker
```
