//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <rtnet/rtnet_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) rtnet_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "RtnetPlugin");
  rtnet_plugin_register_with_registrar(rtnet_registrar);
}
