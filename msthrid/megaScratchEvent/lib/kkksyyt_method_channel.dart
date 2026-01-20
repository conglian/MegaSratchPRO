import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'kkksyyt_platform_interface.dart';

/// An implementation of [KkksyytPlatform] that uses method channels.
class MethodChannelKkksyyt extends KkksyytPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('kkksyyt');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
