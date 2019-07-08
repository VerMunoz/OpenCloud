# Tareas programadas

Una herramienta de Linux para poder administrar tareas programadas es ``cron``

Crear un archivo de configuración para cron. Para este ejemplo, se apagan y se inician unas máquinas virtuales de GCP de un cluster de Kuberentes y Azure para economizar costos en la nube. 

```
#Detener VMs en GCP
30 19 * * mon,tue,wed,thu,fri gcloud container clusters resize k8s --size=0  -q

#Iniciar VMs en GCP
00 11 * * mon,tue,wed,thu,fri gcloud container clusters resize k8s --size=2  -q

#Detener VM en Azure
30 19 * * mon,tue,wed,thu,fri az vm stop --resource-group MC_k8s_Spincluster_eastus --name aks-agentpool-15979261-0

#Iniciar VM en Azure
00 11 * * mon,tue,wed,thu,fri az vm start --resource-group MC_k8s_Spincluster_eastus --name aks-agentpool-15979261-0
```
Iniciar el servicio de cron
```
service crond start
```

Ver el estatus de cron
```
service crond status
```
Ver el archivo de configuración de cron.
```
crontab -e
```