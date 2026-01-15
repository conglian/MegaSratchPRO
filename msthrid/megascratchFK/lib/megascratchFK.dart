import 'package:flutter/services.dart';

//TODO:修改所有的函数名
final class MegascratchFK {
  static final MegascratchFK instance = MegascratchFK._internal();

  MegascratchFK._internal();

  final _methodChannel = const MethodChannel('megascratchFK');

  //设备是否被Root
  Future<bool> ms_root() async {
    return (await _methodChannel.invokeMethod("ms_root")) == true;
  }

  //是否连接VPN网络
  Future<bool> ms_vpn() async {
    return (await _methodChannel.invokeMethod("ms_vpn")) == true;
  }

  //设备是否有可用的sim卡
  Future<bool> ms_sim() async {
    return (await _methodChannel.invokeMethod("ms_sim")) == true;
  }

  //设备是否为模拟器
  Future<bool> ms_simulator() async {
    return (await _methodChannel.invokeMethod("ms_simulator")) == true;
  }

  //应用是否安装自Google play store
  Future<bool> ms_store() async {
    return (await _methodChannel.invokeMethod("ms_store")) == true;
  }

  //设备是否启用开发者模式
  Future<bool> ms_developer() async {
    return (await _methodChannel.invokeMethod("ms_developer")) == true;
  }

  //安装应用的安装器程序的包名
  Future<String> ms_installer() async {
    return await _methodChannel.invokeMethod("ms_installer");
  }

  //初始化数盟平台
  Future<void> ms_initNumberUnit({required String apiKey}) async {
    await _methodChannel.invokeMethod("ms_initNumberUnit", apiKey);
  }

  //从数盟平台读取数盟可信ID，对应文档请求参数：did
  Future<String> ms_getNumberUnitID({String channel = "", String message = ""}) async {
    return (await _methodChannel.invokeMethod("ms_getNumberUnitID", {
          "channel": channel,
          "message": message,
        })) ??
        "";
  }
}
