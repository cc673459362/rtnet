#ifndef FLUTTER_PLUGIN_RTNET_PLUGIN_H_
#define FLUTTER_PLUGIN_RTNET_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace rtnet {

class RtnetPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  RtnetPlugin();

  virtual ~RtnetPlugin();

  // Disallow copy and assign.
  RtnetPlugin(const RtnetPlugin&) = delete;
  RtnetPlugin& operator=(const RtnetPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace rtnet

#endif  // FLUTTER_PLUGIN_RTNET_PLUGIN_H_
