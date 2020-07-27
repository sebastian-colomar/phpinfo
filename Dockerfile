#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
FROM alpine:3.12.0@sha256:3b3f647d2d99cac772ed64c4791e5d9b750dd5fe0b25db653ec4976f7b72837c
RUN apk add php
WORKDIR /srv
RUN echo '<?php phpinfo();?>' | tee index.php
ENTRYPOINT ["php"]
CMD ["-f","index.php","-S","0.0.0.0:8080"]
