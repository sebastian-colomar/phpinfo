FROM alpine:3.15.0@sha256:e7d88de73db3d3fd9b2d63aa7f447a10fd0220b7cbf39803c803f2af9ba256b3 AS multilayer
RUN apk add php

FROM scratch AS singlelayer
COPY --from=multilayer / /
