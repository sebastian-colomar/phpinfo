CREATE A FILE CALLED Dockerfile with the following content:
```
FROM    library/alpine:latest
RUN     apk add php
```
CREATE THE CONTAINER IMAGE FROM THE Dockerfile:
```
sudo docker build --file Dockerfile --tag library/alpine:test-dockerfile-volumes /mnt/
```
CREATE THE CONTAINER FROM THAT IMAGE:
```
test -d phpinfo && rm -rf phpinfo
git clone https://github.com/academiaonline/phpinfo

ENTRYPOINT=php
CMD=" -f phpinfo/src/index.php -S 0.0.0.0:8080 "
sudo docker run --detach --entrypoint ${ENTRYPOINT} --name test --publish 80:8080 --tty --volume phpinfo/src/:/phpinfo/src/ library/alpine:test-dockerfile-volumes ${CMD}
```
FROM THE VM:
```
curl localhost:80/phpinfo/src/index.php
```
