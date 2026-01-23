import 'dart:convert';
import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lifecycle_detector/flutter_lifecycle_detector.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../MSModel/MSAdModel.dart';
import '../MSModel/MSCardNumberModel.dart';
import '../MSModel/MSFkModel.dart';
import '../MSModel/MSIntRatioModel.dart';
import 'ms_AdAHelp.dart';
import 'ms_LocalProvider.dart';
import 'ms_NumberHelper.dart';
import 'ms_TBAInfoTool.dart';
import 'ms_ad_manger.dart';
import 'ms_extension_help.dart';
import 'ms_fkmanger.dart';
import 'ms_mp3_player.dart';

String decsgerew(String st) => utf8.decode(base64Decode(st));

class MSSDKHelpers {
  static final MSSDKHelpers _instance = MSSDKHelpers._internal();

  factory MSSDKHelpers() {
    return _instance;
  }

  final facebookAppEvents = FacebookAppEvents();

  MSSDKHelpers._internal();

  DateTime ms_max_start = DateTime.now();

  DateTime ms_topon_start = DateTime.now();

  int ms_remoteConfigTryCount = 0;

  String _daydateString = '';

  Future<void> initSDK() async {
    _initAppMAX();
    ms_getSBUserCloakConfig();
    _msinitloadFireBase();
  }


  Future<void> _initAppMAX() async {
    // ump设置
    AppLovinMAX.setHasUserConsent(true);
    AppLovinMAX.setDoNotSell(false);

    AppLovinMAX.setCreativeDebuggerEnabled(false);
    AppLovinMAX.setVerboseLogging(false);
    "${decsgerew("TVdKemhuRVB0S3F4TEtSTEFsVnJUeVFmTw==")}"
        "${decsgerew("MlZ4V1pXdFZ4X1N6VFdDX01nb1pMN2tUS050OXQzTV9PZ0laMjRuQlhSWHhWZDlvZ1FFcDc2MTZUV2YzQw==")}"
        .log();
    ms_max_start = DateTime.now();
    MaxConfiguration? configuration = await AppLovinMAX.initialize(
      "${decsgerew("TVdKemhuRVB0S3F4TEtSTEFsVnJUeVFmTw==")}"
          "${decsgerew("MlZ4V1pXdFZ4X1N6VFdDX01nb1pMN2tUS050OXQzTV9PZ0laMjRuQlhSWHhWZDlvZ1FFcDc2MTZUV2YzQw==")}",
    );
    // AppLovinMAX.showMediationDebugger();
    //
    if (configuration != null) {
      ms_event_fire('pppuz_ad_initsuc', {
        'ad_platform' : 'max',
        'ad_init_time' : DateTime.now().difference(ms_max_start).inMilliseconds
      });
      MSAdAHelper().initRewardAdDatasource();
      MSMegaAds().init();
    }
  }

  Future<void> ms_setConfigDateInfoData() async {
    // text
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _daydateString = prefs.getString('sj_day_date') ?? '';
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(today);
    prefs.setBool('sj_old_guide', true);
    if (_daydateString == '') {
      prefs.setString('sj_day_date', formattedDate);
      // 首次
      prefs.setBool('sj_first_instll', true);
    } else {
      if (_daydateString != formattedDate) {
        // 隔天
        prefs.setString('sj_day_date', formattedDate);
        prefs.setBool('sj_old_guide', false);
      }
    }
    MSLocalProvider.instance.init();
  }

  void ms_getSBUserCloakConfig() async {
    try {
      _initAdjust();
      var responseData = await MSRequestHelpers().getCloak();
      print('MegaScatch Config Result: $responseData');
      ms_event_fire("cloak_req", {});
      ms_event_fire("cloak_suc", {
        "cloak_user": responseData.toString() == "control" ? 1 : 0,
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('sp_install_status') == null){
        '1111111'.log();
        ms_event_fire('event_launch_first', {'device_id' : '${FlutterTbaInfo.instance.getDistinctId()}','system' : 'Android'});
        ms_install_fire();
        prefs.setBool('sp_install_status', true);
      }
      MSFKManger().ms_add_tabsession_custom();
      ms_session_fire();
      MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_cloak_statusName, responseData.toString() == "control" ? true : false);
    } catch (e) {
      print('MegaScatch Request Error: $e');
      Future.delayed(Duration(seconds: 1), () {
        ms_getSBUserCloakConfig();
      });
    }
  }

