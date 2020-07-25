#########################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza      #
#      SPDX-License-Identifier:  GPL-2.0-only                           #
#########################################################################
FROM alpine
RUN apk add php
WORKDIR /srv
RUN echo '<?php phpinfo();?>' | tee index.php
ENTRYPOINT ["php"]
CMD ["-f","index.php","-S","0.0.0.0:8080"]
