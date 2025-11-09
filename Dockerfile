# Use latest stable channel SDK.
FROM dart:3.9.4 AS build

# Resolve app dependencies.
WORKDIR /app
COPY . .
RUN dart pub get

# Copy app source code (except anything in .dockerignore) and AOT compile app.
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
FROM ubuntu:25.04
WORKDIR /app

EXPOSE 8080 9193
ARG PASSWORD=password
ENV STMPPPASSWORD=$PASSWORD
ENV STEAMPIPE_CACHE=false

RUN apt update
RUN apt install curl -y
RUN /bin/sh -c "$(curl -fsSL https://steampipe.io/install/steampipe.sh)"
USER ubuntu
# install preconfigured plugins
RUN [ "bash", "-c", "steampipe plugin install aws github" ]

COPY --from=build /app/bin/server /sidecar/bin/

ENTRYPOINT [ "bash", "-c", "steampipe service start --database-password $STMPPPASSWORD; /sidecar/bin/server" ]
