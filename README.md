# phpinfo
## Sample application to help learning about Docker containers and Kubernetes orchestration

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
In order to containerize the application we can simply apply the following command:
```
docker run --detach --entrypoint php --name phpinfo --publish 8080 --user nobody:nogroup --volume ${PWD}/index.php:/src/index.php:ro --workdir /src/ docker.io/library/php:alpine -f index.php -S 0.0.0.0:8080
```
