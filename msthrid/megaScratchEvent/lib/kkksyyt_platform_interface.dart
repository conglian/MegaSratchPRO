import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'kkksyyt_method_channel.dart';

abstract class KkksyytPlatform extends PlatformInterface {
  /// Constructs a KkksyytPlatform.
  KkksyytPlatform() : super(token: _token);

  static final Object _token = Object();

  static KkksyytPlatform _instance = MethodChannelKkksyyt();

  /// The default instance of [KkksyytPlatform] to use.
  ///
  /// Defaults to [MethodChannelKkksyyt].
  static KkksyytPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KkksyytPlatform] when
  /// they register themselves.
  static set instance(KkksyytPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
