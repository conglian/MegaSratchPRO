import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:megascratch/MSTool/ms_LocalProvider.dart';
import 'package:megascratch/MSTool/ms_text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../MSTool/ms_NoticeTool.dart';
import '../MSTool/ms_TBAInfoTool.dart';
import '../MSTool/ms_ad_manger.dart';
import '../MSTool/ms_extension_help.dart';
import '../MSTool/ms_fkmanger.dart';
import '../MSTool/ms_img.dart';
import '../main.dart';
import 'MSHome.dart';
import 'MSScrachWeCome.dart';
import 'MSTbabar.dart';


class MSSratchJoyLaunch extends StatefulWidget {
  MSSratchJoyLaunch({super.key});
  @override
  State<MSSratchJoyLaunch> createState() => MSSratchJoyLaunchState();
}

class MSSratchJoyLaunchState extends State<MSSratchJoyLaunch>  with SingleTickerProviderStateMixin {

  var _daydateString = '';

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    ms_setConfigDateInfoData();
    MSNoticeHelp().setNoticeStatus();
    ms_event_fire('launch_page', {});
  }

  Future<void> ms_setConfigDateInfoData() async {
    // text
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _daydateString = prefs.getString('ms_day_date') ?? '';
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(today);
    prefs.setBool('ms_old_guide', true);
    if (_daydateString == '') {
      prefs.setString('ms_day_date', formattedDate);
      // 首次
      prefs.setBool('ms_first_instll', true);

      prefs.setInt('ms_tx_num_index', Random().nextInt(500) + 500);
    } else {
      if (_daydateString != formattedDate) {
        // 隔天
        prefs.setString('ms_day_date', formattedDate);
        prefs.setBool('ms_old_guide', false);
        prefs.setBool('ms_today_sign_show', false);
        prefs.setBool('ms_today_sign_status', false);
        prefs.setInt('ms_today_card_index', 0);
        prefs.setInt('ms_tx_card_index', 0);
        prefs.setInt('ms_tx_num_index', Random().nextInt(500) + 500);
      }
    }
    MSLocalProvider.instance.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack (
        children: [
          MSImg(name: 'ms_luanchs_bg', width: 0.width(context), height: 0.height(context)),
          Column(
            children: [
              SizedBox(height: 40.h,),
              MSImg(name: 'ms_luanchs_titles', width: 375, height: 309,),
              Spacer(),
              SJGradientProgressBar(onCompleted: (){
                if (MSLocalProvider.instance.ms_first_session == true){
                  MSMegaAds().ms_showAd(root_navigatorKey.currentContext!, 'pppuz_launch',showDialog: false, onCacheResponse: (onCacheResponse){
                    ms_event_fire('event_launch_non_first', {'device_id' : '${FlutterTbaInfo.instance.getDistinctId()}','system' : 'Android', 'ad_impression' : 0});
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MSBottomNavigationExample(key: MSNavigationService().bottomNavKey),
                      ),
                    );
                  }, adDidClosed: (adDidClosed){
                    ms_event_fire('event_launch_non_first', {'device_id' : '${FlutterTbaInfo.instance.getDistinctId()}','system' : 'Android', 'ad_impression' : 1});
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MSBottomNavigationExample(key: MSNavigationService().bottomNavKey),
                      ),
                    );
                  });
                } else {
                  MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_first_sessionName, true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MSBottomNavigationExample(key: MSNavigationService().bottomNavKey),
                    ),
                  );
                }
              },),
              SizedBox(height: 32.h,),
              SizedBox(width: 0.width(context), height: 20.h,child:Center(child: MSText(text: 'Scratch Card, Scratch for Luck', size: 15, color: '#FFFFFF'.color(), weight: FontWeight.w800))),
              SizedBox(height: 120.h,),
            ],
          ),
        ],
      ),
    );
  }

}
class SJGradientProgressBar extends StatefulWidget {
  final VoidCallback? onCompleted; // ✅ 动画完成后的回调

  const SJGradientProgressBar({super.key, this.onCompleted});

  @override
  State<SJGradientProgressBar> createState() => _SJGradientProgressBarState();
}

class _SJGradientProgressBarState extends State<SJGradientProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final double barWidth = 307;
  final double barHeight = 22;
  final double progressHeight = 18;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // ✅ 动画完成回调
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onCompleted != null) {
        widget.onCompleted!();
      }
    });

    // 启动动画
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: barWidth,
      height: barHeight + 7,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center, // 允许子元素超出Stack的边界
        children: [
          // 背景图片
          SizedBox(
            width: barWidth,
            height: barHeight,
            child: MSImg(name: 'ms_luanch_pro_bg', width: barWidth, height: barHeight),
          ),
          // 进度条
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final progressWidth = barWidth * _animation.value;
              final progressPercent = (_animation.value * 100).clamp(0, 100).toInt();

              return Stack(
                alignment: Alignment.center,
                children: [
                  // 渐变进度条
                  Positioned(
                    left: 2,
                    top: ((barHeight - progressHeight) / 2) + 3.5,
                    child: Container(
                      width: max(0, progressWidth - 4),
                      height: progressHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            '#FFF29F'.color(),
                            '#FEEB20'.color(),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                  ),
                  // ✅ 居中显示百分比文字
                  Center(
                    child: Text(
                      '$progressPercent%',
                      style: TextStyle(
                        fontFamily: 'Atkinson',
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    // 保证图片的位置不会超出进度条宽度
                    left: (progressWidth - 20).clamp(0, barWidth - 28),  // 控制图片的位置不超出宽度
                    top: 0,  // 居中显示图片
                    width: 28,
                    height: 29,
                    child: MSImg(name: 'ms_dolas_icon_s', width: 28, height: 29),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}