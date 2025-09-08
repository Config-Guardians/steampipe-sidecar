# Use latest stable channel SDK.
FROM dart:stable AS build

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

RUN apt update
RUN apt install curl vim -y
RUN /bin/sh -c "$(curl -fsSL https://steampipe.io/install/steampipe.sh)"
USER ubuntu
RUN [ "bash", "-c", "steampipe plugin list" ]

COPY --from=build /app/bin/server /sidecar/bin/

ENTRYPOINT [ "bash", "-c", "steampipe service start --database-password $STMPPPASSWORD; /sidecar/bin/server" ]
