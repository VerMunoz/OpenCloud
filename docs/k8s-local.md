# Kubernetes

Se creará un clúster de kubernetes v.1.11.1 en un ambiente local, montado sobre máquinas virtuales basadas en OpenStack. 

## Arquitectura 

Este clúster estará compuesto por un nodo master y tres nodos workers. 

![Arquitectura](https://raw.githubusercontent.com/VerMunoz/OpenCloud/master/images/k8s-arquitectura.png)

## Prerrequisitos 

- Para el nodo master: 
Una máquina virtual: 2 CPU, 2 GB de RAM y 30 GB Cloud Hard Disk, con sistema operativo Centos 7.4.

- Para nodos worker: 
Tres máquinas virtuales: 4 CPU, 4 GB de RAM y 50 GB Cloud Hard Disk, con sistema operativo Centos 7.4.

## Instalación 

En todos los nodos ejecutar el script de instalación de k8s, en este contiene algunas configuraciones y la instalación de docker, kubelet, kubeadm, kubectl.

```
./install/k8s-local.sh 
```

## Preparación del master

### Para el master 
Para iniciar el clúster, es necesario realizar el comando kubeadm init, el cual ejecutará comprobaciones para garantizar que la máquina está lista para ejecutar kubernetes, y posteriormente, descarga e instala los componentes del plano de control del clúster. 

Es necesario tener comunicación con otros pods, una red interna basada en CNI (Containers Network Interface). En este caso se instaló con Flannel, indicando en kubeadm init la dirección de flanel.

```
kubeadm init --pod-network-cidr=10.244.0.0/16
```
Al finalizar la ejecución, nos muestra que el master de kubernetes ha iniciado, y nos proporciona un token para vincular los nodos workers. 

```
You can now join any number of machines by running the following on each node
as root:

kubeadm join 192.168.14.225:6443 --token uir7wt.6p18syebgnkz7lhh --discovery-token-ca-cert-hash sha256:28b78ee520deaf5da9fc92e71322cca9e60114d450de9b343471074227b4f77f
```

Se debe de exportar la variable de entorno KUBECONFIG, para las configuraciones de kubernetes. 
```
export KUBECONFIG=/etc/kubernetes/admin.conf
```

Para seleccionar la red con flannel, es necesario ejecutar el siguiente comando.
```
 kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml
```
Opcional:

Para que siempre se guarde la variable en el shell es necesario modificar el archivo ~/.bashrc. 
```
 vi ~/.bashrc 
```
Agregar la siguiente línea. 
```
export KUBECONFIG=/etc/kubernetes/admin.conf
```
### Para los workers
Copiar el comando kubeadm join que se obtuvo al realizar kubeadm init en el nodo master. 
```
kubeadm join 192.168.14.225:6443 --token uir7wt.6p18syebgnkz7lhh --discovery-token-ca-cert-hash sha256:28b78ee520deaf5da9fc92e71322cca9e60114d450de9b343471074227b4f77f
```

### Verifiación de la instalación 
Para revisar que el cluster de kubernetes ya está listo, en el nodo master se ejecutará el siguiente comando.
```
kubectl get nodes 

NAME                       STATUS       ROLES      AGE        VERSION
kube-master.novalocal      Ready        master     15m        v1.11.1
kube-work01                Ready        <none>     14m        v1.11.1 
kube-work02                Ready        <none>     14m        v1.11.1 
kube-work03                Ready        <none>     14m        v1.11.1 
```



