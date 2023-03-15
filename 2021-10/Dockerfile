FROM library/alpine:3.14.2@sha256:69704ef328d05a9f806b6b8502915e6a0a4faa4d72018dc42343f511490daf8a
RUN apk add php

FROM scratch
COPY --from=0 / /

ENTRYPOINT ["/usr/bin/php"]
CMD ["-v"]
