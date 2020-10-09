#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
FROM alpine/git:latest AS clone

ARG dir=/clone-folder
ARG hostname=github.com
ARG project=phpinfo
ARG username=secobau

WORKDIR $dir
RUN git clone https://$hostname/$username/$project

###

FROM alpine:3.12.0@sha256:a15790640a6690aa1730c38cf0a440e2aa44aaca9b0e8931a9f2b0d7cc90fd65 AS production

ARG dir_old=/clone-folder/phpinfo/src
ARG dir=/production-folder
ARG project=index.php

WORKDIR $dir
COPY --from=clone $dir_old/$project . 

RUN apk add --upgrade php

ENTRYPOINT ["php"]
CMD ["-f","index.php","-S","0.0.0.0:8080"]
#########################################################################
