CREATE THE CONTAINER FROM THE OFFICIAL DOCKERHUB IMAGE:
```
test -d phpinfo && rm -rf phpinfo
git clone https://github.com/academiaonline/phpinfo

ENTRYPOINT=php
IMAGE_REPOSITORY=library/php
IMAGE_TAG=latest
NAME=test
PUBLISH=80:8080
VOLUME=phpinfo/src/
WORKDIR=/opt/

CMD=" -f index.php -S 0.0.0.0:8080 "
sudo docker run --detach --entrypoint ${ENTRYPOINT} --name ${NAME} --publish ${PUBLISH} --volume ${PWD}/${VOLUME}:${WORKDIR}:ro --workdir ${WORKDIR} ${IMAGE_REPOSITORY}:${IMAGE_TAG} ${CMD}
```
RUN IN THE HOST MACHINE:
```
curl localhost:80/phpinfo/src/index.php
```
