#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
FROM alpine:3.12.0@sha256:a15790640a6690aa1730c38cf0a440e2aa44aaca9b0e8931a9f2b0d7cc90fd65
RUN apk add --upgrade php
WORKDIR /srv
RUN echo '<?php phpinfo();?>' | tee index.php
ENTRYPOINT ["php"]
CMD ["-f","index.php","-S","0.0.0.0:8080"]
