# Issues Spinnaker 

## Istio con Spinnaker 

Cuando un namespace tiene habilitado ```istio-injection```, no permite crear ServersGroups.

Deshabilitar ```istio-injection```
```
kubectl label namespace <name-namespace> istio-injection=disable --overwrite
```


Version 1.13.6 Issue Canary 

``` java.lang.IllegalArgumentException ```


Version 1.13.12
No tiene Jobs v2 Manifest

Versión +1.13.12 no tiene Registry en UI al configurar Server Group 