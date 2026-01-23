import 'package:flutter_lifecycle_detector/flutter_lifecycle_detector.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import '../MSDialog/MSDialog.dart';
import '../MSHome/MSTbabar.dart';
import 'ms_ad_manger.dart';
import 'ms_extension_help.dart';
import '../main.dart';
import 'ms_LocalProvider.dart';
import 'ms_TBAInfoTool.dart';
import 'ms_fkmanger.dart';
import 'ms_mp3_player.dart';
import 'ms_LocalProvider.dart';


class MSNoticeHelp {

  static final MSNoticeHelp _instance = MSNoticeHelp._internal();

  factory MSNoticeHelp() {
    return _instance;
  }

  MSNoticeHelp._internal();

  Future<void> initNotice() async {

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ms_logo'); // 不加 .png

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        'nf click response:${response}'.log();
        final String? payload = response.payload;
        ms_event_fire('inform_c', {'type': payload ?? ''});
        if(payload == null)return;
      },
    );

    NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await AndroidFlutterLocalNotificationsPlugin()
        .getNotificationAppLaunchDetails();
    '=initNotification====getNotificationAppLaunchDetails==notificationAppLaunchDetails:$notificationAppLaunchDetails='.log();

    if (notificationAppLaunchDetails != null) {
      NotificationResponse? notificationResponse =
          notificationAppLaunchDetails.notificationResponse;
      bool didNotificationLaunchApp =
          notificationAppLaunchDetails.didNotificationLaunchApp ?? false;
      if (didNotificationLaunchApp) {
        ms_event_fire('inform_c', {'type': notificationResponse?.payload ?? ''});
      }
    }

    var nfPermission = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    if(nfPermission??false){
      ms_event_fire('push_status', {});
    }else{
      "nf no permission".log();
      if (MSLocalProvider.instance.ms_show_notice_status == false){
        await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_show_notice_statusName, true);
        root_navigatorKey.currentState?.context.tipShow(MSNoticeDialog());
      }
    }
    "nf has permission".log();
    _initLifecycleListener();
    _repeatNotification1();
    _repeatNotification2();
    _repeatNotification3();
    _repeatNotification4();
    _subscribeFcmTopic();
    // _subscribeFcmTopic2();
    _showUnlockNotification();
    _msinitNotificationCount();
  }

  Future<bool> getNoticeStatus() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    bool status = false;
    var nfPermission = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    if(nfPermission??false){
      status = true;
    }else{
      status = false;
    }
    return status;
  }

  _msinitNotificationCount() async {
    try {
      int locals = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("noti1");
      "==initNotificationCount==localcount:$locals==".log();
      if (locals > 0) {
        for (int i = 0; i < locals; i++) {
          ms_event_fire('push', {'type' : "noti1"});
        }
      }
      int locals2 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("noti2");
      "==initNotificationCount==localcount:$locals2==".log();
      if (locals2 > 0) {
        for (int i = 0; i < locals2; i++) {
          ms_event_fire('push', {'type' : "noti2"});
        }
      }
      int locals3 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("noti3");
      "==initNotificationCount==localcount:$locals3==".log();
      if (locals3 > 0) {
        for (int i = 0; i < locals3; i++) {
          ms_event_fire('push', {'type' : "noti3"});
        }
      }
      int locals4 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("noti4");
      "==initNotificationCount==localcount:$locals4==".log();
      if (locals4 > 0) {
        for (int i = 0; i < locals4; i++) {
          ms_event_fire('push', {'type' : "noti4"});
        }
      }
      int fcms = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("fcm");
      "==initNotificationCount==localcount:$fcms==".log();
      if (fcms > 0) {
        for (int i = 0; i < fcms; i++) {
          ms_event_fire('push', {'type' : "fcm"});
        }
      }

      int unlocks = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("unlock");
      "==initNotificationCount==localcount:$unlocks==".log();
      if (unlocks > 0) {
        for (int i = 0; i < unlocks; i++) {
          ms_event_fire('push', {'type' : "unlock"});
        }
      }

      int foreground = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("foreground");
      "==initNotificationCount==localcount:$foreground==".log();
      if (foreground > 0) {
        for (int i = 0; i < foreground; i++) {
          ms_event_fire('push', {'type' : "foreground"});
        }
      }

    } catch (e) {
      "===initNotificationCount==error:$e=".log();
    }
  }

  Future<void> setNoticeStatus() async {

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var nfPermission = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    if(nfPermission??false){
      ms_event_fire('push_status', {});
    }else{
      "nf no permission".log();
    }

  }

  Future<void> _repeatNotification1() async {
    //自定义通知ID
    final int id = 1125;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '140notice1',
      'MegaScractch1',
      styleInformation: BeautyStyleInformation(
        title: title,
        body:body,
        image:'ms_notice_big',
        button:'Withdraw',
        appIcon:'ms_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'ms_sm_logo',
      //“groupKey”：防止通知被系统折叠
      groupKey: "$id",
    );
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        const Duration(minutes: 23),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "noti1"
    );
  }

  Future<void> _repeatNotification2() async {
    //自定义通知ID
    final int id = 1458;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '140notice2',
      'MegaScractch2',
      styleInformation: BeautyStyleInformation(
        title: title,
        body:body,
        image:'ms_notice_big',
        button:'Withdraw',
        appIcon:'ms_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'ms_sm_logo',
      //“groupKey”：防止通知被系统折叠
      groupKey: "$id",
    );
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        const Duration(minutes: 49),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "noti2"
    );
  }

  Future<void> _repeatNotification3() async {
    //自定义通知ID
    final int id = 1895;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '140notice3',
      'MegaScractch3',
      styleInformation: BeautyStyleInformation(
        title: title,
        body:body,
        image:'ms_notice_big',
        button:'Withdraw',
        appIcon:'ms_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'ms_sm_logo',
      //“groupKey”：防止通知被系统折叠
      groupKey: "$id",
    );
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        const Duration(minutes: 61),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "noti3"
    );
  }

  Future<void> _repeatNotification4() async {
    //自定义通知ID
    final int id = 1591;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '140notice4',
      'MegaScractch4',
      styleInformation: BeautyStyleInformation(
        title: title,
        body:body,
        image:'ms_notice_big',
        button:'Withdraw',
        appIcon:'ms_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'ms_sm_logo',
      //“groupKey”：防止通知被系统折叠
      groupKey: "$id",
    );
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        const Duration(minutes: 30),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "noti4"
    );
  }

  Future<void> _subscribeFcmTopic() async {
    await AndroidFlutterLocalNotificationsPlugin().subscribeToTopic(
      'c140-d4533',
       AndroidNotificationDetails(
        'c140-d4533',
        'MegaScractch',
        styleInformation: BeautyStyleInformation(
          title: '',
          body:'',
          image:'',
          button:'Withdraw',
          appIcon:'ms_logo',
        ),
        priority: Priority.high,
        importance: Importance.high,
         icon: 'ms_sm_logo',
      ),
    );
  }

  Future<void> _subscribeFcmTopic2() async {
    await AndroidFlutterLocalNotificationsPlugin().subscribeToTopic(
      '',
      AndroidNotificationDetails(
        '',
        'MegaScractch2',
        styleInformation: BeautyStyleInformation(
          title: '',
          body:'',
          image:'',
          button:'Withdraw',
          appIcon:'ms_logo',
        ),
        priority: Priority.high,
        importance: Importance.high,
        icon: 'ms_sm_logo',
      ),
    );
  }

  Future<void> _showUnlockNotification() async {
    //自定义通知ID
    final int ids = 5713;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    StepMotivation randomMotivation2 = StepMotivationManager.getRandomMotivation();;
    await AndroidFlutterLocalNotificationsPlugin().showBroadcastNotification(
      ids,
      randomMotivation.title,
      randomMotivation.body,
      //两次发送解锁通知的间隔，根据需求设置
      const Duration(seconds: 30),
    'android.intent.action.USER_PRESENT',
       AndroidNotificationDetails(
        '140MegaScractch',
        'MegasScractchs',
        priority: Priority.high,
        importance: Importance.high,
         icon: 'ms_sm_logo',
        styleInformation: BeautyStyleInformation(
          title: randomMotivation2.title,
          body:randomMotivation2.body,
          image:'ms_notice_big',
          button:'Withdraw',
          appIcon:'ms_logo',
        ),
        //“groupKey”：防止通知被系统折叠
        groupKey: "$ids",
      ),
      'unlock',
    );
  }
  // 前台服务
  Future<void> startForegroundService() async {
    //自定义通知ID
    final int id = 1;
    final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        '140Foreground',
        'MegaScratch',
        ongoing: true,
        styleInformation: ForegroundStyleInformation(value: 'Current user balance:\$${MSLocalProvider.instance.ms_dolas_number}')
    );
    await AndroidFlutterLocalNotificationsPlugin().startForegroundService(id, '', '',
        notificationDetails: androidNotificationDetails, payload: 'foreground');
  }


  Future<void> _initLifecycleListener() async {

    FlutterLifecycleDetector().onBackgroundChange.listen((isBackground) async {
      /// `isBackground` is true => background
      /// `isBackground` is false => foreground
      print('Status background $isBackground');
      if (isBackground == true) {
        print('App进入后台');
        MSAudioUtils().pauseBGM();
        MSFKManger().ms_add_tabsession_custom();
        // 执行后台逻辑
        ms_session_fire();
        ms_event_fire('session_back_get', {'"pak_version' : MSLocalProvider.instance.ms_login_status ? 1 : 0});
      } else {
        print('App进入前台');
        if (MSLocalProvider.instance.ms_bg_music && !MSMegaAds().someAdIsShowing()){
          MSAudioUtils().playBGM();
        }
        MSFKManger().ms_add_tabsession_custom();
        ms_event_fire('session_front_get', {'"pak_version' : MSLocalProvider.instance.ms_login_status ? 1 : 0});
        // 执行前台逻辑
        ms_session_fire();
        MSMegaAds().ms_showAd(root_navigatorKey.currentContext!, 'pppuz_launch', onCacheResponse: (onCacheResponse){
          ms_event_fire('event_launch_non_first', {'device_id' : '${FlutterTbaInfo.instance.getDistinctId()}','system' : 'Android', 'ad_impression' : 0});
        }, adDidClosed: (adDidClosed){
          ms_event_fire('event_launch_non_first', {'device_id' : '${FlutterTbaInfo.instance.getDistinctId()}','system' : 'Android', 'ad_impression' : 1});
        });
      }
    });
  }

}
/// 激励文案数据模型
class StepMotivation {
  final String title;
  final String body;

