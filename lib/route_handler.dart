import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sidecar/steampipe.dart';

final router = Router()..post('/plugin', _installHandler);

Future<Response> _installHandler(Request req) async {
  final Map map = json.decode(await req.readAsString());
  final list = [
    "plugin",
    "configuration",
  ].where((k) => !map.containsKey(k)).toList();
  if (list.isNotEmpty) {
    return Response.badRequest(
      body: json.encode({'message': 'Keys not found: $list'}),
    );
  }

  final plugin = map["plugin"];
  if (!validPluginName(plugin)) {
    return Response.badRequest(
      body: json.encode({'message': 'Plugin is not supported: $plugin'}),
    );
  }

  writeConfigToFile(plugin, map["configuration"]);
  final ProcessResult(:exitCode, :stdout, :stderr) = installPlugin(plugin);

  if (exitCode != 0) {
    return Response.internalServerError(
      body: json.encode({
        'exitCode': exitCode,
        'stdout': stdout,
        'stderr': stderr,
      }),
    );
  }

  return Response.ok(json.encode({'exitCode': exitCode}));
}
