# Steampipe Component in Config Guardians

This repository is used to build an image with [Steampipe](https://steampipe.io/) with
GitHub and AWS plugins pre-installed and a [Dart](https://dart.dev/) [Shelf](https://pub.dev/packages/shelf)
sidecar REST API server to provide credentials to Steampipe, enabling the detection part of Config Guardians

The pre-built Docker image is hosted at https://hub.docker.com/repository/docker/zachareee/steampipe-sidecar

This server handles HTTP GET requests to `/` and POST requests to `/plugin`

# Running with the Dart SDK

### This is not recommended as the entire repository revolves around Steampipe
running in the same context, refer to [Running with Docker](#running-with-docker)

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ dart run bin/server.dart
Server listening on port 8080
```

And then from a second terminal:
```
$ curl http://0.0.0.0:8080
Hello, World!
```

# Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```
$ docker build . -t myserver
$ docker run -it -p 8080:8080 myserver
Server listening on port 8080
```

And then from a second terminal:
```
$ curl http://0.0.0.0:8080
Ok
```

You should see the logging printed in the first terminal:
```
2021-05-06T15:47:04.620417  0:00:00.000158 GET     [200] /
```
