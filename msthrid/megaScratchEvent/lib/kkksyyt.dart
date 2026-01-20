
import 'kkksyyt_platform_interface.dart';

class Kkksyyt {
  Future<String?> getPlatformVersion() {
    return KkksyytPlatform.instance.getPlatformVersion();
  }
}
