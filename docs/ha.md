# High Availability K8s

Para tener un clúster de kubernetes en alta disponibilidad, se debe de tener dos o más master, para ello, se debe de instalar con [Kubespray](https://github.com/VerMunoz/OpenCloud/blob/master/docs/Kubespray.md), agregando al inventario de infraestructura dos o más master. 


## LoadBalancer HaProxy externo 

Para que Kubernetes solo tenga una sola salida, se instala un LoadBalancer HAproxy externo, para que balancee la salida de todos los nodos tipo ``Node Port``.


## Prerrequisitos 
- Una VM  con sistema operativo Centos 7, independiente al cluster de Kubernetes, pero que tenga comunicación al clúster. 

## Arquitectura 
![Haproxy](https://github.com/VerMunoz/OpenCloud/blob/master/images/Haproxy.png?raw=true)

## Instalación de HaProxy
Instalación del paquete de HaProxy en Centos7. 

```
yum install -y haproxy
```
## Configuración de HaProxy 
Editar el archivo de configuración de HaProxy. El archivo se divide en 4 secciones: 

- Global
- Defaults
- Frontend
- Backend: Se configura el tipo y los nodos que se quiere balancear. 

```
vi /etc/haproxy/haproxy.cfg
```
En la sección de ``Frontend`` configurar el puerto 80 y 443 con el dominio *.opencloud.amx.com 
```
frontend http_front
bind *:80
bind *:443 ssl crt /etc/ssl/secret-k8s/tls.pem
reqadd X-Forwarded-Proto:\ https
acl valid_domains hdr(host) -m reg -i ^[^\.]+\.opencloud\.amx\.com$
stats uri /haproxy?stats
default_backend https_back
```
En la sección de ``Backend`` configurar el tipo y los nodos que se quiere balancear (Clúster K8s).
```
backend https_back
balance roundrobin
mode http
server master  <IP-master>:31443  check ssl verify none
server master1 <IP-master1>:31443 check ssl verify none
server master2 <IP-master2>:31443 check ssl verify none
server node1   <IP-node1>:31443   check ssl verify none
server node2   <IP-node2>:31443   check ssl verify none

backend http_back
balance roundrobin
mode http
server master  <IP-master>:31800  check
server master1 <IP-master1>:31800 check
server master2 <IP-master2>:31800 check
server node1   <IP-node1>:31800   check
server node2   <IP-node2>:31800   check
```
Verificar que el archivo es válido. 
```
/usr/sbin/haproxy -c -V -f /etc/haproxy/haproxy.cfg
```
Iniciar el servicio de HaProxy.
```
systemctl start haproxy 
```