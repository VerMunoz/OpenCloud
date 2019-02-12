# Istio 

## Prerrequisitos 

- Un clúster de Kubernetes.
- Acceso via ssh al master.

## Instalación 

La instalación se realizará sobre un clúster de Kubernetes, sin autenticación TLS mutua entre sidecars. En la documentación oficial de  [Istio](https://istio.io/docs/setup/kubernetes/quick-start/ "Title") se encuentra otro tipo de instalaciones usando autenticación TLS, Helm y Tiller para el deploy de Istio. 

Para la instalción se ejecuta el siguiente comando. 

``` 
kubectl apply -f install/istio-demo.yaml 
```

## Verificación de la instalción 

Verificación de pods. 
```
# kubectl get pods -n istio-system
NAME                                     READY     STATUS      RESTARTS   AGE
grafana-7f6cd4bf56-gsgpg                 1/1       Running     0          13m
istio-citadel-7dd558dcf-5xgjh            1/1       Running     0          13m
istio-cleanup-secrets-lcsr7              0/1       Completed   0          13m
istio-egressgateway-88887488d-sx8wg      1/1       Running     0          13m
istio-galley-787758f7b8-dr6vn            1/1       Running     0          13m
istio-grafana-post-install-9674c         0/1       Completed   0          13m
istio-ingressgateway-58c77897cc-skqh2    1/1       Running     0          13m
istio-pilot-86cd68f5d9-2rf4r             2/2       Running     0          13m
istio-policy-56c4579578-pgv56            2/2       Running     0          13m
istio-security-post-install-vc82z        0/1       Completed   0          13m
istio-sidecar-injector-d7f98d9cb-g9pgw   1/1       Running     0          13m
istio-telemetry-7fb48dc68b-hjbf9         2/2       Running     0          13m
istio-tracing-7596597bd7-5w7nc           1/1       Running     0          13m
prometheus-76db5fddd5-79rtm              1/1       Running     0          13m
servicegraph-56dddff777-z57bt            1/1       Running     0          13m
```
Verificación de servicios. 
```
kubectl get svc -n istio-system
NAME                     TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S) 
grafana                  ClusterIP      10.101.77.204    <none>        3000/TCP      
istio-citadel            ClusterIP      10.104.62.7      <none>        8060/TCP,9093/TCP 
istio-egressgateway      ClusterIP      10.110.84.161    <none>        80/TCP,443/TCP 
istio-galley             ClusterIP      10.102.203.16    <none>        443/TCP,9093/TCP  
istio-ingressgateway     LoadBalancer   10.100.54.203    <pending>     80:31380/TCP,443:31390/TCP...  
istio-pilot              ClusterIP      10.102.17.133    <none>        15010/TCP,15011/TCP,8080/TCP,9093/TCP   
istio-policy             ClusterIP      10.110.5.219     <none>        9091/TCP,15004/TCP,9093/TCP 
istio-sidecar-injector   ClusterIP      10.109.197.164   <none>        443/TCP     
istio-telemetry          ClusterIP      10.103.116.111   <none>        9091/TCP,15004/TCP,9093/TCP,42422/TCP    
jaeger-agent             ClusterIP      None             <none>        5775/UDP,6831/UDP,6832/UDP   
jaeger-collector         ClusterIP      10.104.236.101   <none>        14267/TCP,14268/TCP   
jaeger-query             ClusterIP      10.107.171.27    <none>        16686/TCP     
prometheus               ClusterIP      10.110.249.184   <none>        9090/TCP 
servicegraph             ClusterIP      10.98.8.91       <none>        8088/TCP  
tracing                  ClusterIP      10.102.38.249    <none>        80/TCP    
zipkin                   ClusterIP      10.109.187.159   <none>        9411/TCP                                                                                                                
```







