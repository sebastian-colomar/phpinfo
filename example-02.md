CREATE A FILE CALLED Dockerfile with the following content:
```
FROM    library/ubuntu:latest
WORKDIR /root 
RUN     apt-get update
RUN     apt-get install php -y
RUN     apt-get install git -y 
RUN     git clone https://github.com/academiaonline/phpinfo
RUN     apt-get install curl -y
RUN     apt-get install links2 -y

ENTRYPOINT ["php"]
CMD ["-f","phpinfo/src/index.php","-S","0.0.0.0:8080"]
```
