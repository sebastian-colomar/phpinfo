# phpinfo
## Sample PHP application to help learning about Docker containers and Kubernetes orchestration

[![CI](https://github.com/academiaonline-org/phpinfo/actions/workflows/ci.yaml/badge.svg?branch=main)](https://github.com/academiaonline-org/phpinfo/actions/workflows/ci.yaml)
## The testing environment
We can use any available Linux shell to run the exercises.
In our case we are going to use Google Cloud Shell:
- https://shell.cloud.google.com

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
docker run --cpus 0.01 --detach --memory 10M --memory-reservation 10M --name phpinfo --publish 8080 --read-only --restart always --user nobody:nogroup --volume ${PWD}/index.php:/src/index.php:ro --workdir /src/ index.docker.io/library/php:alpine php -f index.php -S 0.0.0.0:8080
```
You can test the application from inside the container running the following command:
```
docker exec phpinfo curl localhost:8080/index.php -Is
```
Or you can test the application from outside the container with the following command:
```
curl localhost:$( docker port phpinfo | cut -d: -f2 )/index.php -Is
```
Or you can just check the container logs:
```
docker logs phpinfo
```
You can remove the container with the following command:
```
docker rm --force phpinfo
```
## The compose file
We can use a compose file instead of manually creating individual containers with the Docker command line.
The advantages of using compose files are numerous (such as accountability, auditability, collaborative work, transparency, etc.).
Run the following command to create a Docker compose file:
```
tee docker-compose.yaml 0<<EOF

services:
  phpinfo:
    command:
      - php
      - -f
      - index.php
      - -S
      - 0.0.0.0:8080
    image: index.docker.io/library/php:alpine
    ports:
      - 8080
    read_only: true
    restart: always
    scale: 1
    user: nobody:nogroup
    volumes:
      -
        read_only: true
        source: ./index.php
        target: /src/index.php
        type: bind
    working_dir: /src/
version: "2.4"

EOF
```
Once the file has been created, you can deploy the application with the following command:
```
docker-compose up --detach
```
You can check the logs with the following command:
```
docker-compose logs
```
You can display the running processes with the following command:
```
docker-compose top
```
You can test the connection to the web server using the following command:
```
curl localhost:$( docker-compose ps | grep phpinfo | awk '{ print $6 }' | cut -d : -f 2 | cut -d - -f 1 )/index.php -Is
```
You can remove the application with the following command:
```
docker-compose down
```
## The orchestrator
Although the above method is perfectly suitable for running our application, it will not provide high availability.
If the node is down, our application will be down too.
To avoid that situation, we need a multi-node cluster so that when one node is down, the other node takes the workload of the affected node.
We can easily create a cluster in this lab environment:
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
We repeat the same operation to add a second worker node to the cluster.

Now we can run the following command on the first master instance in order to check the cluster availability:
```
docker node ls
```
If you want to deploy the application in this highly available cluster you will need to first create a compose file:
```
tee docker-stack.yaml 0<<EOF

configs:
  my_config:
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
        source: my_config
        target: /src/index.php
        uid: '65534'
        gid: '65534'
    deploy:
      placement:
        constraints:
          -  "node.role==worker"
      replicas: 1
      resources:
        limits:
          cpus: '0.01'
          memory: 10M
        reservations:
          cpus: '0.01'
          memory: 10M
    image: index.docker.io/library/php:alpine
    ports:
      - 8080
    read_only: true
    user: nobody:nogroup
    working_dir: /src/
version: "3.8"

EOF
```
Then you will deploy your highly available application with the following command:
```
docker stack deploy --compose-file docker-stack.yaml phpinfo
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
You can remove the application with the following command:
```
docker stack rm phpinfo
```
