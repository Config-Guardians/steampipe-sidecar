import 'package:shelf/shelf.dart';

Middleware rejectBadRequests() {
  return (innerhandler) {
    return (request) {
      return innerhandler(request);
    };
  };
}
