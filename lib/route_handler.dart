// On change of routes, run `dart run build_runner build`
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sidecar/steampipe.dart';

part 'route_handler.g.dart';

const headers = {'Content-Type': 'application/json'};

class PluginService {
  Router get router => _$PluginServiceRouter(this);

  @Route.post("/plugin")
  Future<Response> _installHandler(Request req) async {
    final Map map = json.decode(await req.readAsString());
    final list = [
      "plugin",
      "configuration",
    ].where((k) => !map.containsKey(k)).toList();
    if (list.isNotEmpty) {
      return Response.badRequest(
        body: json.encode({'message': 'Keys not found: $list'}),
        headers: headers,
      );
    }

    final plugin = map["plugin"];
    if (!validPluginName(plugin)) {
      return Response.badRequest(
        body: json.encode({'message': 'Plugin is not supported: $plugin'}),
        headers: headers,
      );
    }

    writeConfigToFile(plugin, map["configuration"]);
    final ProcessResult(:exitCode, :stdout, :stderr) = installPlugin(plugin);

    if (exitCode != 0) {
      return Response.internalServerError(
        body: json.encode({
          'message': 'Error, see stdout and stderr for details',
          'exitCode': exitCode,
          'stdout': stdout,
          'stderr': stderr,
        }),
        headers: headers,
      );
    }

    return Response.ok(json.encode({'message': 'Success!'}), headers: headers);
  }
}
