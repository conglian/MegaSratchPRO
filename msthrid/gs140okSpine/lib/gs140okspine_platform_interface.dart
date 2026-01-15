import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gs140okspine_method_channel.dart';

abstract class Gs140okspinePlatform extends PlatformInterface {
  /// Constructs a Gs140okspinePlatform.
  Gs140okspinePlatform() : super(token: _token);

  static final Object _token = Object();

  static Gs140okspinePlatform _instance = MethodChannelGs140okspine();

  /// The default instance of [Gs140okspinePlatform] to use.
  ///
  /// Defaults to [MethodChannelGs140okspine].
  static Gs140okspinePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Gs140okspinePlatform] when
  /// they register themselves.
  static set instance(Gs140okspinePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }


  /// 打开浏览器 / intent:// 链接
  Future<void> openBrowser(String url) {
    throw UnimplementedError('openBrowser() has not been implemented.');
  }
}
