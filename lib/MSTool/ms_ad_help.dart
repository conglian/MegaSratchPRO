import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ms_extension_help.dart';

class MSAdHelpers {
  static final MSAdHelpers _instance = MSAdHelpers._internal();

  factory MSAdHelpers() {
    return _instance;
  }

  MSAdHelpers._internal();

  // MSAdModel? ad_Entity;

  Future<void> initAd() async {
    await _msloadAdDataFromLocate();
  }

  Future<void> _msloadAdDataFromLocate() async {
      String jsonString = await rootBundle.loadString("scxji_ad_config".jsons());
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      // ad_Entity = SJAdModel.fromJson(jsonMap);
    // "MegaScratch ad json = ${ad_Entity}".log();
  }

}