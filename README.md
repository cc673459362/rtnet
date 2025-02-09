# rtnet

rtnet is a real-time transmission network library designed for Flutter.

## Getting Started

To use the `rtnet` plugin in your Flutter project, follow these steps:

### 1. Add Dependency

Open your `pubspec.yaml` file and add `rtnet` under `dependencies`:

```yaml
...
dependencies:
  flutter:
    sdk: flutter
  rtnet: latest_version
  ...
```

Then, run the following command to fetch the package:

```sh
flutter pub get
```

### 2. Import the Plugin
In your Dart code, import the rtnet package:
```dart
import 'package:rtnet/rtnet.dart';
```

### 3. Initialize and Use rtnet
Create an instance of Rtnet and start listening for real-time events:
```dart
final _rtnet = Rtnet();

void initRtnet() {
  _rtnet.eventStream.listen((event) {
    print('Received event: $event');
  });

  // Additional setup if needed
}
```

### 4. Platform-Specific Setup
Android (TODO)
No additional setup is required.

iOS
Make sure to add the necessary permissions in ios/Runner/Info.plist if your application requires network access.

### 5. Build and Run
After completing the setup, build and run your Flutter app:
```sh
flutter run
```
Now, your app is ready to use rtnet for real-time data transmission. 🚀


This provides a clear guide on how to integrate and use the `rtnet` plugin in a Flutter project. Let me know if you need any modifications! 😊
