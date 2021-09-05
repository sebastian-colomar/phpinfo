INSIDE THE VM
```
sudo docker run --detach --name test --tty library/ubuntu:latest
sudo docker exec --interactive --tty test bash
```
INSIDE THE CONTAINER
```
apt-get update
apt-get install php -y
apt-get install git -y 
cd ${HOME}
git clone https://github.com/academiaonline/phpinfo
php -f phpinfo/src/index.php -S 0.0.0.0:8080
```
FROM ANOTHER TERMINAL OF THE SAME VM
```
sudo docker exec --interactive --tty test bash
```
FROM INSIDE THE CONTAINER (ANOTHER TERMINAL)
```
apt-get install curl -y
curl localhost:8080/phpinfo/src/index.php
apt-get install links2 -y
links2 http://localhost:8080/phpinfo/src/index.php
```
FROM THE VM
```
sudo docker commit test library/ubuntu:test
sudo docker rm --force test
sudo docker run --detach --name test --publish 80:8080 --tty library/ubuntu:test
```
FROM A GRAPHICAL DESKTOP run a Google Chrome pointing to http://localhost/phpinfo/src/index.php

FROM THE VM you can see the IPTABLES rules that make it possible:
```
sudo iptables -S -t filter | grep 8080
sudo iptables -S -t nat | grep 8080
```
