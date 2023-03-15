CREATE A FILE CALLED Dockerfile-volumes with the following content:
```
FROM    library/alpine:latest
RUN     apk add php
```
CREATE THE CONTAINER IMAGE FROM THE Dockerfile-volumes:
```
sudo docker build --file Dockerfile-volumes --tag library/alpine:test-dockerfile-volumes /mnt/
```
CREATE THE CONTAINER FROM THAT IMAGE:
```
test -d phpinfo && rm -rf phpinfo
git clone https://github.com/academiaonline/phpinfo

ENTRYPOINT=php
IMAGE=library/alpine
NAME=test
PUBLISH=80:8080
TAG=test-dockerfile-volumes
VOLUME=phpinfo/src
WORKDIR=/tmp

CMD=" -f index.php -S 0.0.0.0:8080 "
sudo docker run --detach --entrypoint ${ENTRYPOINT} --name ${NAME} --publish ${PUBLISH} --volume ${PWD}/${VOLUME}/:${WORKDIR}/:ro --workdir ${WORKDIR} ${IMAGE}:${TAG} ${CMD}
```
FROM THE VM:
```
curl localhost:80/phpinfo/src/index.php
```
