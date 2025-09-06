import 'dart:io';

const configPath = "/home/ubuntu/.steampipe/config";

bool validPluginName(String name) {
  return ["aws", "gcp", "azure", "oci"].contains(name);
}

ProcessResult installPlugin(String pluginName) {
  return Process.runSync("steampipe", ["plugin", "install", pluginName]);
}

void writeConfigToFile(String pluginName, String configuration) {
  File("$configPath/$pluginName.spc").writeAsStringSync(configuration);
}
