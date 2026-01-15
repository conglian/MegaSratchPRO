import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:http/http.dart' as http;
import 'ms_extension_help.dart';


void ms_session_fire() async {
  var baseBody = await MSRequestHelpers().baseBody();
  baseBody["conakry"] = {};
  MSRequestHelpers().post(baseBody, 2);
}

void ms_ad_fire(Map<String, dynamic> body) async {
  var baseBody = await MSRequestHelpers().baseBody();
  baseBody["blanch"] = 'twilight';
  for (String key in body.keys){
    baseBody['$key'] = body[key];
  }
  MSRequestHelpers().post(baseBody, 3);
}

void ms_event_fire(String name, Map<String, dynamic> body) async {
  var baseBodys = await MSRequestHelpers().baseBody();
  baseBodys["blanch"] = name;
  baseBodys[name] = body;
  MSRequestHelpers().post(baseBodys, 0);
}

void ms_install_fire() async {
  var baseBody = await MSRequestHelpers().baseBody();
  var map = await FlutterTbaInfo.instance.getReferrerMap();
  Map<String, dynamic> leibniz = {
    'porcine' : map['build'],
    'well' : map['referrer_url'],
    'inequity' : map['install_version'],
    'absentia' : map['user_agent'],
    'bonfire' : 'estrous',
    'turbofan' : map['referrer_click_timestamp_seconds'],
    'nascent' : map['install_begin_timestamp_seconds'],
    'groom' : map['referrer_click_timestamp_server_seconds'],
    'befog' : map['install_begin_timestamp_server_seconds'],
    'terse' : map['install_first_seconds'],
    'lombardy' : map['last_update_seconds'],
  };
  for (String key in leibniz.keys){
    baseBody['$key'] = leibniz[key];
  }
  baseBody["blanch"] = 'cinch';
  MSRequestHelpers().post(baseBody, 1);
}

class MSRequestHelpers {
  static final MSRequestHelpers _instance = MSRequestHelpers._internal();

  factory MSRequestHelpers() {
    return _instance;
  }

  MSRequestHelpers._internal();

  static String cloak_Url =
      "https://lena.luckyscratchgame.com/divisive/stacy";

  static String tba_event_Url =
      "https://test-filter.luckyscratchgame.com/cannel/cutback";

  // static String tba_event_Url =
  //     "https://filter.luckyscratchgame.com/ridicule/ripen/heyday";

  final Map<String, String> normalHeader = {
    'Content-Type': 'application/json',
  };

  Map<String, String> eventHeader = {
    'Content-Type': 'application/json',
  };

  Future<dynamic> getCloak() async {
    var url = Uri.parse("${cloak_Url}?${await getConfigQueryString()}");
    "scratch play land config request ${url}".log();
    try {
      var response = await http.get(
        url,
        headers: normalHeader,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform GET request: $e');
    }
  }

  Future<dynamic> post(dynamic data, int type) async {
    var eventName = "";
    if (type == 0) {
      eventName = "event";
    } else if (type == 1) {
      eventName = "install";
    } else if (type == 2) {
      eventName = "session";
    } else {
      eventName = "ad";
    }
    var url = Uri.parse(
        "${tba_event_Url}");
    "upload event [${eventName}] url ${url} \n ${data}".log();
    try {
      var response = await http.post(
        url,
        headers: eventHeader,
        body: jsonEncode(data),
      );
      print("upload event [${eventName}] success ${response.body}");
      // "upload event [${eventName}] success ${response.body}".log();
      return _handleResponse(response);
    } catch (e) {
      "upload event [${eventName}] faild error $e".log();
      // throw Exception('Failed to perform POST request: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  void _refreshHeader() async {
    eventHeader = {
      'Content-Type': 'application/json',
    };
  }

  void init() {
    _refreshHeader();
  }


}
// request parmerters
extension RequestHelpersExtension on MSRequestHelpers {
  Future<String> getConfigQueryString() async {
    var queryBody = {
      "loyal": await FlutterTbaInfo.instance.getBundleId(),
      "detach": 'hinman',
      "oakley": await FlutterTbaInfo.instance.getAppVersion(),
    };
    return Uri(queryParameters: queryBody).query;
  }

  Future<Map<String, dynamic>> baseBody() async {
    Map<String, dynamic> baseBody = {};
    Map<String, dynamic> genuine = {
      'licensor' : await FlutterTbaInfo.instance.getBrand(),
      'soy' : await FlutterTbaInfo.instance.getOsCountry(),
      'soutane' : await FlutterTbaInfo.instance.getDistinctId(),
      'detach' : 'hinman',
      "millet": await FlutterTbaInfo.instance.getLogId(),
      'else' : await FlutterTbaInfo.instance.getManufacturer(),
      "ember": await FlutterTbaInfo.instance.getNetworkType(),
      'pleat' : await FlutterTbaInfo.instance.getOsVersion(),
      "hay": await FlutterTbaInfo.instance.getGaid(),
      'naacp' : await FlutterTbaInfo.instance.getSystemLanguage(),
      "paste": await FlutterTbaInfo.instance.getOperator(),
      'rudolph' : await FlutterTbaInfo.instance.getAndroidId(),
      'oakley' : await FlutterTbaInfo.instance.getAppVersion(),
      'trw' : DateTime.now().millisecondsSinceEpoch,
      "loyal": await FlutterTbaInfo.instance.getBundleId(),
      "kenton": await FlutterTbaInfo.instance.getDeviceModel(),
    };
    for (String key in genuine.keys){
      baseBody['$key'] = genuine[key];
    }
    return baseBody;
  }

}