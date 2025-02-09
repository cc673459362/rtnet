# rtnet

A new Flutter plugin project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/to/develop-plugins),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



当前的问题是  main.dart 添加stream监听会crash

原来是FlutterStreamHandler的方法返回值写错了， 导致么有正确的实现这个delegate.