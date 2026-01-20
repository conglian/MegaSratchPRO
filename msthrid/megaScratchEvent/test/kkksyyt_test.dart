import 'package:flutter_test/flutter_test.dart';
import 'package:kkksyyt/kkksyyt.dart';
import 'package:kkksyyt/kkksyyt_platform_interface.dart';
import 'package:kkksyyt/kkksyyt_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKkksyytPlatform
    with MockPlatformInterfaceMixin
    implements KkksyytPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final KkksyytPlatform initialPlatform = KkksyytPlatform.instance;

  test('$MethodChannelKkksyyt is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelKkksyyt>());
  });

  test('getPlatformVersion', () async {
    Kkksyyt kkksyytPlugin = Kkksyyt();
    MockKkksyytPlatform fakePlatform = MockKkksyytPlatform();
    KkksyytPlatform.instance = fakePlatform;

    expect(await kkksyytPlugin.getPlatformVersion(), '42');
  });
}
