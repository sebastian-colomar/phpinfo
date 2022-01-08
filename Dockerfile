FROM docker.io/library/alpine:latest AS multilayer
RUN apk add php

FROM scratch AS singlelayer
COPY --from=multilayer / /
