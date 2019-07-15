# Locust - Docker

Crear imagen de docker 
```
docker build -t locust .
```
Verificar que la imagen se construyó .
```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
locust              latest              dd21c924dfd4        2 minutes ago      125MB
```

Crear el contenedor
```
./runit.tmp
```

Bandera ``-e ATTACKED_HOST`` indicará el host que se le quiera enviar el tráfico. 
