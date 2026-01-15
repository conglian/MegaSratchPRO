
import 'gs140okspine_platform_interface.dart';

class Gs140okspine {
  Future<String?> getPlatformVersion() {
    return Gs140okspinePlatform.instance.getPlatformVersion();
  }

  /// 打开浏览器 / intent:// 链接
  Future<void> openBrowser(String url) {
    return Gs140okspinePlatform.instance.openBrowser(url);
  }
}
