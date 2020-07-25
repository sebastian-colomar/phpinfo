FROM alpine
RUN apk add php
WORKDIR /srv
RUN echo '<?php phpinfo();?>' | tee index.php
ENTRYPOINT ["php"]
CMD ["-f","index.php","-S","0.0.0.0:8080"]
