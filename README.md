# phpinfo
## Sample PHP application to help learning about Docker containers and Kubernetes orchestration

[![CI](https://github.com/academiaonline-org/phpinfo/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/academiaonline-org/phpinfo/actions/workflows/ci.yaml)

## The application
The application is very simple.
It is a PHP web server that will publish a file containing PHP code.
The PHP code is also very simple: `phpinfo()`.
```
echo '<?php phpinfo();?>' | tee index.php
```
```
php -f index.php -S 0.0.0.0:8080
```
```
curl localhost:8080/index.php -Is
```

## The container
In order to containerize the application we can simply run the following command:
```
docker run --detach --name phpinfo --publish 8080 --user nobody:nogroup --volume ${PWD}/index.php:/src/index.php:ro --workdir /src/ docker.io/library/php:alpine php -f index.php -S 0.0.0.0:8080
```
You can test the application from inside the container running the following command:
```
docker exec phpinfo curl localhost:8080/index.php -Is
```
Or you can test the application from outside the container with the following command:
```
curl localhost:$( docker port phpinfo | cut -d: -f2 )/index.php -Is
```

## The orchestrator
Though the previous method is perfectly appropriate in order to run our application it will not provide high availability.
If the node is down then our application will also be down.
In order to avoid that situation we need a cluster of several nodes so that when one node is down then the other node will take the workload of the affected node.
We can easily create a cluster in this Lab environment:
- https://labs.play-with-docker.com

You will first need to create a free Docker account in order to login to the Docker Playground:
- https://docker.com

Once you have logged in you will need to create at least two instances clicking in the "ADD NEW INSTANCE" to the left menu of the page.
Next step is to initialize the cluster running the following command on the first instance:
```
docker swarm init --advertise-addr $( hostname -i )
```
This last command will initialize a Docker Swarm cluster on the first instance which will act as a master node.
This will be the output of the previous command:
```
Swarm initialized: current node (xxx) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token xxx-xxx-xxx-xxx x.x.x.x:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```
In order to add a worker node to this cluster we need to copy the `docker swarm join` full command and execute in the second instance.
This will be the output of the previous command on the second instance:
```
This node joined a swarm as a worker.
```
Now we can run the following command on the first instance in order to check the cluster availability:
```
docker node ls
```
If you want to deploy the application in this highly available cluster you will need to first create a compose file:
```
tee docker-compose.yaml 0<<EOF
configs:
  config-file:
    file: ${PWD}/index.php
services:
  phpinfo:
    command:
      - php
      - -f
      - index.php
      - -S
      - 0.0.0.0:8080
    configs:
      - 
        mode: 0400
        source: config-file
        target: /src/index.php
        uid: '65534'
        gid: '65534'
    deploy:
      replicas: 1
      placemente:
        -  "node.role==worker"
    image: docker.io/library/php:alpine
    ports:
      - 8080
    user: nobody:nobody
    working_dir: /src/
version: "3.8"
EOF
```
Then you will deploy your highly available application with the following command:
```
docker stack deploy -c docker-compose.yaml phpinfo
```
You can see the result of the deployment with the following commands:
```
docker stack ls
docker stack ps phpinfo
docker stack services phpinfo
```
You can connect to the web server with the following command:
```
curl localhost:$( docker stack services phpinfo | awk /phpinfo_phpinfo/'{ print $6 }' | cut -d: -f2 | cut -d- -f1 )/index.php -Is
```