  _initAdjust() async {
    // text  4qedga65udq8
    // relese  y16s0qkymcqo
    const String appToken1 = '4qedga65udq8'; // relsease
    var disId = await FlutterTbaInfo.instance.getDistinctId();
    'disId=$disId'.log();
    Adjust.addGlobalCallbackParameter('customer_user_id', disId);
    final config = AdjustConfig(appToken1, AdjustEnvironment.production);
    // 归因信息
    config.attributionCallback = (AdjustAttribution attributionChangedData) {
      print('[Adjust]: Attribution changed!');
      if (attributionChangedData.trackerToken != null) {
        print('[Adjust]: Tracker token: ${attributionChangedData.trackerToken}');
      }
      if (attributionChangedData.trackerName != null) {
        ms_event_fire('adjust_suc', {'adjust_user' : attributionChangedData.trackerName == 'Organic' ? 0 : 1});
        print('[Adjust]: Tracker name: ${attributionChangedData.trackerName}');
      }
      if (attributionChangedData.campaign != null) {
        print('[Adjust]: Campaign: ${attributionChangedData.campaign}');
      }
      if (attributionChangedData.network != null) {
        print('[Adjust]: Network: ${attributionChangedData.network}');
      }
      if (attributionChangedData.creative != null) {
        print('[Adjust]: Creative: ${attributionChangedData.creative}');
      }
      if (attributionChangedData.adgroup != null) {
        print('[Adjust]: Adgroup: ${attributionChangedData.adgroup}');
      }
      if (attributionChangedData.clickLabel != null) {
        print('[Adjust]: Click label: ${attributionChangedData.clickLabel}');
      }
      if (attributionChangedData.fbInstallReferrer != null) {
        print('[Adjust]: facebook install referrer: ${attributionChangedData.fbInstallReferrer}');
      }
      if (attributionChangedData.jsonResponse != null) {
        print('[Adjust]: JSON Response: ${attributionChangedData.jsonResponse}');
      }
    };
    Adjust.initSdk(config);
    ms_event_fire('adjust_req', {});
  }

  void _msinitloadFireBase() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    "app firebase init".log();
    "app firebase loading".log();
    try {
      await remoteConfig.fetchAndActivate();

      final pppuz_ad_config =
      remoteConfig.getValue("pppuz_ad_config").asString();
      'pppuz_ad_config=$pppuz_ad_config'.log();
      // ad
      if (pppuz_ad_config != ''){
        try {
          Map<String, dynamic> jsonMap = json.decode(pppuz_ad_config);
          var adEntity = MSAdModel.fromJson(jsonMap);
          MSMegaAds().init(inputAd: adEntity);
          "app firebase remoteconfig pppuz_ad_config data ${jsonMap}".log();
        } catch (error) {
          print("app firebase remoteconfig pppuz_ad_config error ${error}");
        }
      }
      // risk_control
      // final risk_control = remoteConfig.getValue('risk_control').asString();
      // if (risk_control != ''){
      //   try {
      //     Map<String, dynamic> jsonMap = json.decode(risk_control);
      //     var fkEntity = MSFkModel.fromJson(jsonMap);
      //     MSFKManger().fkModel = fkEntity;
      //     "app firebase remoteconfig risk_control data ${jsonMap}".log();
      //   } catch (error) {
      //     print("app firebase remoteconfig risk_control error ${error}");
      //   }
      // }

      // 插屏概率
      final ad =
      remoteConfig.getValue("ad").asString();
      'ad=$pppuz_ad_config'.log();
      // ad
      if (ad != ''){
        try {
          Map<String, dynamic> jsonMap = json.decode(ad);
          var ad_int_model = MSResponseModel.fromJson(jsonMap);
          MSMegaAds().ad_int_model = ad_int_model;
          'ad_int_model=${ad_int_model.intad_point.length}'.log();
          "app firebase remoteconfig ad data ${jsonMap}".log();
        } catch (error) {
          print("app firebase remoteconfig ad error ${error}");
        }
      }

      final task =
      remoteConfig.getValue("task").asString();
      'task=$task'.log();
      // task
      if (task != ''){
        try {
          Map<String, dynamic> jsonMap = json.decode(task);
          var taskEntity = MSCardNumberModel.fromJson(jsonMap);
          MSNumberAHelper().numberBEntry = taskEntity;
          "app firebase remoteconfig task data ${jsonMap}".log();
        } catch (error) {
          print("app firebase remoteconfig task error ${error}");
        }
      }

    } catch (e, s) {
      print("RemoteConfig fetch error: $e");
      ms_remoteConfigTryCount += 1;
      if (ms_remoteConfigTryCount <= 60) {
        Future.delayed(Duration(seconds: 1), () {
          _msinitloadFireBase();
        });
      } else {
        MSMegaAds().init();
      }
    }
  }


}

