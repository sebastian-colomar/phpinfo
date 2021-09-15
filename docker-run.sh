#!/bin/sh

git clone https://github.com/frojascu/phpinfo
cd phpinfo
git ckeckout 2021-09-santander

docker image build \
  --file ./Dockerfile \
  --no-cache \
  --tag local/phpinfo:test \
  ./
  
docker netowrk create phpinfo
docker container run \
  --detach \
  --name phpinfo \
  --network phpinfo \
  --read-only \
  --restart always \
  --user nobody \
  --volume ./src/index.php:/app/index.php:ro \
  --workdir /app/ \
  local/phpinfo:test 
