# Instalación de Kubernetes con Kubespray

**Nota:** Se recomienda que para la instalación con Kubespray se tenga un nodo bastion que tenga comunicación con la infraestructura donde se desea instalar Kubernetes, la infraestructura debe de tener un total de nodos en número impar. 


## Prerrequisitos
La instalación de Kubernetes con Kubespray se realiza mediante Ansible playbooks, por lo que se tiene que dirigir al directorio siguiente para poder ejecutar la instalación. 
```
cd kubespray
```
Para la instalación se debe de crear un inventario de infraestructura, en el que se definirá el tipo de nodo, la dirección IP pública y privada de cada servidor. La comunicación con el nodo bastion a cada nodo se realiza por medio de ``ssh``.

Modificar el inventario de infraestructura. 
```
vi inventory/mycluster/hosts.ini
```
Este archivo tiene 6 grupos. 

El primer grupo es ``[all]``, en el que se define el ``nombre del nodo`` ya sea master o nodo, seguido por ``ansible_host`` en donde se define la dirección IP pública, ``ip`` que es la dirección privada. 

El segundo grupo es ``[kube-master]`` se define que nodo o nodos serán del tipo master. 

El tercer gurpo es ``[etcd]`` se define que nodos tendrán etcd, generalmente los etcd pueden estar en los master, si se requiere de una arquitectura más avanzada puede estar afuera de los master y nodos. 

El cuarto grupo es ``[kube-node]`` se define que nodo cumplirá con el rol de node en kubernetes. 

El último gurpo es ``[all:vars]`` son las variables extras que se requieran para el acceso a los servidores, por ejemplo, si se requiere una contraseña para acceder al servidor se definirá por medio de la variable ``ansible_password``.

```
[all]
master ansible_host=<IP_pública>    ip=<IP_privada>
node1 ansible_host=<IP_pública>     ip=<IP_privada> 
node2 ansible_host=<IP_pública>     ip=<IP_privada>   

[kube-master]
master

[etcd]
master
master1
master2

[kube-node]
node1
node2

[k8s-cluster:children]
kube-master
kube-node

[all:vars]
ansible_password=<password_del_servidor>
```
## Instalación de Kubernetes 
Instalación de kubernetes, se indicanda la ruta en donde está el inventario. 
```
ansible-playbook -i inventory/mycluster/hosts.ini cluster.yml -b -vvv
```

## Escalar nodos
Para escalar nodos se utiliza el siguiente comando.
```
ansible-playbook -i inventory/mycluster/hosts.ini scale.yml -b -vvv
```

## Eliminar nodos
Para eliminar los nodos, se pone los nombres de los nodos que se desean eliminar, si requiere eliminar todo el cluster es necesario eliminar todos los nodos. 
```
ansible-playbook -i inventory/mycluster/hosts.ini remove-node.yml -b -vvv --extra-vars "node=master,node2" --flush-cache
```