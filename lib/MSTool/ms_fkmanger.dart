import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:http/http.dart' as http;
import 'package:megascratchFK/megascratchFK.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../MSModel/MSFkModel.dart';
import 'ms_LocalProvider.dart';
import 'ms_TBAInfoTool.dart';
import 'ms_extension_help.dart';

class MSFKManger {
  static final MSFKManger _instance = MSFKManger._internal();

  factory MSFKManger() {
    return _instance;
  }

  MSFKManger._internal();

  MSFkModel fkModel = MSFkModel();

  Future<void> initFKJson() async {
    'fkModel=$fkModel'.log();
    if (fkModel.behavior.ad_daily_show == 0) {
      String jsonString = await rootBundle.loadString("ms_control140".jsons());
      'risk_control=$jsonString'.log();
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      fkModel = MSFkModel.fromJson(jsonMap);
    }
    "Megascractch fk json = ${fkModel.behavior.ad_daily_show}".log();
  }


  Future<void> initFK() async {
    ms_checkRoot();
    ms_checkVpn();
    ms_checkSim();
    ms_checkSimulator();
    ms_checkDeveloper();
    ms_checkStore();
    ms_checkIP();
    ms_checkNum();
  }

  // 是否需要打开风控
  Future<bool> ms_checkAllStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // behavior
    bool behavior = await ms_checkUser();
    'behavior=$behavior'.log();
    // number
    bool number = prefs.getBool('ms_fk_number_status') ?? false;
    'number=$number'.log();
    // device
    bool device = prefs.getBool('ms_fk_decvice_status') ?? false;
    'device=$device'.log();
    if (behavior || number || device){
      return true;
    }
    return false;
  }

  // 获取用户异常行为状态
  Future<bool> ms_checkUser() async {
    // 开关未打开
    if(fkModel.ui.behavior == 0){
      return false;
    }
    final prefs = await SharedPreferences.getInstance();
    'MSLocalProvider.instance.ms_fk_ad_short_show2 = ${MSLocalProvider.instance.ms_fk_ad_short_show}'.log();
    // 两次rv间隔时间小于30s，3次以上
    if(prefs.getBool('ms_fk_ad_short_show') == true){
      return true;
    }
    // RV 从播放到收到关闭回调时间小于20s，3次以上
    if(prefs.getBool('ms_fk_ad_short_close') == true){
      return true;
    }
    // //现金金额达到提现门槛,视频数少于3次
    if((prefs.getInt('ms_ad_all_number') ?? 0) < fkModel.behavior.wrong_deem_ad_less && (prefs.getInt('ms_dolas_old_number') ?? 0) >= 1000){
      ms_event_fire('risk_chance', {'risk_from' : 'wrong_deem_ad_less'});
      return true;
    }
    // 用户观看90次RV(不包含插屏)，未到提现门槛
    if((prefs.getInt('ms_ad_reawrd_all_number') ?? 0) >= fkModel.behavior.wrong_deem_ad_more && (prefs.getInt('ms_dolas_old_number') ?? 0) < 1000){
      ms_event_fire('risk_chance', {'risk_from' : 'wrong_deem_ad_more'});
      return true;
    }
    return false;
  }

 // 数字联盟
  ms_checkNum()async{
    var numberUnitID = await MegascratchFK.instance.ms_getNumberUnitID();
    var url = Uri.parse('https://sg-ddi.shuzilm.cn/q');
    try {
      var response = await http.post(
        url,
        headers: eventHeader,
        body: jsonEncode({"protocol":2,"pkg":await FlutterTbaInfo.instance.getBundleId(),"did":numberUnitID}),
      );
      print("upload event [Number] success ${response.body}");

      try{
        // {"protocol":2,"ver":"1.0.1","err":0,"device_type":0,"normal_times":0,
        // "duplicate_times":0,"update_times":1,"recall_times":0}
        var json = jsonDecode(response.body);
        if(json["err"] == 0 && json["device_type"] != 0 && fkModel.ui.number == 1){
          ms_event_fire('risk_chance', {'risk_from' : 'number'});
          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_fk_number_statusName,true);
        }else{
          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_fk_number_statusName,false);
        }
      }catch(e){
        await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_fk_number_statusName,false);
      }

    } catch (e) {
      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_fk_number_statusName,false);
      "upload event [Number] faild".log();
    }

  }

  Map<String, String> eventHeader = {
    'Content-Type': 'application/json',
  };

  // 设备 Ip
  ms_checkIP()async{

    var url = Uri.parse('https://ip-prod.luckyscratchgame.com/api/cfish');
    try {
      var response = await http.post(
        url,
        headers: eventHeader,
        body: jsonEncode({
          "asnake" : await FlutterTbaInfo.instance.getAndroidId(),
        }),
      );
      print("upload event [IP] success ${response.body}");
      //{"code":200,"msg":"Success","data":{"blion":false}}
      var result = BoomUniqueStringUtil.decrypt(response.body, 34);
      print("upload event [IP] success ${result}");
      try{
        var bbear = jsonDecode(result)["data"]["bbear"];
        if(bbear && fkModel.device.contains('ip') && fkModel.ui.device == 1){
          ms_event_fire('risk_chance', {'risk_from' : 'ip'});
          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_fk_ip_statusName,true);
        }
      }catch(e){
        await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_fk_ip_statusName,false);
      }

    } catch (e) {
      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_fk_ip_statusName,false);
      "upload event [IP] faild".log();
    }
  }

  ms_add_tabsession_custom() async {

    bool root = await ms_checkRoot();
    bool vpn = await ms_checkVpn();
    bool sim = await ms_checkSim();
    bool simulator = await ms_checkSimulator();
    bool developer = await ms_checkDeveloper();
    bool googleplay = await ms_checkStore();
    Map<String, dynamic> customer = {
      'root' : root ? 1 : 0,
      'vpn' : vpn ? 1 : 0,
      'sim' : sim ? 1 : 0,
      'simulator' : simulator ? 1 : 0,
      'developer' : developer ? 1 : 0,
      'googleplay' : googleplay ? 1 : 0,
    };
    ms_event_fire('session_custom', customer);

  }

  Future<bool> ms_checkRoot() async {
    var result = await MegascratchFK.instance.ms_root();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(result && fkModel.device.contains('root')){
      ms_event_fire('risk_chance', {'risk_from' : 'root'});
      MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }

  Future<bool> ms_checkVpn() async {
    var result = await MegascratchFK.instance.ms_vpn();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(result && fkModel.device.contains('vpn')){
      ms_event_fire('risk_chance', {'risk_from' : 'vpn'});
      MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }

  Future<bool> ms_checkSim() async {
    var result = await MegascratchFK.instance.ms_sim();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(!result && fkModel.device.contains('sim')){
      ms_event_fire('risk_chance', {'risk_from' : 'sim'});
      MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }

  Future<bool> ms_checkSimulator() async {
    var result = await MegascratchFK.instance.ms_simulator();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(result && fkModel.device.contains('simulator')){
      ms_event_fire('risk_chance', {'risk_from' : 'simulator'});
      MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }

  Future<bool> ms_checkDeveloper() async {
    var result = await MegascratchFK.instance.ms_developer();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(result && fkModel.device.contains('developer')){
      ms_event_fire('risk_chance', {'risk_from' : 'developer'});
      MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }

  Future<bool> ms_checkStore() async {
    var result = await MegascratchFK.instance.ms_store();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(!result && fkModel.device.contains('googleplay')){
      ms_event_fire('risk_chance', {'risk_from' : 'googleplay'});
      MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }
}