import 'package:flutter_test/flutter_test.dart';
import 'package:gs140okspine/gs140okspine.dart';
import 'package:gs140okspine/gs140okspine_platform_interface.dart';
import 'package:gs140okspine/gs140okspine_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGs140okspinePlatform
    with MockPlatformInterfaceMixin
    implements Gs140okspinePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final Gs140okspinePlatform initialPlatform = Gs140okspinePlatform.instance;

  test('$MethodChannelGs140okspine is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGs140okspine>());
  });

  test('getPlatformVersion', () async {
    Gs140okspine gs140okspinePlugin = Gs140okspine();
    MockGs140okspinePlatform fakePlatform = MockGs140okspinePlatform();
    Gs140okspinePlatform.instance = fakePlatform;

    expect(await gs140okspinePlugin.getPlatformVersion(), '42');
  });
}
