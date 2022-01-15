[![CI](https://github.com/academiaonline-org/phpinfo/actions/workflows/ci.yaml/badge.svg?branch=2022-01)](https://github.com/academiaonline-org/phpinfo/actions/workflows/ci.yaml)

# RUN phpinfo WITHOUT CONTAINERIZATION

```
git clone https://github.com/academiaonline-org/phpinfo
cd phpinfo
git checkout main
```
```
php -f src/index.php -S 0.0.0.0:8080
```
```
curl localhost:8080/src/index.php
```

# RUN phpinfo WITH CONTAINERIZATION (docker run)

```
git clone https://github.com/academiaonline-org/phpinfo
cd phpinfo
git checkout 2022-01
```
```
git pull
```
```
docker build -f Dockerfile -t phpinfo:2022-01 .
```
```
docker run -d --entrypoint php --name phpinfo -p 8080:8080 -v $PWD/src/index.php:/src/index.php:ro -w /src/ phpinfo:2022-01 -f index.php -S 0.0.0.0:8080
```
```
curl localhost:8080/index.php
```

# RUN phpinfo WITH CONTAINERIZATION (docker stack)

```
git clone https://github.com/academiaonline-org/phpinfo
cd phpinfo
git checkout 2022-01
```
```
git pull
```
```
docker build -f Dockerfile -t phpinfo:2022-01 .
```
```
docker stack deploy -c docker-compose.yaml phpinfo
```
```
curl localhost:8080/index.php
```

