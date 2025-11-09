// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_handler.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$PluginServiceRouter(PluginService service) {
  final router = Router();
  router.add('GET', r'/', service._getHandler);
  router.add('POST', r'/plugin', service._installHandler);
  return router;
}
