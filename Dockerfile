# Render Free Web Service - Docker
# Multi-stage: copy xray binary from official image (no shell) onto Node Alpine,
# then run the same Node wrapper as Pxxl. Render injects $PORT (default 10000),
# edge terminates TLS, container serves plain WS.
FROM ghcr.io/xtls/xray-core:latest AS xraybin
FROM node:20-alpine
RUN apk add --no-cache ca-certificates curl unzip
WORKDIR /app
COPY package.json server.js setup.js ./
# Download xray at build time so runtime start is fast and deterministic.
# Build-time dummy UUID/WSPATH only write a placeholder config;
# server.js rewrites config.json from the real env on every start.
RUN UUID=00000000-0000-4000-8000-000000000000 WSPATH=buildtime node setup.js
EXPOSE 10000
CMD ["node", "server.js"]