  StepMotivation({
    required this.title,
    required this.body,
  });
}

/// 激励文案工具类
class StepMotivationManager {
  // 文案数据列表
  static final List<StepMotivation> _motivations = [
    StepMotivation(
      title: "Scratch to Earn Cash！",
      body: 'Open App → Split the prize pool & cash out instantly!',
    ),
    StepMotivation(
      title: "Scratch to Earn Cash！",
      body: "Split \$10,000 prize pool! Cash out when you win!",
    ),
    StepMotivation(
      title: "Cash-Out So Close！",
      body: "Scratch 1 more card → Win \$50 in one go! Tap to check!",
    ),
    StepMotivation(
      title: "Cash-Out So Close！",
      body: "Scratch more, Earn more!",
    ),
    StepMotivation(
      title: "Cash Out Pending",
      body: "You have \$1,000 waiting! Tap to claim to PayPal!",
    ),
    StepMotivation(
      title: "You Can Cash Out!",
      body: "Balance over \$1,000! Tap here to cash out & turn earnings into REAL CASH!",
    ),
    StepMotivation(
      title: "Daily Cash Reward",
      body: "Open App → Claim Cash Now!",
    ),
    StepMotivation(
      title: "Cash Out Successful!",
      body: "Cash out processed! Tap to check your PayPal balance!",
    ),
    StepMotivation(
      title: "Next Scratch = More Cash!",
      body: "Hurry! 00:59 left → Play now & cash out bigger rewards!",
    ),
    StepMotivation(
      title: "Double Cash in Next Game!",
      body: "Countdown: 01:29 → Open App, scratch & cash out more!",
    ),
    StepMotivation(
      title: "Bigger Wins Await! Hurry!",
      body: "00:45 left → Play next scratch, earn more & cash out fast!",
    ),
    StepMotivation(
      title: "Last Chance for Extra Cash!",
      body: "00:19 left → Next scratch = bigger rewards! Cash out soon!",
    ),
    StepMotivation(
      title: "Play Scratch for Cash!",
      body: "Scratch cards → Earn & cash out big!",
    ),
  ];

  /// 随机获取一条激励文案
  static StepMotivation getRandomMotivation() {
    final random = DateTime.now().microsecond % _motivations.length;
    return _motivations[random];
  }

}