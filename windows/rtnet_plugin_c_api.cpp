#include "include/rtnet/rtnet_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "rtnet_plugin.h"

void RtnetPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  rtnet::RtnetPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
