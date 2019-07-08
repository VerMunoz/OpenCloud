# Comandos básicos para Kubespray 

### Inventario de infraestructura de kubernetes
```
inventory/mycluster/hosts.ini 
```

## Levantar cluster 
```
ansible-playbook -i inventory/mycluster/hosts.ini cluster.yml -b -vvv
```

## Escalar nodos 
```
ansible-playbook -i inventory/mycluster/hosts.ini scale.yml -b -vvv
```

## Eliminar nodos 
```
ansible-playbook -i inventory/mycluster/hosts.ini remove-node.yml -b -vvv --extra-vars "node=master,master1,master2,node1,node2,node3" --flush-cache
```


