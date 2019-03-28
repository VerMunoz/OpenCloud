#!/bin/bash 

#Desactivar memoria swapp.
swapoff -a 

#Actualizar el sistema.
yum -y update

#Instalar docker.
yum install -y docker  

#Habilitar e iniciar el servicio de docker. 
systemctl enable docker && systemctl start docker

#Añadir el repositorio de kubernetes en /etc/yum.repos.d/kubernetes.repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=0
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

#Desactivar selinux 
setenforce 0 

#Selinux en modo permisivo 
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

#Instalar kubelet, kubeadm, kubectl 
yum install -y kubelet kubeadm kubectl 
systemctl enable kubelet && systemctl start kubelet

#Revisar que net.bridge.bridge-nf-call-iptables esté en 1, en la configuración sysctl. 
cat <<EOF >> /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

