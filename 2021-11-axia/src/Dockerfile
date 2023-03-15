FROM alpine:latest AS multilayer
RUN apk add php
COPY index.php src/index.php
#ADD https://raw.githubusercontent.com/academiaonline-org/phpinfo/main/src/index.php src/index.php

FROM scratch AS singlelayer
COPY --from=multilayer / /
