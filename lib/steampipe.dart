import 'dart:io';

const configPath = "/home/ubuntu/.steampipe/config";

bool validPluginName(String name) {
  return ["aws", "gcp", "azure", "oci", "github"].contains(name);
}

ProcessResult installPlugin(String pluginName) {
  final res = Process.runSync("steampipe", ["plugin", "install", pluginName]);
  if (!(res.stdout as String).contains("Already installed")) {
    Process.runSync("steampipe", ["service", "restart"]);
  }
  return res;
}

void writeConfigToFile(String pluginName, String configuration) {
  File("$configPath/$pluginName.spc").writeAsStringSync(configuration);
}
