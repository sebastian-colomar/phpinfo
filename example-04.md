CREATE THE CONTAINER FROM THAT IMAGE:
```
test -d phpinfo && rm -rf phpinfo
git clone https://github.com/academiaonline/phpinfo

ENTRYPOINT=php
IMAGE=library/php
NAME=test
PUBLISH=80:8080
TAG=latest
VOLUME=phpinfo/src
WORKDIR=/tmp

CMD=" -f index.php -S 0.0.0.0:8080 "
sudo docker run --detach --entrypoint ${ENTRYPOINT} --name ${NAME} --publish ${PUBLISH} --volume ${PWD}/${VOLUME}/:${WORKDIR}/:ro --workdir ${WORKDIR} ${IMAGE}:${TAG} ${CMD}
```
FROM THE VM:
```
curl localhost:80/phpinfo/src/index.php
```
