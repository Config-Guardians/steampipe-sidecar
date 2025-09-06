import 'package:shelf/shelf.dart';

Middleware rejectBadRequests() {
  return (innerhandler) {
    return (request) {
      if (request.method != 'POST') {
        return Response(405, body: "Method not Allowed");
      }
      return innerhandler(request);
    };
  };
}
