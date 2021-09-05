CREATE A FILE CALLED Dockerfile with the following content:
```
FROM    library/alpine:latest
RUN     apk add php
RUN     apk add git
RUN     git clone https://github.com/academiaonline/phpinfo
RUN     apk add curl
RUN     apk add links

ENTRYPOINT ["php"]
CMD ["-f","phpinfo/src/index.php","-S","0.0.0.0:8080"]
```
CREATE THE CONTAINER IMAGE FROM THE Dockerfile:
```
sudo docker build --file Dockerfile --tag library/alpine:test-dockerfile /tmp
```
CREATE THE CONTAINER FROM THAT IMAGE:
```
sudo docker run --detach --name test --publish 80:8080 --tty library/alpine:test-dockerfile
```
