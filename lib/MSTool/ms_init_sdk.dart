import 'dart:convert';
import 'package:applovin_max/applovin_max.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lifecycle_detector/flutter_lifecycle_detector.dart';
import 'ms_AdAHelp.dart';
import 'ms_LocalProvider.dart';
import 'ms_extension_help.dart';
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

  Future<void> initSDK() async {
    // _initAppMAX();
    _initLifecycleListener();
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
      MSAdAHelper().initRewardAdDatasource();
    }
  }


  Future<void> _initLifecycleListener() async {

    FlutterLifecycleDetector().onBackgroundChange.listen((isBackground) async {
      /// `isBackground` is true => background
      /// `isBackground` is false => foreground
      print('Status background $isBackground');
      if (isBackground == true) {
        print('App进入后台');
        MSMP3Player().pauseBackground();
        // 执行后台逻辑
      } else {
        print('App进入前台');
        if (MSLocalProvider.instance.ms_bg_music){
          MSMP3Player().playBackground();
        }
      }
    });
  }

  initAdjust() async {
    // const String appToken1 = '1dqdrosdaw74'; // relsease
    // var disId = await FlutterTbaInfo.instance.getDistinctId();
    // 'disId=$disId'.log();
    // Adjust.addGlobalCallbackParameter('customer_user_id', disId);
    // final config = AdjustConfig(appToken1, AdjustEnvironment.production);
    // // 归因信息
    // config.attributionCallback = (AdjustAttribution attributionChangedData) {
    //   print('[Adjust]: Attribution changed!');
    //   if (attributionChangedData.trackerToken != null) {
    //     print('[Adjust]: Tracker token: ${attributionChangedData.trackerToken}');
    //   }
    //   if (attributionChangedData.trackerName != null) {
    //     sj_event_fire('adjust_suc', {'adjust_user' : attributionChangedData.trackerName == 'Organic' ? 0 : 1});
    //     print('[Adjust]: Tracker name: ${attributionChangedData.trackerName}');
    //   }
    //   if (attributionChangedData.campaign != null) {
    //     print('[Adjust]: Campaign: ${attributionChangedData.campaign}');
    //   }
    //   if (attributionChangedData.network != null) {
    //     print('[Adjust]: Network: ${attributionChangedData.network}');
    //   }
    //   if (attributionChangedData.creative != null) {
    //     print('[Adjust]: Creative: ${attributionChangedData.creative}');
    //   }
    //   if (attributionChangedData.adgroup != null) {
    //     print('[Adjust]: Adgroup: ${attributionChangedData.adgroup}');
    //   }
    //   if (attributionChangedData.clickLabel != null) {
    //     print('[Adjust]: Click label: ${attributionChangedData.clickLabel}');
    //   }
    //   if (attributionChangedData.fbInstallReferrer != null) {
    //     print('[Adjust]: facebook install referrer: ${attributionChangedData.fbInstallReferrer}');
    //   }
    //   if (attributionChangedData.jsonResponse != null) {
    //     print('[Adjust]: JSON Response: ${attributionChangedData.jsonResponse}');
    //   }
    // };
    // Adjust.initSdk(config);
    // ms_event_fire('adjust_req', {});
  }


}

