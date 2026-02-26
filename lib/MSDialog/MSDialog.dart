import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_toast/fl_toast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:megascratch/MSTool/ms_GradientText.dart';
import 'package:megascratch/MSTool/ms_TBAInfoTool.dart';
import 'package:megascratch/MSTool/ms_ad_manger.dart';
import 'package:megascratch/MSTool/ms_text.dart';
import 'package:provider/provider.dart';
import '../MSHome/MSCashs.dart';
import '../MSHome/MSHome.dart';
import '../MSHome/MSScratchDetails.dart';
import '../MSHome/MSScratchDetailsB.dart';
import '../MSHome/MSTbabar.dart';
import '../MSTool/MSScratchWheelPage.dart';
import '../MSTool/ms_AdAHelp.dart';
import '../MSTool/ms_LocalProvider.dart';
import '../MSTool/ms_NoticeTool.dart';
import '../MSTool/ms_WebKitView.dart';
import '../MSTool/ms_extension_help.dart';
import '../MSTool/ms_img.dart';
import '../MSTool/ms_mp3_player.dart';
import '../MSTool/ms_stroke_text.dart';
import 'package:spine_flutter/spine_flutter.dart' as spine;
import 'package:app_settings/app_settings.dart';
import '../MSTool/ms_wheel_spin.dart';

class MSDialogTool {
  // tosat
  static void toast(BuildContext buildContext, String text) async {
    await showAndroidToast(
      padding: 0.0.all(16),
      margin: 0.0.all(32),
      alignment: Alignment.center,
      backgroundColor: '#000000'.color(opacity: 0.8),
      duration: Duration(seconds: 2),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      context: buildContext,
    );
  }

  static void toastRanking(BuildContext buildContext, int num) async {
    await showAndroidToast(
      padding: 0.0.all(0),
      margin: 0.0.all(0),
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      duration: Duration(seconds: 3),
      child: Container(
        width: 205,
        height: 50.5,
        decoration: BoxDecoration(
          color: '#000000'.color(opacity: 0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Your Current rank: ',
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(
                  text: '$num',
                  style: TextStyle(color: '#16FF16'.color(), fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
      context: buildContext,
    );
  }
}


// YouWin
class MSYouWinDialog extends StatefulWidget {
  final bool is_wheel;
  final int index;
  final double award_num;
  MSYouWinDialog({super.key, required this.award_num, required this.index, required this.is_wheel});

  @override
  State<MSYouWinDialog> createState() => MSYouWinDialogState();
}

class MSYouWinDialogState extends State<MSYouWinDialog> with TickerProviderStateMixin {
  late spine.SpineWidgetController _controller0;
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  bool _showBottom = false;

  @override
  void initState() {
    super.initState();

    if (!MSLocalProvider.instance.ms_first_box_tips){
      ms_event_fire('first_reward_v', {});
    } else {
      ms_event_fire('coin_pop', {'source_from' : _getindexName()});
    }
    playbgMUsic();
    // 初始化 Spine 控制器
    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 确保动画资源加载后再播放动画
        try {
          controller.animationState.setAnimationByName(0, "animation", true);
          print("Animation started successfully");
        } catch (e) {
          print("Failed to start animation: $e");
        }
      });
    });

    // 初始化旋转动画控制器
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();  // 重复旋转

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,  // 旋转一圈（360度）
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // 初始化缩放动画控制器
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2, // 放大到 1.1倍
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // 启动缩放动画
    _scaleController.repeat(reverse: true);  // 缩放动画来回播放

    Future.delayed(Duration(seconds: 3),(){
      setState(() {
        _showBottom = true;
      });
    });
  }

  Future<void> playbgMUsic() async {
    if (MSLocalProvider.instance.ms_sound_music){
      await MSAudioUtils().playAward1Audio();
      Future.delayed(Duration(milliseconds: 1000), () async {
        await MSAudioUtils().stopAllTempAudio();
      });
    }
  }

  String _getindexName(){
    String name = 'number';
    if (widget.index == 1){
      name = 'diamond';
    } else if (widget.index == 2){
      name = 'fruit';
    } else if (widget.index == 3){
      name = 'emoji';
    } else if (widget.index == 4){
      name = 'pot';
    } else if (widget.index == 5){
      name = '77';
    } else if (widget.index == 6){
      name = 'cash';
    } else if (widget.index == 0){
      name = 'number';
    } else {
      name = 'wheel';
    }
    return name;
  }

  @override
  void dispose() {
    _rotationController.dispose();  // 清理旋转控制器
    _scaleController.dispose();  // 清理缩放控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Spine 动画
          Positioned(
            left: (screenWidth - (screenWidth * 1.2)) * 0.5,
            width: screenWidth * 1.2,
            height: screenHeight * 1.1,
            child: spine.SpineWidget.fromAsset(
                'assets/spine/caidai1.atlas', 'assets/spine/caidai1.json', _controller0),
          ),
          // 旋转动画：ms_youwin_gs
          Positioned(
            top: 110.h,
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: MSImg(name: 'ms_youwin_gs', width: 375, height: 478),
                );
              },
            ),
          ),
          // 放大缩小动画：ms_youwin_titles
          Positioned(
            top: 200.h,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: MSImg(name: 'ms_youwin_titles', width: 340, height: 246),
                );
              },
            ),
          ),
          // 其他 UI 元素保持不变...
          Positioned(
            top: 438.h,
            child: Container(
              width: 348,
              height: 26,
              decoration: BoxDecoration(
                image: MSDImg('ms_paments_bg'),
              ),
              child: Stack(
                children: [
                  MSGradientStrokeText(
                    text: 'Payment Received',
                    gradientColors: ['#F0A00D'.color(), '#F1FF5A'.color(), '#D58516'.color()],
                    width: 348,
                    height: 20,
                    fontSize: 20,
                    strokeColor: '#330000'.color(),
                    strokeWidth: 1,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 460.h,
            child: Container(
              width: 297,
              height: 65,
              decoration: BoxDecoration(image: MSDImg('ms_award_btn_bgs')),
              child: Stack(
                children: [
                  Positioned(
                    top: 22,
                    child: MSGradientStrokeText(
                      text: '\$${widget.award_num.toStringAsFixed(2)}',
                      gradientColors: ['#FFFFD7'.color(), '#FFEA8F'.color(), '#FFD20B'.color(), '#FFD20B'.color()],
                      width: 297,
                      height: 20,
                      fontSize: 40,
                      strokeColor: '#6D450E'.color(),
                      strokeWidth: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 538.h,
            child: InkWell(
              onTap: () async {
                MSMegaAds().ms_showAd(context, MSLocalProvider.instance.ms_today_card_index == 1 ? 'pppuz_firstsrc_rv' : widget.is_wheel ? 'pppuz_wheeldollor_rv' : 'pppuz_srcaward_rv', onCacheResponse: (onCacheResponse){
                  Navigator.pop(context, 0);
                }, adDidClosed: (adDidClosed){
                  MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName, MSLocalProvider.instance.ms_dolas_number + (widget.award_num * 2.0));
                  Navigator.pop(context, 1);
                });
                if (!MSLocalProvider.instance.ms_first_box_tips){
                  await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_first_box_tipsName, true);
                  ms_event_fire('first_reward_c', {});
                }
                ms_event_fire('coin_pop_c', {'source_from' : _getindexName()});
              },
              child: Container(
                width: 237,
                height: 64,
                decoration: BoxDecoration(
                  image: MSDImg('ms_green_btns'),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MSImg(name: 'ms_ad_icon', width: 25, height: 25),
                    SizedBox(width: 8),
                    MSStrokeText(
                      text: 'Claim \$${(widget.award_num * 2.0).toStringAsFixed(2)}',
                      size: 24,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w700,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 538.h + 64,
            child: InkWell(
              onTap: () async {
                if (await MSMegaAds().getIntShow()) {
                  if (!context.mounted) return;
                  MSMegaAds().ms_showAd(context,MSLocalProvider.instance.ms_today_card_index == 1 ? 'pppuz_firstsrc_int' :  widget.is_wheel ? 'pppuz_wheeldollor_int' : 'pppuz_srcclose_int', onCacheResponse: (onCacheResponse){
                    Navigator.pop(context, 1);
                  }, adDidClosed: (adDidClosed){
                    MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName, MSLocalProvider.instance.ms_dolas_number + (widget.award_num));
                    Navigator.pop(context, 1);
                  });
                } else {
                  await MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName, MSLocalProvider.instance.ms_dolas_number + (widget.award_num));
                  if (!context.mounted) return;
                  Navigator.pop(context, 1);
                }
                if (!MSLocalProvider.instance.ms_first_box_tips){
                  await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_first_box_tipsName, true);
                  ms_event_fire('first_reward_c', {});
                }
                ms_event_fire('coin_pop_close', {'source_from' : _getindexName()});
              },
              child: Visibility(
                visible: _showBottom,
                child: SizedBox(
                  width: 237,
                  height: 64,
                  child: Center(
                    child: MSStrokeText(
                      text: '\$${widget.award_num}',
                      size: 20,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w700,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// YouWin
class MSJackPotDialog extends StatefulWidget {
  final int index;
  final double award_num;
  MSJackPotDialog({super.key, required this.award_num, required this.index});

  @override
  State<MSJackPotDialog> createState() => MSJackPotDialogState();
}

class MSJackPotDialogState extends State<MSJackPotDialog> with TickerProviderStateMixin {
  late spine.SpineWidgetController _controller0;
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  bool _showBottom = false;
  @override
  void initState() {
    super.initState();
    playbgMUsic();
    // 初始化 Spine 控制器
    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 确保动画资源加载后再播放动画
        try {
          controller.animationState.setAnimationByName(0, "animation", true);
          print("Animation started successfully");
        } catch (e) {
          print("Failed to start animation: $e");
        }
      });
    });

    ms_event_fire('coin_pop', {'source_from' : _getindexName()});

    // 初始化旋转动画控制器
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();  // 重复旋转

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,  // 旋转一圈（360度）
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // 初始化缩放动画控制器
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2, // 放大到 1.1倍
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // 启动缩放动画
    _scaleController.repeat(reverse: true);  // 缩放动画来回播放

    Future.delayed(Duration(seconds: 3),(){
      if (!mounted) return;
      setState(() {
        _showBottom = true;
      });
    });
  }

  Future<void> playbgMUsic() async {
    if (MSLocalProvider.instance.ms_sound_music){
      await MSAudioUtils().playAward2Audio();
      Future.delayed(Duration(milliseconds: 1000), () async {
        await MSAudioUtils().stopAllTempAudio();
      });
    }
  }

  String _getindexName(){
    String name = 'number';
    if (widget.index == 1){
      name = 'diamond';
    } else if (widget.index == 2){
      name = 'fruit';
    } else if (widget.index == 3){
      name = 'emoji';
    } else if (widget.index == 4){
      name = 'pot';
    } else if (widget.index == 5){
      name = '77';
    } else if (widget.index == 6){
      name = 'cash';
    } else if (widget.index == 0){
      name = 'number';
    } else {
      name = 'wheel';
    }
    return name;
  }

  @override
  void dispose() {
    _rotationController.dispose();  // 清理旋转控制器
    _scaleController.dispose();  // 清理缩放控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Spine 动画
          Positioned(
            left: (screenWidth - (screenWidth * 1.2)) * 0.5,
            width: screenWidth * 1.2,
            height: screenHeight * 1.1,
            child: spine.SpineWidget.fromAsset(
                'assets/spine/caidai1.atlas', 'assets/spine/caidai1.json', _controller0),
          ),
          // 旋转动画：ms_youwin_gs
          Positioned(
            top: 110.h,
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: MSImg(name: 'ms_jackpot_g', width: 375, height: 478),
                );
              },
            ),
          ),
          // 放大缩小动画：ms_youwin_titles
          Positioned(
            top: 180.h,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: MSImg(name: 'ms_jackpot_title', width: 340, height: 246),
                );
              },
            ),
          ),
          // 其他 UI 元素保持不变...
          Positioned(
            top: 438.h,
            child: Container(
              width: 348,
              height: 26,
              decoration: BoxDecoration(
                image: MSDImg('ms_paments_bg'),
              ),
              child: Stack(
                children: [
                  MSGradientStrokeText(
                    text: 'Payment Received',
                    gradientColors: ['#F0A00D'.color(), '#F1FF5A'.color(), '#D58516'.color()],
                    width: 348,
                    height: 20,
                    fontSize: 20,
                    strokeColor: '#330000'.color(),
                    strokeWidth: 1,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 460.h,
            child: Container(
              width: 297,
              height: 65,
              decoration: BoxDecoration(image: MSDImg('ms_award_btn_bgs')),
              child: Stack(
                children: [
                  Positioned(
                    top: 22,
                    child: MSGradientStrokeText(
                      text: '\$${widget.award_num}',
                      gradientColors: ['#FFFFD7'.color(), '#FFEA8F'.color(), '#FFD20B'.color(), '#FFD20B'.color()],
                      width: 297,
                      height: 20,
                      fontSize: 40,
                      strokeColor: '#6D450E'.color(),
                      strokeWidth: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 538.h,
            child: InkWell(
              onTap: () async {
                ms_event_fire('coin_pop_c', {'source_from' : _getindexName()});
                MSMegaAds().ms_showAd(context, MSLocalProvider.instance.ms_today_card_index == 1 ? 'pppuz_firstsrc_rv' : 'pppuz_srcaward_rv', onCacheResponse: (onCacheResponse){
                  Navigator.pop(context, 0);
                }, adDidClosed: (adDidClosed){
                  MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName, MSLocalProvider.instance.ms_dolas_number + (widget.award_num * 2.0));
                  Navigator.pop(context, 1);
                });
              },
              child: Container(
                width: 237,
                height: 64,
                decoration: BoxDecoration(
                  image: MSDImg('ms_green_btns'),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MSImg(name: 'ms_ad_icon', width: 25, height: 25),
                    SizedBox(width: 8),
                    MSStrokeText(
                      text: 'Claim \$${(widget.award_num * 2.0).toStringAsFixed(2)}',
                      size: 24,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w700,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 538.h + 64,
            child: InkWell(
              onTap: () async {
                ms_event_fire('coin_pop_close', {'source_from' : _getindexName()});
                if (await MSMegaAds().getIntShow()) {
                  if (!context.mounted) return;
                  MSMegaAds().ms_showAd(context, MSLocalProvider.instance.ms_today_card_index == 1 ? 'pppuz_firstsrc_int' : 'pppuz_srcclose_int', onCacheResponse: (onCacheResponse){
                    Navigator.pop(context, 1);
                  }, adDidClosed: (adDidClosed){
                    MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName, MSLocalProvider.instance.ms_dolas_number + (widget.award_num));
                    Navigator.pop(context, 1);
                  });
                } else {
                  await MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName, MSLocalProvider.instance.ms_dolas_number + (widget.award_num));
                  if (!context.mounted) return;
                  Navigator.pop(context, 1);
                }
              },
              child: Visibility(
                visible: _showBottom,
                child: SizedBox(
                  width: 237,
                  height: 64,
                  child: Center(
                    child: MSStrokeText(
                      text: '\$${widget.award_num}',
                      size: 20,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w700,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// Bigwin
class MSBigWinDialog extends StatefulWidget {
  final int index;
  final double award_num;
  MSBigWinDialog({super.key, required this.award_num, required this.index});

  @override
  State<MSBigWinDialog> createState() => MSBigWinDialogState();
}

class MSBigWinDialogState extends State<MSBigWinDialog> with TickerProviderStateMixin {
  late spine.SpineWidgetController _controller0;
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  bool _showBottom = false;
  @override
  void initState() {
    super.initState();
    playbgMUsic();
    ms_event_fire('coin_pop', {'source_from' : _getindexName()});
    // 初始化 Spine 控制器
    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 确保动画资源加载后再播放动画
        try {
          controller.animationState.setAnimationByName(0, "animation", true);
          print("Animation started successfully");
        } catch (e) {
          print("Failed to start animation: $e");
        }
      });
    });

    // 初始化旋转动画控制器
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();  // 重复旋转

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,  // 旋转一圈（360度）
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // 初始化缩放动画控制器
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2, // 放大到 1.1倍
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // 启动缩放动画
    _scaleController.repeat(reverse: true);  // 缩放动画来回播放

    Future.delayed(Duration(seconds: 3),(){
      setState(() {
        _showBottom = true;
      });
    });
  }

  Future<void> playbgMUsic() async {
    if (MSLocalProvider.instance.ms_sound_music){
      await MSAudioUtils().playAward3Audio();
      Future.delayed(Duration(milliseconds: 1000), () async {
        await MSAudioUtils().stopAllTempAudio();
      });
    }
  }

  String _getindexName(){
    String name = 'number';
    if (widget.index == 1){
      name = 'diamond';
    } else if (widget.index == 2){
      name = 'fruit';
    } else if (widget.index == 3){
      name = 'emoji';
    } else if (widget.index == 4){
      name = 'pot';
    } else if (widget.index == 5){
      name = '77';
    } else if (widget.index == 6){
      name = 'cash';
    } else if (widget.index == 0){
      name = 'number';
    } else {
      name = 'wheel';
    }
    return name;
  }

  @override
  void dispose() {
    _rotationController.dispose();  // 清理旋转控制器
    _scaleController.dispose();  // 清理缩放控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Spine 动画
          Positioned(
            left: (screenWidth - (screenWidth * 1.2)) * 0.5,
            width: screenWidth * 1.2,
            height: screenHeight * 1.1,
            child: spine.SpineWidget.fromAsset(
                'assets/spine/caidai1.atlas', 'assets/spine/caidai1.json', _controller0),
          ),
          // 旋转动画：ms_youwin_gs
          Positioned(
            top: 110.h,
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: MSImg(name: 'ms_bigwin_g', width: 375, height: 478),
                );
              },
            ),
          ),
          // 放大缩小动画：ms_youwin_titles
          Positioned(
            top: 200.h,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: MSImg(name: 'ms_bigwin_title', width: 340, height: 246),
                );
              },
            ),
          ),
          // 其他 UI 元素保持不变...
          Positioned(
            top: 438.h,
            child: Container(
              width: 348,
              height: 26,
              decoration: BoxDecoration(
                image: MSDImg('ms_paments_bg'),
              ),
              child: Stack(
                children: [
                  MSGradientStrokeText(
                    text: 'Payment Received',
                    gradientColors: ['#F0A00D'.color(), '#F1FF5A'.color(), '#D58516'.color()],
                    width: 348,
                    height: 20,
                    fontSize: 20,
                    strokeColor: '#330000'.color(),
                    strokeWidth: 1,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 460.h,
            child: Container(
              width: 297,
              height: 65,
              decoration: BoxDecoration(image: MSDImg('ms_award_btn_bgs')),
              child: Stack(
                children: [
                  Positioned(
                    top: 22,
                    child: MSGradientStrokeText(
                      text: '\$${widget.award_num}',
                      gradientColors: ['#FFFFD7'.color(), '#FFEA8F'.color(), '#FFD20B'.color(), '#FFD20B'.color()],
                      width: 297,
                      height: 20,
                      fontSize: 40,
                      strokeColor: '#6D450E'.color(),
                      strokeWidth: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 538.h,
            child: InkWell(
              onTap: () async {
                ms_event_fire('coin_pop_c', {'source_from' : _getindexName()});
                MSMegaAds().ms_showAd(context, MSLocalProvider.instance.ms_today_card_index == 1 ? 'pppuz_firstsrc_rv' :  'pppuz_srcaward_rv', onCacheResponse: (onCacheResponse){
                  Navigator.pop(context, 0);
                }, adDidClosed: (adDidClosed){
                  MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName, MSLocalProvider.instance.ms_dolas_number + (widget.award_num * 2.0));
                  Navigator.pop(context, 1);
                });
              },
              child: Container(
                width: 237,
                height: 64,
                decoration: BoxDecoration(
                  image: MSDImg('ms_green_btns'),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MSImg(name: 'ms_ad_icon', width: 25, height: 25),
                    SizedBox(width: 8),
                    MSStrokeText(
                      text: 'Claim \$${(widget.award_num * 2.0).toStringAsFixed(2)}',
                      size: 24,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w700,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 538.h + 64,
            child: InkWell(
              onTap: () async {
                ms_event_fire('coin_pop_close', {'source_from' : _getindexName()});
                if (await MSMegaAds().getIntShow()) {
                  if (!context.mounted) return;
                  MSMegaAds().ms_showAd(context, MSLocalProvider.instance.ms_today_card_index == 1 ? 'pppuz_firstsrc_int' :  'pppuz_srcclose_int', onCacheResponse: (onCacheResponse){
                    Navigator.pop(context, 1);
                  }, adDidClosed: (adDidClosed){
                    MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName, MSLocalProvider.instance.ms_dolas_number + (widget.award_num));
                    Navigator.pop(context, 1);
                  });
                } else {
                  await MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName, MSLocalProvider.instance.ms_dolas_number + (widget.award_num));
                  if (!context.mounted) return;
                  Navigator.pop(context, 1);
                }
              },
              child: Visibility(
                visible: _showBottom,
                child: SizedBox(
                  width: 237,
                  height: 64,
                  child: Center(
                    child: MSStrokeText(
                      text: '\$${widget.award_num}',
                      size: 20,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w700,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SuperWin
class MSSuperWinDialog extends StatefulWidget {
  final int index;
  final double award_num;
  MSSuperWinDialog({super.key, required this.award_num, required this.index});

  @override
  State<MSSuperWinDialog> createState() => MSSuperWinDialogState();
}

class MSSuperWinDialogState extends State<MSSuperWinDialog> with TickerProviderStateMixin {
  late spine.SpineWidgetController _controller0;
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  bool _showBottom = false;
  @override
  void initState() {
    super.initState();
    ms_event_fire('coin_pop', {'source_from' : _getindexName()});
    // 初始化 Spine 控制器
    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 确保动画资源加载后再播放动画
        try {
          controller.animationState.setAnimationByName(0, "animation", true);
          print("Animation started successfully");
        } catch (e) {
          print("Failed to start animation: $e");
        }
      });
    });

    // 初始化旋转动画控制器
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();  // 重复旋转

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,  // 旋转一圈（360度）
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // 初始化缩放动画控制器
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2, // 放大到 1.1倍
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // 启动缩放动画
    _scaleController.repeat(reverse: true);  // 缩放动画来回播放

    Future.delayed(Duration(seconds: 3),(){
      if (!mounted) return;
      setState(() {
        _showBottom = true;
      });
    });

     playbgMUsic();
  }

  Future<void> playbgMUsic() async {
    if (MSLocalProvider.instance.ms_sound_music){
      await MSAudioUtils().playAward3Audio();
      Future.delayed(Duration(milliseconds: 1000), () async {
        await MSAudioUtils().stopAllTempAudio();
      });
    }
  }

  String _getindexName(){
    String name = 'number';
    if (widget.index == 1){
      name = 'diamond';
    } else if (widget.index == 2){
      name = 'fruit';
    } else if (widget.index == 3){
      name = 'emoji';
    } else if (widget.index == 4){
      name = 'pot';
    } else if (widget.index == 5){
      name = '77';
    } else if (widget.index == 6){
      name = 'cash';
    } else if (widget.index == 0){
      name = 'number';
    } else {
      name = 'wheel';
    }
    return name;
  }

  @override
  void dispose() {
    _rotationController.dispose();  // 清理旋转控制器
    _scaleController.dispose();  // 清理缩放控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Spine 动画
          Positioned(
            left: (screenWidth - (screenWidth * 1.2)) * 0.5,
            width: screenWidth * 1.2,
            height: screenHeight * 1.1,
            child: spine.SpineWidget.fromAsset(
                'assets/spine/caidai1.atlas', 'assets/spine/caidai1.json', _controller0),
          ),
          // 旋转动画：ms_youwin_gs
          Positioned(
            top: 110.h,
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: MSImg(name: 'ms_superwin_g', width: 375, height: 478),
                );
              },
            ),
          ),
          // 放大缩小动画：ms_youwin_titles
          Positioned(
            top: 200.h,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: MSImg(name: 'ms_superwin_title', width: 340, height: 246),
                );
              },
            ),
          ),
          // 其他 UI 元素保持不变...
          Positioned(
            top: 438.h,
            child: Container(
              width: 348,
              height: 26,
              decoration: BoxDecoration(
                image: MSDImg('ms_paments_bg'),
              ),
              child: Stack(
                children: [
                  MSGradientStrokeText(
                    text: 'Payment Received',
                    gradientColors: ['#F0A00D'.color(), '#F1FF5A'.color(), '#D58516'.color()],
                    width: 348,
                    height: 20,
                    fontSize: 20,
                    strokeColor: '#330000'.color(),
                    strokeWidth: 1,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 460.h,
            child: Container(
              width: 297,
              height: 65,
              decoration: BoxDecoration(image: MSDImg('ms_award_btn_bgs')),
              child: Stack(
                children: [
                  Positioned(
                    top: 22,
                    child: MSGradientStrokeText(
                      text: '\$${widget.award_num}',
                      gradientColors: ['#FFFFD7'.color(), '#FFEA8F'.color(), '#FFD20B'.color(), '#FFD20B'.color()],
                      width: 297,
                      height: 20,
                      fontSize: 40,
                      strokeColor: '#6D450E'.color(),
                      strokeWidth: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 538.h,
            child: InkWell(
              onTap: () async {
                ms_event_fire('coin_pop_c', {'source_from' : _getindexName()});
                MSMegaAds().ms_showAd(context, MSLocalProvider.instance.ms_today_card_index == 1 ? 'pppuz_firstsrc_rv' : 'pppuz_srcaward_rv', onCacheResponse: (onCacheResponse){
                  Navigator.pop(context, 0);
                }, adDidClosed: (adDidClosed){
                  MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName, MSLocalProvider.instance.ms_dolas_number + (widget.award_num * 2.0));
                  Navigator.pop(context, 1);
                });
              },
              child: Container(
                width: 237,
                height: 64,
                decoration: BoxDecoration(
                  image: MSDImg('ms_green_btns'),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MSImg(name: 'ms_ad_icon', width: 25, height: 25),
                    SizedBox(width: 8),
                    MSStrokeText(
                      text: 'Claim \$${(widget.award_num * 2.0).toStringAsFixed(2)}',
                      size: 24,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w700,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 538.h + 64,
            child: InkWell(
              onTap: () async {
                ms_event_fire('coin_pop_close', {'source_from' : _getindexName()});
                if (await MSMegaAds().getIntShow()) {
                  if (!context.mounted) return;
                  MSMegaAds().ms_showAd(context, MSLocalProvider.instance.ms_today_card_index == 1 ? 'pppuz_firstsrc_int' : 'pppuz_srcclose_int', onCacheResponse: (onCacheResponse){
                    Navigator.pop(context, 1);
                  }, adDidClosed: (adDidClosed){
                    MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName, MSLocalProvider.instance.ms_dolas_number + (widget.award_num));
                    Navigator.pop(context, 1);
                  });
                } else {
                  await MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName, MSLocalProvider.instance.ms_dolas_number + (widget.award_num));
                  if (!context.mounted) return;
                  Navigator.pop(context, 1);
                }
              },
              child: Visibility(
                visible: _showBottom,
                child: SizedBox(
                  width: 237,
                  height: 64,
                  child: Center(
                    child: MSStrokeText(
                      text: '\$${widget.award_num}',
                      size: 20,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w700,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 未中奖
class MSUnAwardDialog extends StatefulWidget {
  final int index;
  MSUnAwardDialog({super.key, required this.index});

  @override
  State<MSUnAwardDialog> createState() => MSUnAwardDialogState();
}

class MSUnAwardDialogState extends State<MSUnAwardDialog> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  // 生成 0 到 3 之间的随机整数
  int randomNumber = Random().nextInt(4);

  @override
  void initState() {
    super.initState();
    playbgMUsic();
    ms_event_fire('paly_failed_pop', {'source_from' : _getindexName()});
    // 初始化缩放动画控制器
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2, // 放大到 1.1倍
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // 启动缩放动画
    _scaleController.repeat(reverse: true);  // 缩放动画来回播放
  }

  Future<void> playbgMUsic() async {
    if (MSLocalProvider.instance.ms_sound_music){
      await MSAudioUtils().playUnAwardAudio();
      Future.delayed(Duration(milliseconds: 1000), () async {
        await MSAudioUtils().stopAllTempAudio();
      });
    }
  }

  String _getindexName(){
    String name = 'number';
    if (widget.index == 1){
      name = 'diamond';
    } else if (widget.index == 2){
      name = 'fruit';
    } else if (widget.index == 3){
      name = 'emoji';
    } else if (widget.index == 4){
      name = 'pot';
    } else if (widget.index == 5){
      name = '77';
    } else if (widget.index == 6){
      name = 'cash';
    } else if (widget.index == 0){
      name = 'number';
    } else {
      name = 'wheel';
    }
    return name;
  }

  @override
  void dispose() {
    _scaleController.dispose();  // 清理缩放控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 放大缩小动画：ms_youwin_titles
          Positioned(
            top: 300.h,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: MSImg(name: 'ms_unlock_title_${randomNumber}', width: 369, height: 160),
                );
              },
            ),
          ),
          Positioned(
            top: 480.h,
            child: InkWell(
              onTap: () async {
                ms_event_fire('paly_failed_pop_c', {'source_from' : _getindexName()});
                if (MSLocalProvider.instance.ms_frist_unAward_status == true){
                  await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_frist_unAward_statusName, false);
                  if (!context.mounted) return;
                  Navigator.pop(context, 1);
                } else {
                  if (await MSMegaAds().getIntShow()) {
                    if (!context.mounted) return;
                    MSMegaAds().ms_showAd(context, 'pppuz_srctry_int', onCacheResponse: (onCacheResponse){
                      Navigator.pop(context, 1);
                    }, adDidClosed: (adDidClosed){
                      Navigator.pop(context, 1);
                    });
                  } else {
                    if (!context.mounted) return;
                    Navigator.pop(context, 1);
                  }

                }
              },
              child: Container(
                width: 237,
                height: 64,
                decoration: BoxDecoration(
                  image: MSDImg('ms_green_btns'),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // MSImg(name: 'ms_ad_icon', width: 25, height: 25),
                    // SizedBox(width: 8),
                    MSStrokeText(
                      text: 'Try Again',
                      size: 24,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w700,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 每日首次翻卡
class MSCardPoolDialog extends StatefulWidget {
  MSCardPoolDialog({super.key});

  @override
  State<MSCardPoolDialog> createState() => MSCardPoolDialogState();
}

class MSCardPoolDialogState extends State<MSCardPoolDialog> with TickerProviderStateMixin {
  // 用来存储每张卡片的翻转状态
  List<bool> isFlipped = [false, false, false]; // 记录三张卡片的翻转状态
  List<AnimationController> _controllers = []; // 动画控制器
  List<Animation<double>> _animations = []; // 动画值
  bool isAnimating = false; // 标记是否正在进行翻转动画
  int fan_index = 0;
  String image_name = '';
  @override
  void initState() {
    super.initState();
    image_name = _getimageName();
    // 初始化动画控制器和动画
    for (int i = 0; i < 3; i++) {
      AnimationController controller = AnimationController(
        duration: Duration(seconds: 1),
        vsync: this,
      );
      Animation<double> animation = Tween<double>(begin: 0, end: 1).animate(controller)
        ..addListener(() {
          setState(() {});
        });
      _controllers.add(controller);
      _animations.add(animation);
    }
  }

  @override
  void dispose() {
    // 释放动画控制器
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // 卡片点击事件
  void _onCardTapped(int index) {
    if (isAnimating) return; // 如果当前正在翻转，直接返回
    setState(() {
      isAnimating = true; // 开始翻转动画
    });
    Future.delayed(Duration(milliseconds: 500), () async {
      isFlipped[index] = !isFlipped[index];
    });
    if (isFlipped[index]) {
      // 如果是已经翻转的卡片，先反向翻转
      _controllers[index].reverse().then((value) {
        setState(() {
          // isFlipped[index] = !isFlipped[index]; // 在翻转回去时更新图片
          isAnimating = false; // 翻转动画结束，允许点击其他卡片
        });
      });
    } else {
      // 如果是没有翻转的卡片，先翻转
      _controllers[index].forward().then((value) {
        setState(() {
          isAnimating = false; // 翻转动画结束，允许点击其他卡片
        });
        showCardAward();
      });
    }
  }

  void showCardAward(){
    Navigator.pop(context, 1);
    if (fan_index == 0){
      context.tipShow(MS777baoCardDialog());
    } else if (fan_index == 1){
      context.tipShow(MSDoubleCardDialog());
    } else if (fan_index == 2){
      context.tipShow(MSFruitCardDialog());
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 88.0.h,
              child: MSImg(name: 'ms_fan_title1', width: 352, height: 57)
          ),
          Positioned(
              top: 130.0.h,
              child: MSImg(name: 'ms_fan_title2', width: 313, height: 56)
          ),
          // 第一张卡片
          Positioned(
            top: 200.0.h,
            child: InkWell(
              onTap: () => _onCardTapped(0), // 点击翻转第一张卡片
              child: AnimatedBuilder(
                animation: _animations[0],
                builder: (context, child) {
                  double angle = _animations[0].value * 3.14159; // 控制旋转角度 (180度)
                  double angle1 = _animations[0].value * 3.14159 * 2; // 控制旋转角度 (180度)
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(isFlipped[0] ? angle1 : angle),
                    child: MSImg(
                      name: isFlipped[0] ? image_name : 'ms_fan_card',
                      width: isFlipped[0] ? 150 : 120,
                      height: isFlipped[0] ? 180 : 165,
                    ),
                  );
                },
              ),
            ),
          ),
          // 第二张卡片
          Positioned(
            top: 400.0.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => _onCardTapped(1), // 点击翻转第二张卡片
                  child: AnimatedBuilder(
                    animation: _animations[1],
                    builder: (context, child) {
                      double angle = _animations[1].value * 3.14159;
                      double angle1 = _animations[0].value * 3.14159 * 2; // 控制旋转角度 (180度)
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(isFlipped[1] ? angle1 : angle),
                        child: MSImg(
                          name: isFlipped[1] ? image_name : 'ms_fan_card',
                          width: isFlipped[1] ? 150 : 120,
                          height: isFlipped[1] ? 180 : 165,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 60),
                InkWell(
                  onTap: () => _onCardTapped(2), // 点击翻转第三张卡片
                  child: AnimatedBuilder(
                    animation: _animations[2],
                    builder: (context, child) {
                      double angle = _animations[2].value * 3.14159;
                      double angle1 = _animations[0].value * 3.14159 * 2; // 控制旋转角度 (180度)
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(isFlipped[2] ? angle1 : angle),
                        child: MSImg(
                          name: isFlipped[2] ? image_name : 'ms_fan_card',
                          width: isFlipped[2] ? 150 : 120,
                          height: isFlipped[2] ? 180 : 165,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getimageName(){
    String names = 'ms_77_card_icon';
    int code = Random().nextInt(2);
    fan_index = code;
    if (code == 0){
      names = 'ms_77_card_icon';
    } else if (code == 1) {
      names = 'ms_x2_card_icon';
    } else if (code == 2) {
      names = 'ms_shuiguo_card_icon';
    }
   return names;
  }
}

// 每日任务挽留
class MSTodayTwoDialog extends StatefulWidget {
  MSTodayTwoDialog({super.key});

  @override
  State<MSTodayTwoDialog> createState() => MSTodayTwoDialogState();
}

class MSTodayTwoDialogState extends State<MSTodayTwoDialog> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 171.0.h,
              child: MSImg(name: 'ms_wan_icon_1', width: 375, height: 262)
          ),
          Positioned(
              top: 300.0.h,
              child: MSImg(name: 'ms_wan_icon_2', width: 269, height: 102)
          ),
          Positioned(
            top: 420.h,
            child: InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Container(
                width: 237,
                height: 64,
                decoration: BoxDecoration(
                  image: MSDImg('ms_green_btns'),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MSImg(name: 'ms_ad_icon', width: 25, height: 25),
                    SizedBox(width: 8),
                    MSStrokeText(
                      text: 'Claim',
                      size: 24,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w700,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 777爆率卡
class MS777baoCardDialog extends StatefulWidget {
  MS777baoCardDialog({super.key});

  @override
  State<MS777baoCardDialog> createState() => MS777baoCardDialogState();
}

class MS777baoCardDialogState extends State<MS777baoCardDialog> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 99.0.h,
              child: MSImg(name: 'ms_congs_title', width: 321, height: 58)
          ),
          Positioned(
              top: 138.0.h,
              child: MSImg(name: 'ms_congs_title2', width: 347.5, height: 80)
          ),
          Positioned(
              top: 208.2.h,
              child: MSImg(name: 'ms_77_card_icon', width: 332, height: 331)
          ),
          Positioned(
            top: 500.h,
            child: InkWell(
              onTap: () async {
                MSMegaAds().ms_showAd(context, 'pppuz_wheeldaoju_rv', onCacheResponse: (onCacheResponse){
                  Navigator.pop(context, 0);
                }, adDidClosed: (adDidClosed){
                  Navigator.pop(context, 0);
                  MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_777_cardName, true);
                });
              },
              child: Container(
                width: 237,
                height: 64,
                decoration: BoxDecoration(
                  image: MSDImg('ms_yellow_btn'),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MSImg(name: 'ms_ad_icon', width: 25, height: 25),
                    SizedBox(width: 8),
                    MSStrokeText(
                      text: 'Claim',
                      size: 24,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w700,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 500.h + 64,
            child: InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: SizedBox(
                width: 237,
                height: 64,
                child: MSUnderlineTextButton(text: 'Give Up', textColor: '#FFFFFF'.color(), underlineColor: '#FFFFFF'.color(), fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// Double爆率卡
class MSDoubleCardDialog extends StatefulWidget {
  MSDoubleCardDialog({super.key});

  @override
  State<MSDoubleCardDialog> createState() => MSDoubleCardDialogState();
}

class MSDoubleCardDialogState extends State<MSDoubleCardDialog> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 141.0.h,
              child: MSImg(name: 'ms_double_title', width: 337, height: 28)
          ),
          Positioned(
              top: 170.2.h,
              child: MSImg(name: 'ms_x2_card_icon', width: 332, height: 334)
          ),
          Positioned(
              top: 440.2.h,
              child: Container(
                width: 339,
                height: 79,
                decoration: BoxDecoration(
                  image: MSDImg('ms_double_center')
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                        color: '#FFFFFF'.color()
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Double Rewards ',
                          style: TextStyle(color: '#8EFFE5'.color()),
                        ),
                        TextSpan(
                          text: 'in \n your next task',
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),
          Positioned(
            top: 510.h,
            child: InkWell(
              onTap: () async {
                MSMegaAds().ms_showAd(context, 'pppuz_wheeldaoju_rv', onCacheResponse: (onCacheResponse){
                  Navigator.pop(context, 0);
                }, adDidClosed: (adDidClosed){
                  Navigator.pop(context, 0);
                  MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_double_cardName, true);
                });
              },
              child: Container(
                width: 237,
                height: 64,
                decoration: BoxDecoration(
                  image: MSDImg('ms_yellow_btn'),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MSImg(name: 'ms_ad_icon', width: 25, height: 25),
                    SizedBox(width: 8),
                    MSStrokeText(
                      text: 'Claim',
                      size: 24,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w700,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 510.h + 64,
            child: InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: SizedBox(
                width: 237,
                height: 64,
                child: MSUnderlineTextButton(text: 'Give Up', textColor: '#FFFFFF'.color(), underlineColor: '#FFFFFF'.color(), fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// 水果狂欢卡
class MSFruitCardDialog extends StatefulWidget {
  MSFruitCardDialog({super.key});

  @override
  State<MSFruitCardDialog> createState() => MSFruitCardDialogState();
}

class MSFruitCardDialogState extends State<MSFruitCardDialog> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 141.0.h,
              child: MSImg(name: 'ms_double_title', width: 337, height: 28)
          ),
          Positioned(
              top: 170.2.h,
              child: MSImg(name: 'ms_shuiguo_card_icon', width: 332, height: 334)
          ),
          Positioned(
              top: 440.2.h,
              child: Container(
                width: 339,
                height: 79,
                decoration: BoxDecoration(
                    image: MSDImg('ms_double_center')
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: '#FFFFFF'.color()
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Increases fruit combination rewards \n by an',
                        ),
                        TextSpan(
                          text: ' Extra 50% ',
                          style: TextStyle(color: '#8EFFE5'.color()),
                        ),
                        TextSpan(
                          text: 'in next game',
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),
          Positioned(
            top: 510.h,
            child: InkWell(
              onTap: () async {
                MSMegaAds().ms_showAd(context, 'pppuz_wheeldaoju_rv', onCacheResponse: (onCacheResponse){
                  Navigator.pop(context, 0);
                }, adDidClosed: (adDidClosed){
                  Navigator.pop(context, 0);
                  MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_fruit_cardName, true);
                });
              },
              child: Container(
                width: 237,
                height: 64,
                decoration: BoxDecoration(
                  image: MSDImg('ms_yellow_btn'),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MSImg(name: 'ms_ad_icon', width: 25, height: 25),
                    SizedBox(width: 8),
                    MSStrokeText(
                      text: 'Claim',
                      size: 24,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w700,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 510.h + 64,
            child: InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: SizedBox(
                width: 237,
                height: 64,
                child: MSUnderlineTextButton(text: 'Give Up', textColor: '#FFFFFF'.color(), underlineColor: '#FFFFFF'.color(), fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// 表情万能卡
class MSEmojiCardDialog extends StatefulWidget {
  MSEmojiCardDialog({super.key});

  @override
  State<MSEmojiCardDialog> createState() => MSEmojiCardDialogState();
}

class MSEmojiCardDialogState extends State<MSEmojiCardDialog> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 141.0.h,
              child: MSImg(name: 'ms_emoji_title', width: 337, height: 28)
          ),
          Positioned(
              top: 170.2.h,
              child: MSImg(name: 'ms_emoji_card_icon', width: 332, height: 334)
          ),
          Positioned(
              top: 440.2.h,
              child: Container(
                width: 339,
                height: 79,
                decoration: BoxDecoration(
                    image: MSDImg('ms_double_center')
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: '#FFFFFF'.color()
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Can be used as any emoji',
                        ),
                        TextSpan(
                          text: ' any emoji\n',
                          style: TextStyle(color: '#8EFFE5'.color()),
                        ),
                        TextSpan(
                          text: 'to complete combinations',
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),
          Positioned(
            top: 510.h,
            child: InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Container(
                width: 237,
                height: 64,
                decoration: BoxDecoration(
                  image: MSDImg('ms_yellow_btn'),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MSImg(name: 'ms_ad_icon', width: 25, height: 25),
                    SizedBox(width: 8),
                    MSStrokeText(
                      text: 'Claim',
                      size: 24,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w700,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 510.h + 64,
            child: InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: SizedBox(
                width: 237,
                height: 64,
                child: MSUnderlineTextButton(text: 'Give Up', textColor: '#FFFFFF'.color(), underlineColor: '#FFFFFF'.color(), fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// X2显示
class MSX2Dialog extends StatefulWidget {
  MSX2Dialog({super.key});

  @override
  State<MSX2Dialog> createState() => MSX2DialogState();
}

class MSX2DialogState extends State<MSX2Dialog> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    upadteStatus();
    // 初始化旋转动画控制器
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();  // 重复旋转

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,  // 旋转一圈（360度）
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pop(context);   // ✔ 正确，关闭当前 dialog
    });

  }

  Future<void> upadteStatus() async {
    await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_double_cardName, false);
  }

  @override
  void dispose() {
    _rotationController.dispose();  // 清理旋转控制器
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        fit: .expand,
        alignment: AlignmentGeometry.center,
        children: [
          // 旋转动画：ms_youwin_gs
          Positioned(
            width: 246, height: 247,
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: MSImg(name: 'ms_x2_bg', width: 246, height: 247),
                );
              },
            ),
          ),
          Positioned(
              width: 156, height: 99,
              child: MSImg(name: 'ms_x2_icon', width: 156, height: 99)
          ),
        ],
      ),
    );
  }
}
// X2显示
class MSFruitDialog extends StatefulWidget {
  MSFruitDialog({super.key});

  @override
  State<MSFruitDialog> createState() => MSFruitDialogState();
}

class MSFruitDialogState extends State<MSFruitDialog> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    upadteStatus();
    // 初始化旋转动画控制器
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();  // 重复旋转

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,  // 旋转一圈（360度）
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pop(context);   // ✔ 正确，关闭当前 dialog
    });

  }

  Future<void> upadteStatus() async {
    await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_fruit_cardName, false);
  }

  @override
  void dispose() {
    _rotationController.dispose();  // 清理旋转控制器
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        fit: .expand,
        alignment: AlignmentGeometry.center,
        children: [
          // 旋转动画：ms_youwin_gs
          Positioned(
            width: 246, height: 247,
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: MSImg(name: 'ms_x2_bg', width: 246, height: 247),
                );
              },
            ),
          ),
          Positioned(
              width: 156, height: 99,
              child: MSImg(name: 'ms_fruit_icon', width: 156, height: 99)
          ),
        ],
      ),
    );
  }
}
class RotationYTransition extends AnimatedWidget {
  final Widget child;

  RotationYTransition({required Animation<double> turns, required this.child})
      : super(listenable: turns);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform(
      transform: Matrix4.rotationY(animation.value),
      alignment: Alignment.center,
      child: child,
    );
  }
}
// 新用户奖励
class MSNewAwardDialog extends StatefulWidget {
  MSNewAwardDialog({super.key});

  @override
  State<MSNewAwardDialog> createState() => MSNewAwardDialogState();
}

class MSNewAwardDialogState extends State<MSNewAwardDialog>
    with SingleTickerProviderStateMixin {
  late spine.SpineWidgetController _controller0;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_new_guide2Name, false);
    // 初始化 Spine 控制器
    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 确保动画资源加载后再播放动画
        try {
          controller.animationState.setAnimationByName(0, "animation", true);
          print("Animation started successfully");
        } catch (e) {
          print("Failed to start animation: $e");
        }
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    });
    // 初始化 AnimationController 进行旋转
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(); // 设置旋转动画无限循环

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159) // 完整旋转 360 度
        .animate(CurvedAnimation(parent: _rotationController, curve: Curves.linear));
    ms_event_fire('new_user_reward_v', {});
  }

  @override
  void dispose() {
    _rotationController.dispose(); // 释放资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            child: MSImg(name: 'ms_award_bgs', width: 0.width(context), height: 0.height(context)),
          ),
          Positioned(
            left: (0.width(context) - (0.width(context) * 1.2.w)) * 0.5,
            width: 0.width(context) * 1.2.w,
            height: 0.height(context) * (1.1.h),
            child: spine.SpineWidget.fromAsset('assets/spine/caidai2.atlas', 'assets/spine/caidai2.json', _controller0),
          ),
          Column(
            children: [
              SizedBox(height: 220.h),
              MSImg(name: 'ms_award_title', width: 314, height: 73),
              SizedBox(
                width: 245,
                height: 245,
                child: Stack(
                  children: [
                    AnimatedBuilder(
                      animation: _rotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value, // 动态更新旋转角度
                          child: MSImg(
                              name: 'ms_guang_icons',
                              width: 245,
                              height: 245,
                            ),
                        );
                      },
                    ),
                    Positioned(
                      left: 58,
                      top: 50,
                      child: MSImg(
                        name: 'ms_award_dolas',
                        width: 135,
                        height: 144,
                      ),
                    ),
                    Positioned(
                      top: 132,
                      child: MSGradientStrokeText(
                        text: '\$50.00',
                        gradientColors: [
                          '#FFFFD7'.color(),
                          '#FFEA8F'.color(),
                          '#FFD20B'.color(),
                          '#FFD20B'.color()
                        ],
                        width: 245,
                        height: 40,
                        fontSize: 40,
                        strokeWidth: 2,
                        strokeColor: '#6D450E'.color(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 0.h),
              InkWell(
                onTap: () async {
                  ms_event_fire('new_user_reward_c', {});
                  await MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName, (MSLocalProvider.instance.ms_dolas_number + 50.00));
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  context.tipShow(MSTXTXDialog());
                },
                child: Container(
                  width: 237,
                  height: 64,
                  decoration: BoxDecoration(
                    image: MSDImg('ms_green_btns'),
                  ),
                  child: Center(
                    child: MSStrokeText(
                      text: 'Claim',
                      size: 24,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w700,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 奖金提醒
class MSTXTXDialog extends StatefulWidget {
  MSTXTXDialog({super.key});

  @override
  State<MSTXTXDialog> createState() => MSTXTXDialogState();
}

class MSTXTXDialogState extends State<MSTXTXDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _bgAnimation;
  late Animation<Offset> _textAnimation;

  @override
  void initState() {
    super.initState();

    // 初始化动画控制器
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // 背景图片从左到右
    _bgAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0), // 左边屏幕外
      end: Offset.zero, // 最终位置
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // 文字图片从右到左
    _textAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0), // 右边屏幕外
      end: Offset.zero, // 最终位置
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // 开始动画
    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pop();   // ✔ 正确，关闭当前 dialog
      context.tipShow(MSPopTaskBDialog(is_guide: true));
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景图片
          SlideTransition(
            position: _bgAnimation,
            child: SizedBox(
              width: 0.width(context),
              height: 81.h,
              child: MSImg(name: 'ms_tx_tx_bg'),
            ),
          ),
          // 文字图片
          SlideTransition(
            position: _textAnimation,
            child: SizedBox(
              width: 361,
              height: 79.h,
              child: MSImg(name: 'ms_tx_tx_title'),
            ),
          ),
        ],
      ),
    );
  }
}

// 转盘弹框
class MSLuckyWheelDialog extends StatefulWidget {
  MSLuckyWheelDialog({super.key});

  @override
  State<MSLuckyWheelDialog> createState() => MSLuckyWheelDialogState();
}

class MSLuckyWheelDialogState extends State<MSLuckyWheelDialog> with SingleTickerProviderStateMixin {

  bool is_tap = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      tapwheelSender();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MSImg(name: 'ms_lucky_wheel_title', width: 347, height: 72),
              Container(
                width: 375.w,
                height: 445.w,
                decoration: BoxDecoration(
                    image: MSDImg('ms_wheel_center_bg_0')
                ),
                child: InkWell(onTap: (){
                  tapwheelSender();
                },child: MSScratchWheelPage(imagePath: 'ms_wheel_center_bg_b'.image(),)),
              ),
              MSImg(name: 'ms_lucky_wheel_title2', width: 100, height: 38.5),
            ],
          ),
          Positioned(left: (0.width(context) - 104) * 0.51,top: 350.78.h,child: Container(
            width: 104, height: 126.8,
            decoration: BoxDecoration(
                image: MSDImg('ms_wheel_btn')
            ),
            child: InkWell(
              onTap: (){
                tapwheelSender();
              },
              child: Stack(
                children: [
                  Positioned(top: 56,left: 25,child: MSImg(name: 'ms_wheel_btn1', width: 55, height: 42,))
                ],
              ),
            ),
          )
          ),
        ],
      ),
    );
  }



  Future<void> tapwheelSender() async {

    if (is_tap){
      return;
    }
    is_tap = true;

    await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_wheel_pop_showName, false);

    if (MSLocalProvider.instance.ms_wheel_number <= 0) {

      Navigator.pop(context, 1);
      if (!mounted) return;
      context.tipShow(MSNeedsADialog());

    } else {
      await MSLocalProvider.instance.updateint(
          MSLocalProvider.instance.ms_wheel_numberName,
          MSLocalProvider.instance.ms_wheel_number - 1);

      // 创建一个 Random 实例
      int random = WheelSpin().spinWheel();
      // 生成一个随机索引
      int randomIndex = 1;
      // 获取随机索引
      'random=$random'.log();
      if (random == 100) {
        randomIndex = 1;
      } else if (random == 1000) {
        randomIndex = 2;
      } else if (random == 20) {
        randomIndex = 3;
      } else if (random == 80) {
        randomIndex = 5;
      } else if (random == 50) {
        randomIndex = 0;
      }

      MSScratchWheelStartNotificationService.sendToStartIndexNotification(
          randomIndex);

      Future.delayed(Duration(milliseconds: 1000), () async {
        is_tap = false;
        if (!mounted) return;
        if (random == 1000) {
          // 卡片
          Random random = Random();
          // 生成 0 到 2 之间的随机整数
          int randomNumber = random.nextInt(3);
          if (randomNumber == 0) {
            Navigator.pop(context, 1);
            context.tipShow(MSFruitCardDialog());
          } else if (randomNumber == 1) {
            Navigator.pop(context, 1);
            context.tipShow(MSDoubleCardDialog());
          } else if (randomNumber == 2) {
            Navigator.pop(context, 1);
            context.tipShow(MS777baoCardDialog());
          }
        } else {
          Navigator.pop(context, 1);
          context.tipShow(MSYouWinDialog(award_num: random.toDouble(), index: 0, is_wheel: true));
        }
      });
    }
  }
}
// 发起提现
class MSTXSubmitDialog extends StatefulWidget {
  final int tx_account_index;
  final int tx_number_index;
  MSTXSubmitDialog({super.key, required this.tx_account_index, required this.tx_number_index});

  @override
  State<MSTXSubmitDialog> createState() => MSTXSubmitDialogState();
}

class MSTXSubmitDialogState extends State<MSTXSubmitDialog> with SingleTickerProviderStateMixin {

  final TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 327,
            height: 341,
            decoration: BoxDecoration(
              image: MSDImg('ms_subumit_bg')
            ),
            child: Column(
              children: [
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 8),
                    MSText(text: 'Payment Information', size: 24, color: '#363636'.color(), weight: FontWeight.w700),
                    SizedBox(width: 18),
                    InkWell(onTap: (){
                      Navigator.pop(context);
                    },
                    child: MSImg(name: 'ms_submit_close', width: 24, height: 24),)
                  ],
                ),
                SizedBox(height: 18),
                MSCashActHorizontalImageList(),
                SizedBox(height: 25.2),
                Row(
                  children: [
                    SizedBox(width: 16.7,),
                    MSText(text: 'Account/Phone', size: 15, color: '#000000'.color(), weight: FontWeight.w700),
                  ],
                ),
                SizedBox(height: 13.85),
                Container(
                  width: 282,
                  height: 38,
                  decoration: BoxDecoration(
                    image: MSDImg('ms_submit_tf_bg')
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration:  InputDecoration(
                      labelText: 'E.G. 123456789 Abc.Com ',
                      labelStyle: TextStyle(
                        color: '#A2A2A2'.color(), // 设置字体颜色为蓝色
                        fontSize: 15.0,     // 可选：设置字体大小
                        fontWeight: FontWeight.bold, // 可选：设置字体粗细
                      ),
                      border:  OutlineInputBorder(),
                      // 设置启用状态下的边框颜色
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      // 设置聚焦状态下的边框颜色
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: '#E38AF9'.color()),
                      ),
                    ),
                    style: TextStyle(
                      color: '#000000'.color(), // 设置字体颜色为蓝色
                      fontSize: 17.0,     // 可选：设置字体大小
                      fontWeight: FontWeight.bold, // 可选：设置字体粗细
                    ),
                  ),
                ),
                SizedBox(height: 13.85),
                Row(
                  children: [
                    SizedBox(width: 16.7,),
                    MSText(text: 'Direct To Your Paypal Instant Payment', size: 13, color: '#888888'.color(), weight: FontWeight.w700),
                  ],
                ),
                SizedBox(height: 6.5),
                Row(
                  children: [
                    SizedBox(width: 16.7,),
                    MSText(text: 'Direct To Your Cash app Instant Payment', size: 13, color: '#888888'.color(), weight: FontWeight.w700),
                  ],
                ),
                SizedBox(height: 15.5),
                Container(
                  width: 217,
                  height: 52,
                  decoration: BoxDecoration(
                      color: '#4183EC'.color(),
                      borderRadius: BorderRadius.circular(26)
                  ),
                  child: InkWell(
                    onTap: () async {
                      ms_event_fire('cash_confirm_pop_c', {});
                      if (_controller.text.isNotEmpty){
                        await MSLocalProvider.instance.updateString(MSLocalProvider.instance.ms_account_idName, _controller.text);
                        await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_tx_ing_numberName, widget.tx_number_index);
                        await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_txing_statusName, true);
                        await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_tx_ing_accountName, MSLocalProvider.instance.ms_account_seled_index);
                        await MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName, MSLocalProvider.instance.ms_dolas_number - tx_num_list[widget.tx_number_index]);
                        await MSLocalProvider.instance.updateTXInStatus(1);
                        await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_tx_card_indexName, 0);
                        // 获取当前时间
                        DateTime now = DateTime.now();
                        // 使用 DateFormat 格式化为 yyyy-MM-dd
                        String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                        'formattedDate=$formattedDate'.log();
                        await MSLocalProvider.instance.updateString(MSLocalProvider.instance.ms_tx_date_strName, formattedDate);
                        if (!context.mounted) return;
                        Navigator.pop(context, 1);
                        context.tipShow(MSTXOneToastDialog());
                        MSScratchCashUpdateotificationService.sendToDomandNumberNotification(0);
                        MSDialogTool.toast(context, 'Congratulations on your successful submission');
                      } else {
                        MSDialogTool.toast(context, 'Please Input Your Account ID');
                      }
                    },
                    child: MSStrokeText(text: 'Cash Out', size: 26, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,),
                  ),
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}
// 通知二次召唤
class MSNoticeDialog extends StatefulWidget {
  MSNoticeDialog({super.key});

  @override
  State<MSNoticeDialog> createState() => MSNoticeDialogState();
}

class MSNoticeDialogState extends State<MSNoticeDialog> {


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 326.5.w,
            height: 390.h,
            decoration: BoxDecoration(
              image: MSDImg('ms_notice_bg')
            ),
            child: Column(
              children: [
                SizedBox(height: 25.11.h),
                MSText(text: 'Priority Cash-Out Alerts!', size: 24, color: '#000000'.color(), weight: FontWeight.w700),
                SizedBox(height: 12.h),
                MSImg(name: 'ms_notice_icon', width: 179.5, height: 175.5),
                MSText(text: 'Loyal user exclusive! Enable notifications \n for priority cash-out & high-yield alerts.', size: 15, color: '#363636'.color(), weight: FontWeight.w700, maxLines: 2, align: TextAlign.center),
                SizedBox(height: 27.88.h),
                Container(
                  width: 300,
                  height: 52,
                  decoration: BoxDecoration(
                      color: '#4183EC'.color(),
                      borderRadius: BorderRadius.circular(26)
                  ),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context, 1);
                      AppSettings.openAppSettings(
                        type: AppSettingsType.notification,
                      );
                    },
                    child: MSStrokeText(text: 'Enable for Cash-Out', size: 26, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: 300,
                  height: 52,
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context, 1);
                    },
                    child: MSStrokeText(text: 'Give Up', size: 15, color: '#7D7D7D'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#7D7D7D'.color()),
                  ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}
// 新用户流程通知二次召唤
class MSNewNoticeDialog extends StatefulWidget {
  MSNewNoticeDialog({super.key});

  @override
  State<MSNewNoticeDialog> createState() => MSNewNoticeDialogState();
}

class MSNewNoticeDialogState extends State<MSNewNoticeDialog> {


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 0.width(context),
        height: 0.height(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 326.5.w,
              height: 390.h,
              decoration: BoxDecoration(
                  image: MSDImg('ms_notice_bg')
              ),
              child: Column(
                children: [
                  SizedBox(height: 25.11.h),
                  MSText(text: 'Don’t Miss Tomorrow’s\nBig Reward!', size: 24, color: '#000000'.color(), weight: FontWeight.w700, maxLines: 2, align: TextAlign.center,),
                  SizedBox(height: 12.h),
                  MSImg(name: 'ms_notice_icons', width: 179.5, height: 175.5),
                  MSText(text: 'Turn on notifications for tomorrow’s\nexclusive high-value bonus!', size: 15, color: '#363636'.color(), weight: FontWeight.w700, maxLines: 2, align: TextAlign.center),
                  SizedBox(height: 15.88.h),
                  Container(
                    width: 300,
                    height: 52,
                    decoration: BoxDecoration(
                        color: '#4183EC'.color(),
                        borderRadius: BorderRadius.circular(26)
                    ),
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context, 1);
                        context.tipShow(MSNewGuideADialog());
                        AppSettings.openAppSettings(
                          type: AppSettingsType.notification,
                        );
                      },
                      child: MSStrokeText(text: 'Enable for Cash-Out', size: 26, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: 300,
                    height: 52,
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context, 1);
                        context.tipShow(MSNewGuideADialog());
                      },
                      child: MSStrokeText(text: 'Give Up', size: 15, color: '#7D7D7D'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#7D7D7D'.color()),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
    );
  }
}
// 提现第三天第一步
class MSTXDayThreeOneToastDialog extends StatefulWidget {
  MSTXDayThreeOneToastDialog({super.key});

  @override
  State<MSTXDayThreeOneToastDialog> createState() => MSTXDayThreeOneToastDialogState();
}

class MSTXDayThreeOneToastDialogState extends State<MSTXDayThreeOneToastDialog> with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context, 1);   // ✔ 正确，关闭当前 dialog
      context.tipShow(MSTXDayThreeTwoToastDialog()); // ✔ 正确，继续显示下一个提示
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MSImg(name: 'ms_sahua_icon', width: 298.w, height: 268.h,),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w500,
                      color: '#FFFFFF'.color()
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Security upgraded today~\nSecurity up to ',
                    ),
                    TextSpan(
                      text: '60%',
                      style: TextStyle(color: '#F64949'.color()),
                    ),
                  ],
                ),
              ),

            ],
          )
        ],
      ),
    );
  }
}
// 提现第三天第二步
class MSTXDayThreeTwoToastDialog extends StatefulWidget {
  MSTXDayThreeTwoToastDialog({super.key});

  @override
  State<MSTXDayThreeTwoToastDialog> createState() => MSTXDayThreeTwoToastDialogState();
}

class MSTXDayThreeTwoToastDialogState extends State<MSTXDayThreeTwoToastDialog> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Column(
        children: [
          SizedBox(height: 100.5.h,),
          SizedBox(width: 0.width(context), height: 88,child: MSText(text: '100%\nCASH PAYMENT', size: 40, color: '#FFFFFF'.color(), weight: FontWeight.w700, align: TextAlign.center, maxLines: 2)),
          SizedBox(height: 30.5.h,),
          SizedBox(
            width: 226.88,
            height: 400,
            child: Stack(
              children: [
                MSImg(name: 'ms_tx_pro_list_3')
              ],
            ),
          ),
          SizedBox(width: 0.width(context), height: 66,child: MSText(text: 'Safety Audit Active!\nOpen Daily for Sure Withdrawals!', size: 20, color: '#C8C8C8'.color(), weight: FontWeight.w700, align: TextAlign.center, maxLines: 2)),
          Container(
            width: 337,
            height: 52,
            decoration: BoxDecoration(
                color: '#4183EC'.color(),
                borderRadius: BorderRadius.circular(26)
            ),
            child: InkWell(
              onTap: (){
                Navigator.pop(context);
                context.tipShow(MSTXDayThreeThreeToastDialog());
              },
              child: MSStrokeText(text: 'Go Cash Out!', size: 28, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,),
            ),
          ),
        ],
      ),
    );
  }
}
// 提现第三天第三步
class MSTXDayThreeThreeToastDialog extends StatefulWidget {
  MSTXDayThreeThreeToastDialog({super.key});

  @override
  State<MSTXDayThreeThreeToastDialog> createState() => MSTXDayThreeThreeToastDialogState();
}

class MSTXDayThreeThreeToastDialogState extends State<MSTXDayThreeThreeToastDialog> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width:327.w, height: 232.h,
                    decoration: BoxDecoration(
                        image: MSDImg('ms_shenhe_bg')
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 24.h,),
                        MSImg(name: 'ms_tx_card_big_icon', width: 254.w, height: 143.h),
                      ],
                    ),
                  ),
                  Positioned(top: 165.h,child: SizedBox(width: 327.w, height:60.h,child: MSText(text: '5 Extra Scratch Cards\nToday', size: 24, color: '#363636'.color(), weight: FontWeight.w700,align: TextAlign.center, maxLines: 2,))),
                ],
              ),
              SizedBox(height: 14.28.h),
              Container(
                width: 295,
                height: 52,
                decoration: BoxDecoration(
                    color: '#4183EC'.color(),
                    borderRadius: BorderRadius.circular(26)
                ),
                child: InkWell(
                  onTap: (){
                    MSMegaAds().ms_showAd(context, 'pppuz_withdraw_d3_rv', onCacheResponse: (onCacheResponse) async {
                      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_tx_task_day_indexName, MSLocalProvider.instance.ms_tx_task_day_index + 1);
                      if (!context.mounted) return;
                      Navigator.pop(context, 0);
                    }, adDidClosed: (adDidClosed) async {
                      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_tx_task_day_indexName, MSLocalProvider.instance.ms_tx_task_day_index + 1);
                      if (!context.mounted) return;
                      Navigator.pop(context, 0);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MSImg(name: 'ms_ad_icon',width: 25, height: 25,),
                      SizedBox(width: 4,),
                      MSStrokeText(text: 'Earn More', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,)
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
// 提现第四天第一步
class MSTXDayFourOneToastDialog extends StatefulWidget {
  MSTXDayFourOneToastDialog({super.key});

  @override
  State<MSTXDayFourOneToastDialog> createState() => MSTXDayFourOneToastDialogState();
}

class MSTXDayFourOneToastDialogState extends State<MSTXDayFourOneToastDialog> with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context, 1);   // ✔ 正确，关闭当前 dialog
      context.tipShow(MSTXDayFourTwoToastDialog()); // ✔ 正确，继续显示下一个提示
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MSImg(name: 'ms_sahua_icon', width: 298.w, height: 268.h,),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w500,
                      color: '#FFFFFF'.color()
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '100%\n',
                      style: TextStyle(color: '#F64949'.color(), fontSize: 48),
                    ),
                    TextSpan(
                      text: "Congratulations!\nYou're a High-Trust User!",
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// 提现第四天第二步
class MSTXDayFourTwoToastDialog extends StatefulWidget {
  MSTXDayFourTwoToastDialog({super.key});

  @override
  State<MSTXDayFourTwoToastDialog> createState() => MSTXDayFourTwoToastDialogState();
}

class MSTXDayFourTwoToastDialogState extends State<MSTXDayFourTwoToastDialog> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width:327.w, height: 303.h,
                    decoration: BoxDecoration(
                        image: MSDImg('ms_shenhe_bg')
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 8.5.h,),
                        MSText(text: 'Payment Processing', size: 24, color: '#363636'.color(), weight: FontWeight.w700,align: TextAlign.center, maxLines: 1),
                        MSImg(name: 'ms_time_icon', width: 218.w, height: 218.w),
                      ],
                    ),
                  ),
                  Positioned(top: 202.h,left: 72.w,child: MSText(text: 'Estimated Wait: 2 Days', size: 20, color: '#363636'.color(), weight: FontWeight.w700,align: TextAlign.center, maxLines: 1),),
                  Positioned(top: 228.h,left: 32.w,child: Container(
                    width: 295,
                    height: 52,
                    decoration: BoxDecoration(
                        color: '#4183EC'.color(),
                        borderRadius: BorderRadius.circular(26)
                    ),
                    child: InkWell(
                      onTap: (){
                        MSMegaAds().ms_showAd(context, 'pppuz_withdraw_d4_rv', onCacheResponse: (onCacheResponse) async {
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_tx_task_day_indexName, MSLocalProvider.instance.ms_tx_task_day_index + 1);
                          if (!context.mounted) return;
                          Navigator.pop(context, 0);
                        }, adDidClosed: (adDidClosed) async {
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_tx_task_day_indexName, MSLocalProvider.instance.ms_tx_task_day_index + 1);
                          if (!context.mounted) return;
                          Navigator.pop(context, 0);
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MSImg(name: 'ms_ad_icon',width: 25, height: 25,),
                          SizedBox(width: 8,),
                          MSStrokeText(text: 'Speed Up!', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,)
                        ],
                      ),
                    ),
                  )),
                  Positioned(top: 278.h,left: 140.w,child: InkWell(onTap: () async {
                    ms_event_fire('queue_wait_c', {});
                    if (MSMegaAds().getIntShow() == true){
                      MSMegaAds().ms_showAd(context, 'pppuz_withdraw_d4_int', onCacheResponse: (onCacheResponse) async {
                        await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_tx_task_day_indexName, MSLocalProvider.instance.ms_tx_task_day_index + 1);
                        if (!context.mounted) return;
                        Navigator.pop(context, 0);
                      }, adDidClosed: (adDidClosed) async {
                        await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_tx_task_day_indexName, MSLocalProvider.instance.ms_tx_task_day_index + 1);
                        if (!context.mounted) return;
                        Navigator.pop(context, 0);
                      });
                    } else {
                      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_tx_task_day_indexName, MSLocalProvider.instance.ms_tx_task_day_index + 1);
                      if (!context.mounted) return;
                      Navigator.pop(context, 0);
                    }
                  },child: MSText(text: 'Wait', size: 20, color: '#808080'.color(), weight: FontWeight.w700,align: TextAlign.center, maxLines: 1)),),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

// 广告到达上限
class MSAdLimitDialog extends StatefulWidget {
  MSAdLimitDialog({super.key});

  @override
  State<MSAdLimitDialog> createState() => MSAdLimitDialogState();
}

class MSAdLimitDialogState extends State<MSAdLimitDialog> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width:326.w, height: 303.h,
                    decoration: BoxDecoration(
                        image: MSDImg('ms_shenhe_bg')
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 8.5.h,),
                        MSText(text: 'Daily Ad Limit Reached', size: 24, color: '#363636'.color(), weight: FontWeight.w700,align: TextAlign.center, maxLines: 1),
                        MSImg(name: 'ms_limit_icon', width: 179.02.w, height: 179.02.w),
                      ],
                    ),
                  ),
                  Positioned(top: 202.h,left: 72.w,child: MSText(text: 'Come Back Tomorrow!\nDaily Rewards Await!', size: 20, color: '#808080'.color(), weight: FontWeight.w700,align: TextAlign.center, maxLines: 2),),
                  Positioned(top: 248.h,left: 32.w,child: Container(
                    width: 295,
                    height: 52,
                    decoration: BoxDecoration(
                        color: '#4183EC'.color(),
                        borderRadius: BorderRadius.circular(26)
                    ),
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context);

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MSStrokeText(text: 'Got it', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,)
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

// 广告加载失败现实
class MSAdShowFaildDialog extends StatefulWidget {
  MSAdShowFaildDialog({super.key});

  @override
  State<MSAdShowFaildDialog> createState() => MSAdShowFaildDialogState();
}

class MSAdShowFaildDialogState extends State<MSAdShowFaildDialog> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MSText(text: 'Oops! Ad Issue', size: 40, color: '#FFFFFF'.color(), weight: FontWeight.w700,align: TextAlign.center, maxLines: 1),
          SizedBox(height: 12.h),
          MSImg(name: 'ms_ad_faild_icon', width: 142.w, height: 142.w),
          SizedBox(height: 12.h),
          MSText(text: 'Reward Automatically Added to\nYour Account', size: 20, color: '#E1E1E1'.color(), weight: FontWeight.w700,align: TextAlign.center, maxLines: 2),
          SizedBox(height: 12.h),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 295,
                height: 52,
                decoration: BoxDecoration(
                    color: '#4183EC'.color(),
                    borderRadius: BorderRadius.circular(26)
                ),
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    // MSMegaAds().init();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MSStrokeText(text: 'Claim', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,)
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
// 提现第二天第一步
class MSTXNextDayOneToastDialog extends StatefulWidget {
  MSTXNextDayOneToastDialog({super.key});

  @override
  State<MSTXNextDayOneToastDialog> createState() => MSTXNextDayOneToastDialogState();
}

class MSTXNextDayOneToastDialogState extends State<MSTXNextDayOneToastDialog> with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context, 1);   // ✔ 正确，关闭当前 dialog
      context.tipShow(MSTXNextDayTwoToastDialog()); // ✔ 正确，继续显示下一个提示
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MSImg(name: 'ms_sahua_icon', width: 298.w, height: 268.h,),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w500,
                      color: '#FFFFFF'.color()
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Security upgraded today~\nSecurity up to ',
                    ),
                    TextSpan(
                      text: '40%',
                      style: TextStyle(color: '#F64949'.color()),
                    ),
                  ],
                ),
              ),

            ],
          )
        ],
      ),
    );
  }
}
// 提现第二天第二步
class MSTXNextDayTwoToastDialog extends StatefulWidget {
  MSTXNextDayTwoToastDialog({super.key});

  @override
  State<MSTXNextDayTwoToastDialog> createState() => MSTXNextDayTwoToastDialogState();
}

class MSTXNextDayTwoToastDialogState extends State<MSTXNextDayTwoToastDialog> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Column(
        children: [
          SizedBox(height: 100.5.h,),
          SizedBox(width: 0.width(context), height: 88,child: MSText(text: '100%\nCASH PAYMENT', size: 40, color: '#FFFFFF'.color(), weight: FontWeight.w700, align: TextAlign.center, maxLines: 2)),
          SizedBox(height: 30.5.h,),
          SizedBox(
            width: 226.88,
            height: 400,
            child: Stack(
              children: [
                MSImg(name: 'ms_tx_pro_list_2')
              ],
            ),
          ),
          SizedBox(width: 0.width(context), height: 66,child: MSText(text: 'Safety Audit Active!\nOpen Daily for Sure Withdrawals!', size: 20, color: '#C8C8C8'.color(), weight: FontWeight.w700, align: TextAlign.center, maxLines: 2)),
          Container(
            width: 337,
            height: 52,
            decoration: BoxDecoration(
                color: '#4183EC'.color(),
                borderRadius: BorderRadius.circular(26)
            ),
            child: InkWell(
              onTap: (){
                Navigator.pop(context);
                context.tipShow(MSTXNextDayThreeToastDialog());
              },
              child: MSStrokeText(text: 'Go Cash Out!', size: 28, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,),
            ),
          ),
        ],
      ),
    );
  }
}
// 提现第二天第三步
class MSTXNextDayThreeToastDialog extends StatefulWidget {
  MSTXNextDayThreeToastDialog({super.key});

  @override
  State<MSTXNextDayThreeToastDialog> createState() => MSTXNextDayThreeToastDialogState();
}

class MSTXNextDayThreeToastDialogState extends State<MSTXNextDayThreeToastDialog> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width:327.w, height: 232.h,
                    decoration: BoxDecoration(
                        image: MSDImg('ms_shenhe_bg')
                    ),
                    child: Column(
                      children: [
                        MSImg(name: 'ms_sahua_icon', width: 219.w, height: 198.h),
                      ],
                    ),
                  ),
                  Positioned(top: 183.h,child: SizedBox(width: 327.w, height:25.h,child: MSText(text: 'Free Fee Bonus！', size: 24, color: '#363636'.color(), weight: FontWeight.w700,align: TextAlign.center,))),
                ],
              ),
              SizedBox(height: 12.28.h),
              Container(
                width: 295,
                height: 52,
                decoration: BoxDecoration(
                    color: '#4183EC'.color(),
                    borderRadius: BorderRadius.circular(26)
                ),
                child: InkWell(
                  onTap: (){
                    MSMegaAds().ms_showAd(context, 'pppuz_withdraw_d2_rv', onCacheResponse: (onCacheResponse) async {
                      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_tx_task_day_indexName, MSLocalProvider.instance.ms_tx_task_day_index + 1);
                      if (!context.mounted) return;
                      Navigator.pop(context, 0);
                    }, adDidClosed: (adDidClosed) async {
                      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_tx_task_day_indexName, MSLocalProvider.instance.ms_tx_task_day_index + 1);
                      if (!context.mounted) return;
                      Navigator.pop(context, 0);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MSImg(name: 'ms_ad_icon',width: 25, height: 25,),
                      SizedBox(width: 4,),
                      MSStrokeText(text: 'Claim', size: 26, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: (){
                  if (MSMegaAds().getIntShow() == true){
                    MSMegaAds().ms_showAd(context, 'pppuz_withdraw_d2_int', onCacheResponse: (onCacheResponse) async {
                      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_tx_task_day_indexName, MSLocalProvider.instance.ms_tx_task_day_index + 1);
                      if (!context.mounted) return;
                      Navigator.pop(context, 0);
                    }, adDidClosed: (adDidClosed) async {
                      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_tx_task_day_indexName, MSLocalProvider.instance.ms_tx_task_day_index + 1);
                      if (!context.mounted) return;
                      Navigator.pop(context, 0);
                    });
                  }
                },
                  child: SizedBox(width: 0.width(context), height:25,child: MSText(text: 'Pay 20% Fee', size: 15, color: '#FFFFFF'.color(), weight: FontWeight.w700, align: TextAlign.center)))
            ],
          )
        ],
      ),
    );
  }
}
// 中断任务弹框
class MSTXNextDayFourToastDialog extends StatefulWidget {
  MSTXNextDayFourToastDialog({super.key});

  @override
  State<MSTXNextDayFourToastDialog> createState() => MSTXNextDayFourToastDialogState();
}

class MSTXNextDayFourToastDialogState extends State<MSTXNextDayFourToastDialog> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width:327.w, height: 232.h,
                    decoration: BoxDecoration(
                        image: MSDImg('ms_shenhe_bg')
                    ),
                    child: Column(
                      children: [
                        MSImg(name: 'ms_shenhe_icon', width: 212.w, height: 203.h),
                      ],
                    ),
                  ),
                  Positioned(top: 170.h,child: SizedBox(width: 327.w, height:60.h,child: MSText(text: 'Oops！\nSecurity Boost Paused～', size: 24, color: '#363636'.color(), weight: FontWeight.w700,align: TextAlign.center, maxLines: 2,))),
                ],
              ),
              SizedBox(height: 14.28.h),
              Container(
                width: 295,
                height: 52,
                decoration: BoxDecoration(
                    color: '#4183EC'.color(),
                    borderRadius: BorderRadius.circular(26)
                ),
                child: InkWell(
                  onTap: (){
                    ms_event_fire('cash_break_c', {});
                    MSMegaAds().ms_showAd(context, 'pppuz_withdraw_breakoff_rv', onCacheResponse: (onCacheResponse){
                      Navigator.pop(context, 0);
                    }, adDidClosed: (adDidClosed) async {
                      Navigator.pop(context, 1);
                      if (MSLocalProvider.instance.ms_tx_wait_status == true) {
                        await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_wait_statusName, false);
                        context.tipShow(MSTXFourToastDialog());
                      } else if (MSLocalProvider.instance.ms_tx_task_day_index == 0) {
                        context.tipShow(MSTXNextDayOneToastDialog());
                      } else if (MSLocalProvider.instance.ms_tx_task_day_index == 1) {
                        context.tipShow(MSTXDayThreeOneToastDialog());
                      } else if (MSLocalProvider.instance.ms_tx_task_day_index == 2) {
                        context.tipShow(MSTXDayFourOneToastDialog());
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MSImg(name: 'ms_ad_icon',width: 25, height: 25,),
                      SizedBox(width: 4,),
                      MSStrokeText(text: 'Missed Check-In', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,)
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 295,
                height: 52,
                child: InkWell(
                  onTap: () async {
                    if (MSMegaAds().getIntShow() == true) {
                      MSMegaAds().ms_showAd(context, 'pppuz_withdraw_breakoff_int', onCacheResponse: (onCacheResponse) async {
                        Navigator.pop(context, 1);
                        await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_zhongduan_statusName, true);
                      }, adDidClosed: (adDidClosed) async {
                        Navigator.pop(context, 1);
                        await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_zhongduan_statusName, true);
                      });
                    } else {
                      Navigator.pop(context, 1);
                      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_zhongduan_statusName, true);
                    }
                  },
                  child: Center(
                    child: MSStrokeText(text: 'Give up', size: 18, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
// 提现当天第一步
class MSTXOneToastDialog extends StatefulWidget {
  MSTXOneToastDialog({super.key});

  @override
  State<MSTXOneToastDialog> createState() => MSTXOneToastDialogState();
}

class MSTXOneToastDialogState extends State<MSTXOneToastDialog> with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MSImg(name: 'ms_sahua_icon', width: 298.w, height: 269.h,),
              MSText(text: 'Withdrawal Confirmed！', size: 28, color: '#FFFFFF'.color(), weight: FontWeight.w700),
              SizedBox(height: 20.h),
              Container(
                width: 217,
                height: 52,
                decoration: BoxDecoration(
                    color: '#4183EC'.color(),
                    borderRadius: BorderRadius.circular(26)
                ),
                child: InkWell(
                  onTap: (){
                    ms_event_fire('security_boost_c', {});
                    Navigator.pop(context);
                    context.tipShow(MSTXTwoToastDialog());
                  },
                  child: MSStrokeText(text: 'Cash Out', size: 26, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
// 提现当天第二步
class MSTXTwoToastDialog extends StatefulWidget {
  MSTXTwoToastDialog({super.key});

  @override
  State<MSTXTwoToastDialog> createState() => MSTXTwoToastDialogState();
}

class MSTXTwoToastDialogState extends State<MSTXTwoToastDialog> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pop();   // ✔ 正确，关闭当前 dialog
      context.tipShow(MSTXThreeToastDialog()); // ✔ 正确，继续显示下一个提示
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  MSImg(name: 'ms_anquan_icon', width: 241.w, height: 231.h,),
                ],
              ),
              MSText(text: 'Security Check Processing', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w700),
              SizedBox(height: 20.h),
              MSImg(name: 'ms_anquan_bottom_icon', width: 364, height: 98,),
            ],
          )
        ],
      ),
    );
  }
}
// 提现当天第三步
class MSTXThreeToastDialog extends StatefulWidget {
  MSTXThreeToastDialog({super.key});

  @override
  State<MSTXThreeToastDialog> createState() => MSTXThreeToastDialogState();
}

class MSTXThreeToastDialogState extends State<MSTXThreeToastDialog> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width:327.w, height: 298.h,
                    decoration: BoxDecoration(
                      image: MSDImg('ms_shenhe_bg')
                    ),
                    child: Column(
                      children: [
                        MSImg(name: 'ms_shenhe_icon', width: 213.w, height: 204.h),
                        SizedBox(height: 8.h,),
                        Container(
                          width: 217,
                          height: 52,
                          decoration: BoxDecoration(
                              color: '#4183EC'.color(),
                              borderRadius: BorderRadius.circular(26)
                          ),
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                              context.tipShow(MSTXFourToastDialog());
                            },
                            child: MSStrokeText(text: 'Speed Up！', size: 26, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,),
                          ),
                        ),
                        SizedBox(height: 12.h,),
                        InkWell(onTap: () async {
                          ms_event_fire('queue_wait_c', {});
                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_wait_statusName, true);
                          if (MSMegaAds().getIntShow() == true){
                            MSMegaAds().ms_showAd(context, 'pppuz_withdraw_safe_int', onCacheResponse: (onCacheResponse){
                              Navigator.pop(context, 0);
                            }, adDidClosed: (adDidClosed){
                              Navigator.pop(context, 0);
                            });
                          } else {
                            Navigator.pop(context, 0);
                          }
                        },child: SizedBox(width: 327.w, height:16.h,child: MSText(text: 'Wait 3 Days', size: 15, color: '#7D7D7D'.color(), weight: FontWeight.w700,align: TextAlign.center,)))
                      ],
                    ),
                  ),
                  Positioned(top: 178.h,child: SizedBox(width: 327.w, height:20.h,child: MSText(text: 'Review in 2-3 days', size: 20, color: '#363636'.color(), weight: FontWeight.w700,align: TextAlign.center,))),
                ],
              ),
              SizedBox(height: 11.28.h),
              Container(
                width: 326.8.w,
                height: 42.h,
                decoration: BoxDecoration(
                  color: '#FFFFFF'.color(),
                  borderRadius: BorderRadius.circular(21.h)
                ),
                child: Row(
                  children: [
                    SizedBox(width: 8.65.w),
                    MSText(text: MSLocalProvider.instance.ms_account_id, size: 20, color: '#000000'.color(), weight: FontWeight.w700),
                    Spacer(),
                    MSText(text: 'Review for 1 day', size: 16, color: '#000000'.color(), weight: FontWeight.w700),
                    SizedBox(width: 15.w),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
// 提现当天第四步
class MSTXFourToastDialog extends StatefulWidget {
  MSTXFourToastDialog({super.key});

  @override
  State<MSTXFourToastDialog> createState() => MSTXFourToastDialogState();
}

class MSTXFourToastDialogState extends State<MSTXFourToastDialog> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width:327.w, height: 287.h,
                    decoration: BoxDecoration(
                        image: MSDImg('ms_tx_task_bg')
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 12.h,),
                        MSText(text: 'Withdrawal Boost', size: 24, color: '#363636'.color(), weight: FontWeight.w700),
                        SizedBox(height: 22.65.h,),
                        Container(
                          width: 294.4.w,
                          height: 113.5.h,
                          decoration: BoxDecoration(
                            image: MSDImg('ms_tx_task_center')
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: .spaceEvenly,
                                children: [
                                  MSImg(name: 'ms_smail_card', width: 27, height: 28,),
                                  MSText(text: 'Scratch 50 Cards', size: 15, color: '#000000'.color(), weight: FontWeight.w700),
                                  MSText(text: '${MSLocalProvider.instance.ms_tx_card_index}/50', size: 15, color: '#000000'.color(), weight: FontWeight.w700),
                                ],
                              ),
                              SizedBox(height: 20.h,),
                              Row(
                                mainAxisAlignment: .spaceEvenly,
                                children: [
                                  MSImg(name: 'ms_smail_indexs', width: 22, height: 25,),
                                  MSText(text: 'Play Daily for 2 Days', size: 15, color: '#000000'.color(), weight: FontWeight.w700),
                                  MSText(text: '1/2', size: 15, color: '#000000'.color(), weight: FontWeight.w700),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 18.h,),
                        SizedBox(width: 327.w, height:16.h,child: MSText(text: '（Surprise coming tomorrow~）', size: 14, color: '#7D7D7D'.color(), weight: FontWeight.w700,align: TextAlign.center,)),
                        SizedBox(height: 18.h,),
                        Container(
                          width: 217,
                          height: 52,
                          decoration: BoxDecoration(
                              color: '#4183EC'.color(),
                              borderRadius: BorderRadius.circular(26)
                          ),
                          child: InkWell(
                            onTap: (){
                              ms_event_fire('task_go_c', {});
                              Navigator.pop(context, 1);
                              MSNavigationService().changeTab(0);
                            },
                            child: MSStrokeText(text: 'Go', size: 26, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
// 提现当天第五步
class MSTXFiveToastDialog extends StatefulWidget {
  MSTXFiveToastDialog({super.key});

  @override
  State<MSTXFiveToastDialog> createState() => MSTXFiveToastDialogState();
}

class MSTXFiveToastDialogState extends State<MSTXFiveToastDialog> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 120.h,child: MSImg(name: 'ms_oops_icon', width: 375.w, height: 428.h)),
          Positioned(top: 420.h,child: SizedBox(width: 0.width(context), height: 88,child: MSText(text: 'Oops\nLow Security', size: 36, color: '#FFFFFF'.color(), weight: FontWeight.w700, align: TextAlign.center, maxLines: 2))),
          Positioned(
            top: 540.h,
            child: Container(
              width: 337,
              height: 52,
              decoration: BoxDecoration(
                  color: '#4183EC'.color(),
                  borderRadius: BorderRadius.circular(26)
              ),
              child: InkWell(
                onTap: (){
                  Navigator.pop(context, 1);
                  context.tipShow(MSTXSixToastDialog());
                },
                child: MSStrokeText(text: 'Boost Security Now!', size: 28, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 提现当天第六步
class MSTXSixToastDialog extends StatefulWidget {
  MSTXSixToastDialog({super.key});

  @override
  State<MSTXSixToastDialog> createState() => MSTXSixToastDialogState();
}

class MSTXSixToastDialogState extends State<MSTXSixToastDialog> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Column(
        children: [
          SizedBox(height: 100.5.h,),
          SizedBox(width: 0.width(context), height: 88,child: MSText(text: '100%\nCASH PAYMENT', size: 40, color: '#FFFFFF'.color(), weight: FontWeight.w700, align: TextAlign.center, maxLines: 2)),
          SizedBox(height: 30.5.h,),
          SizedBox(
            width: 226.88,
            height: 400,
            child: Stack(
              children: [
                MSImg(name: 'ms_tx_pro_list_1')
              ],
            ),
          ),
          SizedBox(width: 0.width(context), height: 66,child: MSText(text: 'Safety Audit Active!\nOpen Daily for Sure Withdrawals!', size: 20, color: '#C8C8C8'.color(), weight: FontWeight.w700, align: TextAlign.center, maxLines: 2)),
          Container(
              width: 337,
              height: 52,
              decoration: BoxDecoration(
                  color: '#4183EC'.color(),
                  borderRadius: BorderRadius.circular(26)
              ),
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                  context.tipShow(MSTXSevenToastDialog());
                },
                child: MSStrokeText(text: 'Go Cash Out!', size: 28, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,),
              ),
          ),
        ],
      ),
    );
  }
}

// 提现当天第七步
class MSTXSevenToastDialog extends StatefulWidget {
  MSTXSevenToastDialog({super.key});

  @override
  State<MSTXSevenToastDialog> createState() => MSTXSevenToastDialogState();
}

class MSTXSevenToastDialogState extends State<MSTXSevenToastDialog> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          Container(
            width: 326.7.w, height: 283.h,
            decoration: BoxDecoration(
              image: MSDImg('ms_tx_task_bg')
            ),
            child: Column(
              children: [
                MSImg(name: 'ms_sahua_icon', width: 219.4, height: 195),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: '#363636'.color()
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Security upgraded today~\nSecurity up to ',
                      ),
                      TextSpan(
                        text: '10%',
                        style: TextStyle(color: '#F64949'.color()),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  width: 295,
                  height: 52,
                  decoration: BoxDecoration(
                      color: '#4183EC'.color(),
                      borderRadius: BorderRadius.circular(26)
                  ),
                  child: InkWell(
                    onTap: () async {
                      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_wait_statusName, false);
                      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_tx_task_day_indexName, MSLocalProvider.instance.ms_tx_task_day_index + 1);
                      MSScratchCashUpdateotificationService.sendToDomandNumberNotification(0);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
                    child: MSStrokeText(text: 'Earn More', size: 28, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0, skColor: '#1D5814'.color(),is_btn: true,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class MSCashActHorizontalImageList extends StatefulWidget {
  MSCashActHorizontalImageList({super.key});
  @override
  State<MSCashActHorizontalImageList> createState() => MSCashActHorizontalImageListState();
}

class MSCashActHorizontalImageListState extends State<MSCashActHorizontalImageList> {
  // 定义 7 个 Item 的尺寸（宽×高）
  final List<List<double>> itemSizes = [
    [146.2,44.2],
    [146.2,44.2],
    [146.2,44.2],
    [146.2,44.2],
  ];
  final List<List<double>> itemSeletcdSizes = [
    [146.2,44.2],
    [146.2,44.2],
    [146.2,44.2],
    [146.2,44.2],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // 容器高度稍大于Item高度，避免裁剪
      height: 44.2,
      padding: const EdgeInsets.symmetric(horizontal: 12.5),
      child: ListView.builder(
        // 横向滑动
        scrollDirection: Axis.horizontal,
        // 取消滚动到边缘的水波纹效果
        physics: const BouncingScrollPhysics(),
        // 7个Item
        itemCount: 4,
        // 每个Item之间的间距
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 6.0), // 右侧间距
            child: _buildImageItem(index),
          );
        },
      ),
    );
  }

  // 构建单个图片Item
  Widget _buildImageItem(int index) {
    final size = MSLocalProvider.instance.ms_account_seled_index == index ? itemSizes[index] : itemSeletcdSizes[index];
    return SizedBox(
      width: size.first,
      height: size.last,
      child: InkWell(
          onTap: () async {
            await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_account_seled_indexName, index);
            setState(() {});
          },
          child: Stack(
            children: [
              Positioned(bottom: 0,child: MSImg(name: 'ms_act_sele_${MSLocalProvider.instance.ms_account_seled_index == index ? 's' : 'n'}_$index', width: size.first, height: size.last))
            ],
          )),
    );
  }
}

// 瓜分奖金池
class MSAwardPoolDialog extends StatefulWidget {
  final int index;
  final int award_num;
  final int time_index;
  MSAwardPoolDialog({super.key, required this.award_num, required this.time_index, required this.index});

  @override
  State<MSAwardPoolDialog> createState() => MSAwardPoolDialogState();
}

class MSAwardPoolDialogState extends State<MSAwardPoolDialog>
    with SingleTickerProviderStateMixin {

  late AnimationController _rotationController;

  late Animation<double> _rotationAnimation;
  // 总倒计时时间，单位是秒
  int _remainingTime = MSLocalProvider.instance.ms_dao_time_index; // 5 分钟倒计时（300秒）

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    ms_event_fire('new_bonus_pop_v', {});
    ms_event_fire('bonus_pool_v_n', {});
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    });
    // 初始化 AnimationController 进行旋转
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(); // 设置旋转动画无限循环

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159) // 完整旋转 360 度
        .animate(CurvedAnimation(parent: _rotationController, curve: Curves.linear));
    _startCountdown();
  }

  // 启动倒计时
  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
          MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_dao_time_indexName, _remainingTime);
        });
      } else {
        setState(() {
          MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_dao_time_indexName, 0);
        });
        _timer.cancel(); // 时间到，取消定时器
      }
    });
  }

  // 将秒数转化为格式化时间（00:00:00）
  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(remainingSeconds)}';
  }

  // 保证时间两位数
  String _twoDigits(int n) {
    if (n >= 10) {
      return "$n";
    } else {
      return "0$n";
    }
  }

  @override
  void dispose() {
    _rotationController.dispose(); // 释放资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              SizedBox(height: 220.h),
              Container(
                width: 284.w, height: 260,
                decoration: BoxDecoration(
                  image: MSDImg('ms_dao_bg')
                ),
                child: Stack(
                  children: [
                    Positioned(left: 68.w,top: -12,
                      child: AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationAnimation.value, // 动态更新旋转角度
                            child: MSImg(
                              name: 'ms_guang_icon',
                              width: 150.w,
                              height: 150.w,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(left: (284.w - 120.w) * 0.55, top: 12.h,child: MSImg(name: 'ms_dao_icon', width: 120.w, height: 120.h)),
                    Positioned(top: 128,child: MSGradientStrokeText(
                      text: '\$${widget.award_num}',
                      gradientColors: [
                        '#FFFFD7'.color(),
                        '#FFEA8F'.color(),
                        '#FFD20B'.color(),
                        '#FFD20B'.color()
                      ],
                      width: 284.w,
                      height: 40,
                      fontSize: 40,
                      strokeWidth: 2,
                      strokeColor: '#6D450E'.color(),
                    ),),
                    Positioned(left: (283.w - 229) * 0.5,top: 178,child: MSImg(name: 'ms_dao_title', width: 229, height: 23,)),
                    Positioned(
                      left: (283.w - 193) * 0.5,
                      bottom: 8,
                      child: Visibility(
                        visible: _remainingTime > 0,
                        child: Container(
                          width: 193,
                          height: 42,
                          decoration: BoxDecoration(
                              image: MSDImg('ms_dao_bgs')
                          ),
                          child: Center(
                            child: MSStrokeText(text: _formatTime(_remainingTime), size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#000000'.color()),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 42.h),
              InkWell(
                onTap: () async {
                  ms_event_fire('new_bonus_pop_c', {});
                  ms_event_fire('bonus_pop_c', {'source_from:' : _getindexName()});
                  // 首次不看广告
                  if (!MSLocalProvider.instance.ms_first_pool) {
                    await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_first_poolName, true);
                    await MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName, MSLocalProvider.instance.ms_dolas_number + widget.award_num);
                    await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_pool_showName, false);
                    await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_dao_time_indexName, 300);
                    await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_pool_indexName, 0);
                    if (!context.mounted)return;
                    Navigator.pop(context, 1);
                  } else {
                    MSMegaAds().ms_showAd(context, 'pppuz_bonus_rv', onCacheResponse: (onCacheResponse){
                      Navigator.pop(context, 0);
                    }, adDidClosed: (adDidClosed) async {
                      await MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName, MSLocalProvider.instance.ms_dolas_number + widget.award_num);
                      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_pool_showName, false);
                      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_pool_indexName, 0);
                      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_dao_time_indexName, 300);
                      if (!context.mounted)return;
                      Navigator.pop(context, 1);
                    });
                  }
                },
                child: Container(
                  width: 255,
                  height: 68,
                  decoration: BoxDecoration(
                    image: MSDImg('ms_green_btns'),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MSImg(name: 'ms_ad_icon', width: 25, height: 25,),
                      SizedBox(width: 8,),
                      MSStrokeText(
                        text: 'Grab Money Now',
                        size: 20,
                        color: '#FFFFFF'.color(),
                        weight: FontWeight.w700,
                        skWidth: 1,
                        skColor: '#000000'.color(),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.pop(context, 0);
                },
                child: SizedBox(
                  width: 255,
                  height: 44,
                  child: Center(
                    child: MSStrokeText(
                      text: 'Skip Early Access',
                      size: 15,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w700,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Positioned(left: (0.width(context) - 193) * 0.5,bottom: 370.h,child: Visibility(
          //   visible: _remainingTime > 0,
          //   child: Container(
          //     width: 193,
          //     height: 42,
          //     decoration: BoxDecoration(
          //         image: MSDImg('ms_dao_bgs')
          //     ),
          //     child: Center(
          //       child: MSStrokeText(text: _formatTime(_remainingTime), size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#000000'.color()),
          //     ),
          //   ),
          // )),
        ],
      ),
    );
  }

  String _getindexName(){
    String name = 'number';
    if (widget.index == 1){
      name = 'diamond';
    } else if (widget.index == 2){
      name = 'fruit';
    } else if (widget.index == 3){
      name = 'emoji';
    } else if (widget.index == 4){
      name = 'pot';
    } else if (widget.index == 5){
      name = '77';
    } else if (widget.index == 6){
      name = 'cash';
    } else if (widget.index == 0){
      name = 'number';
    } else if (widget.index == -1){
      name = 'home';
    }  else {
      name = 'wheel';
    }
    return name;
  }
}
// 签到
class MSPopTaskBDialog extends StatefulWidget {
  final bool is_guide;
  MSPopTaskBDialog({super.key, required this.is_guide});
  @override
  State<MSPopTaskBDialog> createState() => MSPopTaskBDialogState();
}

class MSPopTaskBDialogState extends State<MSPopTaskBDialog> {

  List<int> awardNum = [1, 12, 28, 35, 45, 47, 50];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.is_guide){
      ms_event_fire('day7_task_v', {});
    } else {
      ms_event_fire('old_user_7day_v', {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 330.w,
            height: 472.h,
            decoration: BoxDecoration(
                image: MSDImg('ms_sigin_bg')
            ),
            child: Column(
              children: [
                SizedBox(height: 12.h,),
                MSStrokeText(text: '7-Day Streak: Day ${MSLocalProvider.instance.ms_sign_index + 1}/7', size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w800, skWidth: 1, skColor: '#000000'.color()),
                SizedBox(height: 42.h,),
                SizedBox(
                  width: 310.w,
                  height: 200.h,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 一行3个
                      mainAxisSpacing: 8.w, // 垂直间距
                      crossAxisSpacing: 8.h, // 水平间距
                      childAspectRatio: 1 / 0.95, // 宽高比
                    ),
                    itemCount: 6,
                    padding: EdgeInsets.only(top: 0.h, left: 12.w,), // 移除默认的padding// 最多显示10个
                    itemBuilder: (context, index) {
                      return SizedBox(
                          width: 95,
                          height: 96,
                          child: Stack(
                              children: [
                                MSImg(name: MSLocalProvider.instance.ms_sign_index == index ? 'ms_sigin_seletecd_s' : 'ms_sigin_seletecd_n', width: 95, height: 96,),
                                Positioned(
                                  top: 8,
                                  child: Transform.rotate(
                                    angle: -pi / 4, // -pi/4 is 45 degrees in radians
                                    child: MSStrokeText(
                                      text: 'DAY ${1 + index}',
                                      size: 11,
                                      color: '#FFFFFF'.color(),
                                      weight: FontWeight.w700,
                                      skWidth: 0.5,
                                      skColor: '#5A10AB'.color(),
                                    ),
                                  ),
                                ),
                                Positioned(left: 23, top: 20, child: MSImg(name: 'ms_sigin_dola_$index', width: 50, height: 42,)),
                                Positioned(left: 30, top:60, child: MSStrokeText(text: '\$${awardNum[index]}', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#532228'.color())),
                                Positioned(right: 8,child: Visibility(visible: index >= MSLocalProvider.instance.ms_sign_index + 1,child: MSImg(name: 'ms_sigin_unlock_icon', width: 28, height: 29,))),
                                Positioned(child: Visibility(
                                  visible: MSLocalProvider.instance.ms_sign_index > index,
                                  child: Container(
                                    width: 95,
                                    height: 96,
                                    decoration: BoxDecoration(
                                      color:'#000000'.color(opacity: 0.5),
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Center(
                                      child: MSImg(name: 'ms_dui_icon', width: 45.6, height: 44.5,),
                                    ),
                                  ),
                                ))
                              ]
                          )
                      );
                    },
                  ),
                ),
                SizedBox(height: 0.h,),
                InkWell(
                  onTap: (){

                  },
                  child: Container(
                    width: 303.w,
                    height: 95.h,
                    decoration: BoxDecoration(
                      image: MSDImg('ms_sigin_7_bg')
                    ),
                    child: Stack(
                      children: [
                        MSImg(name: 'ms_sigin_seletecd_right', width: 38.5, height: 38.2,),
                        Positioned(
                          top: 8,
                          child: Transform.rotate(
                            angle: -pi / 4, // -pi/4 is 45 degrees in radians
                            child: MSStrokeText(
                              text: 'DAY 7',
                              size: 11,
                              color: '#FFFFFF'.color(),
                              weight: FontWeight.w700,
                              skWidth: 0.5,
                              skColor: '#5A10AB'.color(),
                            ),
                          ),
                        ),
                        Positioned(left: (303.w - 50) * 0.5, top: 20,child: MSImg(name: 'ms_sigin_dola_6', width: 50, height: 42,)),
                        Positioned(left: (0.width(context) - 120) * 0.5, top:72, child: MSStrokeText(text: '\$${awardNum[6]}', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#532228'.color())),
                        Positioned(right: 0,child: Visibility(visible: 6 >= MSLocalProvider.instance.ms_sign_index + 1,child: MSImg(name: 'ms_sigin_unlock_icon', width: 28, height: 29,))),
                        Positioned(child: Visibility(
                          visible: MSLocalProvider.instance.ms_sign_index > 6,
                          child: Container(
                            width: 303.w,
                            height: 95.h,
                            decoration: BoxDecoration(
                                color:'#000000'.color(opacity: 0.5),
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Center(
                              child: MSImg(name: 'ms_dui_icon', width: 45.6, height: 44.5,),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 36.h,),
                InkWell(
                  onTap: () async {
                    if (widget.is_guide){
                      ms_event_fire('day7_task_c', {});
                    } else {
                      ms_event_fire('old_user_7day_c', {});
                    }
                    if (MSLocalProvider.instance.ms_today_sign_status == true){
                      Navigator.pop(context, 0);
                    } else {
                      if (MSLocalProvider.instance.ms_frist_singn_status == true){
                        await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_frist_singn_statusName, false);
                        await MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName,MSLocalProvider.instance.ms_dolas_number + awardNum[MSLocalProvider.instance.ms_sign_index]);
                        await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_sign_indexName, MSLocalProvider.instance.ms_sign_index + 1);
                        await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_today_sign_statusName, true);
                        if (MSLocalProvider.instance.ms_sign_index >= 7){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_sign_indexName, 0);
                        }
                        MSDialogTool.toast(context, "Tomorrow's Bonus Awaits!");
                        Navigator.pop(context, 0);
                        if (widget.is_guide){
                          if (!context.mounted) return;
                          context.tipShow(MSNewGuideADialog());
                        }
                      } else {
                        // ad
                        MSMegaAds().ms_showAd(context, 'pppuz_7d_rv', onCacheResponse: (onCacheResponse){
                          Navigator.pop(context, 0);
                        }, adDidClosed: (adDidClosed) async {
                          await MSLocalProvider.instance.updatedouble(MSLocalProvider.instance.ms_dolas_numberName,MSLocalProvider.instance.ms_dolas_number + awardNum[MSLocalProvider.instance.ms_sign_index]);
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_sign_indexName, MSLocalProvider.instance.ms_sign_index + 1);
                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_today_sign_statusName, true);
                          if (MSLocalProvider.instance.ms_sign_index >= 7){
                            await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_sign_indexName, 0);
                          }
                          MSDialogTool.toast(context, "Tomorrow's Bonus Awaits!");
                          Navigator.pop(context, 1);
                          if (widget.is_guide){
                            if (!context.mounted) return;
                            context.tipShow(MSNewGuideADialog());
                          }
                        });
                      }
                    }
                  },
                  child: Container(
                    width: 237,
                    height: 64,
                    decoration: BoxDecoration(
                      image: MSDImg('ms_green_btns'),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (MSLocalProvider.instance.ms_frist_singn_status != true && MSLocalProvider.instance.ms_today_sign_status == false)
                          MSImg(name: 'ms_ad_icon', width: 24.7, height: 24.7,),
                        if (MSLocalProvider.instance.ms_frist_singn_status != true && MSLocalProvider.instance.ms_today_sign_status == false)
                          SizedBox(width: 8,),
                          MSStrokeText(
                          text: MSLocalProvider.instance.ms_today_sign_status == true ? 'Tomorrow' : 'Claim',
                          size: 24,
                          color: '#FFFFFF'.color(),
                          weight: FontWeight.w700,
                          skWidth: 1,
                          skColor: '#000000'.color(),
                        )
                      ],
                    )
                    // Stack(
                    //   children: [
                    //     Positioned(left: MSLocalProvider.instance.ms_frist_singn_status != true && MSLocalProvider.instance.ms_today_sign_status == false ? 66 : 110,top: 16,
                    //       child: MSStrokeText(
                    //         text: MSLocalProvider.instance.ms_today_sign_status == true ? 'Tomorrow' : 'Claim',
                    //         size: 24,
                    //         color: '#FFFFFF'.color(),
                    //         weight: FontWeight.w700,
                    //         skWidth: 1,
                    //         skColor: '#000000'.color(),
                    //       ),
                    //     ),
                    //     Positioned(left: 80,top: 18,child: Visibility(visible: MSLocalProvider.instance.ms_frist_singn_status != true && MSLocalProvider.instance.ms_today_sign_status == true,child: MSImg(name: 'ms_ad_icon', width: 24.7, height: 24.7,)))
                    //   ],
                    // ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(right: 30.w, top: (0.height(context) - 551.h) * 0.35, child: InkWell(
            onTap: (){
              if (MSMegaAds().getIntShow() == true){
                MSMegaAds().ms_showAd(context, 'pppuz_7d_close_int', onCacheResponse: (onCacheResponse){
                  Navigator.pop(context, 0);
                  if (widget.is_guide){
                      if (!context.mounted) return;
                      context.tipShow(MSNewGuideADialog());
                  }
                }, adDidClosed: (adDidClosed) async {
                  Navigator.pop(context, 0);
                  if (widget.is_guide){
                      if (!context.mounted) return;
                      context.tipShow(MSNewGuideADialog());
                  }
                });
              } else {
                Navigator.pop(context, 0);
                if (widget.is_guide){
                    if (!context.mounted) return;
                    context.tipShow(MSNewGuideADialog());
                }
              }
            },
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: MSImg(name: 'ms_close_btn', width: 16, height: 16,),
              ),
            ),
          )),
          Positioned(right: (0.width(context) - 344) * 0.5, top: 94.h + 30.h, child:MSImg(name: 'ms_taska_title_bg', width: 344, height: 41,)),
          Positioned(right: (0.width(context) - 351) * 0.5, top: 96.h + 30.h, child:MSImg(name: 'ms_taska_title', width: 351, height: 50,)),
        ],
      ),
    );
  }


  bool showbgs(int index){
    if (MSLocalProvider.instance.ms_login_award_0 == false && index == 0){
      return false;
    } else if (index == 1 && MSLocalProvider.instance.ms_login_award_1 == false){
      return false;
    } else if (index == 2 && MSLocalProvider.instance.ms_login_award_2 == false){
      return false;
    } else if (index == 3 && MSLocalProvider.instance.ms_login_award_3 == false){
      return false;
    } else if (index == 4 && MSLocalProvider.instance.ms_login_award_4 == false){
      return false;
    } else if (index == 5 && MSLocalProvider.instance.ms_login_award_5 == false){
      return false;
    } else if (index == 6 && MSLocalProvider.instance.ms_login_award_6 == false){
      return false;
    }
    return true;
  }

}

///******************** A **************************///
// youwin-A
class MSYouWinADialog extends StatefulWidget {
  final int award;
  MSYouWinADialog({super.key, required this.award});
  @override
  State<MSYouWinADialog> createState() => MSYouWinADialogState();
}

class MSYouWinADialogState extends State<MSYouWinADialog> with TickerProviderStateMixin{
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  late final AnimationController _scaleController1;
  late final Animation<double> _scaleAnimation1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      playbgMUsic();
    });

    // 顶部图片放大缩小动画 ✅ 修复版
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _scaleAnimation = Tween(begin: 1.0, end: 1.1)
        .animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));

    // 顶部图片放大缩小动画 ✅ 修复版
    _scaleController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _scaleAnimation1 = Tween(begin: 1.0, end: 1.1)
        .animate(CurvedAnimation(parent: _scaleController1, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      playbgMUsic();
    });

  }

  Future<void> playbgMUsic() async {
    if (MSLocalProvider.instance.ms_sound_music){
      await MSAudioUtils().playAward1Audio();
      Future.delayed(Duration(milliseconds: 1000), () async {
        await MSAudioUtils().playAward1Audio();
      });
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _scaleController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        children: [
          Positioned(top: 288.h, left: (0.width(context) - 245.w) * 0.5, child: ScaleTransition(scale: _scaleAnimation1,child: MSImg(name: 'ms_youwin_g', width: 245.w, height: 246.w))),
          Positioned(top: 130.h, left: (0.width(context) - 301.w) * 0.5, child: ScaleTransition(scale: _scaleAnimation,child: MSImg(name: 'ms_youwin_title', width: 301.w, height: 223.h))),          Positioned(top: 288.h, left: (0.width(context) - 245.w) * 0.5, child: ScaleTransition(scale: _scaleAnimation1,child: MSImg(name: 'ms_youwin_g', width: 245.w, height: 246.w))),
          Positioned(top: 338.h, left: (0.width(context) - 189.w) * 0.5, child:MSImg(name: 'ms_youwin_domand', width: 189.w, height: 142.w)),
          Positioned(top: 440.h, left: (0.width(context) - 260.w) * 0.5, child:MSGradientStrokeText(text: '${(widget.award).toStringAsFixed(2)}', gradientColors: ['#FFFFD7'.color(),'#FFEA8F'.color(),'#FFD20B'.color(),'#FFD20B'.color(),], fontSize: 40, strokeWidth: 2, strokeColor: '#6D450E'.color(),width: 260.w, height: 40.h,)),
          Positioned(top: 550.h,left: (0.width(context) - 260) * 0.5, child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: (){
                // ad 给双倍奖励
                MSAdAHelper().show(context, (hasCache){
                  if (!hasCache){
                    Navigator.pop(context, 1);
                    MSAdAHelper().resetBlock();
                  }
                }, (finished) async {
                  Navigator.pop(context, 1);
                  MSAdAHelper().resetBlock();
                  await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_domand_numberName, MSLocalProvider.instance.ms_domand_number + (widget.award * 2));
                });
              },
              child: Container(
                width: 255, height: 55,
                decoration: BoxDecoration(image: MSDImg('ms_green_bg_btn')),
                child: Stack(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 32),child: Center(child: MSGradientStrokeText(text: 'Claim ${(widget.award * 2).toStringAsFixed(2)}', gradientColors: ['#BE982A'.color(),'#FFE9A3'.color(),'#FFF6D7'.color(),'#FFF0B4'.color(),], fontSize: 20, strokeWidth: 2, strokeColor: '#000000'.color(),width: 260, height: 40,))),
                    Positioned(left:42, top:16,child: MSImg(name: 'ms_ad_icon', width: 24.9, height: 24.5,))
                  ],
                )
              )
          )),
          Positioned(top: 550.h + 66 ,left: (0.width(context) - 260.w) * 0.5, child: InkWell(
            onTap: () async {
              Navigator.pop(context, 0);
              await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_domand_numberName, MSLocalProvider.instance.ms_domand_number + widget.award);
            },
            child: SizedBox(width: 260.w, height:50,child: MSUnderlineTextButton(text: '${widget.award.toStringAsFixed(2)}', fontSize: 20.sp, underlineColor: '#EFEDED'.color(),gradientColors: ['#EFEDED'.color()])),
          )),
        ],
      ),
    );
  }
}
// 新用户引导
class MSNewGuideADialog extends StatefulWidget {
  MSNewGuideADialog({super.key});
  @override
  State<MSNewGuideADialog> createState() => MSNewGuideADialogState();
}

class MSNewGuideADialogState extends State<MSNewGuideADialog>
    with SingleTickerProviderStateMixin {
  late spine.SpineWidgetController _controller0;

@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    });
    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });
    ms_event_fire('card_list_guide_v', {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: InkWell(
        onTap: () async {
          ms_event_fire('card_list_guide_c', {});
          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_new_guide1Name, true);
          Navigator.pop(context, 0);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (builder) {
                return MSScrachDetails_b(
                    index: 0);
              },
            ),
          );
        },
        child: Stack(
          children: [
            Positioned(top: 347.1.h, left: (0.width(context) - 275) * 0.5, child: MSImg(name: 'ms_guide_0', width: 275, height: 87.86)),
            Positioned(top: 120.h, left: (0.width(context) - 363.w) * 0.5, child: MSImg(name: 'ms_scratch_list_0', width: 363.w, height: 166.h,)),
            Positioned(top: 228.h,child: Row(
              children: [
                SizedBox(width: 118.w,),
                MSStrokeText(text: 'Win Up To', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#413210'.color()),
                SizedBox(width: 10.w,),
                MSImg(name: 'ms_dolas_icon', width: 19, height: 19,),
                SizedBox(width: 10.w,),
                MSStrokeText(text: '50', size: 16, color: '#FBF544'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#322107'.color()),
              ],
            )),
            Positioned(top: 260.h,left: (0.width(context) - 196) * 0.5,child: InkWell(
              child: Container(
                width: 196, height: 45,
                decoration: BoxDecoration(
                    image: MSDImg('ms_go_btns_s')
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 12.w,),
                    MSStrokeText(text: 'GO PLAY！', size: 18, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#713409'.color()),
                  ],
                ),
              ),
            )
            ),
            Positioned(
              right: 38.w,
              top: 231.h,
              child: Consumer<MSLocalProvider>(
                  builder:(context, provider, child) {
                    return MSStrokeText(text: '0/10', size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0.5, skColor: '#49100F'.color());
                  }),
            ),
            Positioned(
              top: 240.h,
              right: 0,
              width: 80,
              height: 80,
              child: Lottie.asset(
                width: 80,
                height: 80,
                fit: BoxFit.fill,
                "ms_shou_anmation.zip".files(),
                repeat: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// miss-A
class MSWheelAwardADialog extends StatefulWidget {
  final int award;
  MSWheelAwardADialog({super.key, required this.award});
  @override
  State<MSWheelAwardADialog> createState() => MSWheelAwardADialogState();
}

class MSWheelAwardADialogState extends State<MSWheelAwardADialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    });

    // 顶部图片放大缩小动画 ✅ 修复版
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _scaleAnimation = Tween(begin: 1.0, end: 1.1)
        .animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        children: [
          Positioned(top: 165.6.h, left: (0.width(context) - 331.5.w) * 0.5, child: MSImg(name: 'ms_wheelaward_top1', width: 331.5.w, height: 83.2.h)),
          Positioned(top: 189.9.h, left: (0.width(context) - 322.w) * 0.5, child: MSImg(name: 'ms_wheelaward_top2', width: 322.w, height: 25.62.h)),
          Positioned(top: 233.22.h, left: (0.width(context) - 245.w) * 0.5, child: ScaleTransition(scale: _scaleAnimation,child: MSImg(name: 'ms_youwin_g', width: 245.w, height: 246.w))),
          Positioned(top: 282.54.h, left: (0.width(context) - 188.85.w) * 0.5, child: MSImg(name: 'ms_youwin_domand', width: 188.85.w, height: 141.64.h)),
          Positioned(top: 410.24.h, left: (0.width(context) - 200.w) * 0.5, child: SizedBox(width: 200.w,height: 40.h,child: MSStrokeText(text: '+${widget.award}.00', size: 40, color: '#FFD20B'.color(), weight: FontWeight.w700, skWidth: 2, skColor: '#6D450E'.color()))),
          Positioned(top: 533.5.h,left: (0.width(context) - 255) * 0.5, child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: (){
                MSAdAHelper().show(context, (hasCache){
                  if (!hasCache){
                    Navigator.pop(context, 1);
                    MSAdAHelper().resetBlock();
                  }
                }, (finished) async {
                  Navigator.pop(context, 1);
                  MSAdAHelper().resetBlock();
                  await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_domand_numberName, MSLocalProvider.instance.ms_domand_number + (widget.award * 2));
                });
              },
              child: Container(
                width: 255, height: 55,
                decoration: BoxDecoration(image: MSDImg('ms_green_bg_btn')),
                child: Stack(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 32),child: Center(child: MSGradientStrokeText(text: 'Claim ${widget.award * 2}', gradientColors: ['#FFFFFF'.color(),'#FFFFFF'.color(),'#FFFFFF'.color(),'#FFFFFF'.color(),], fontSize: 20, strokeWidth: 1, strokeColor: '#000000'.color(),width: 260, height: 40,))),
                    Positioned(left:58, top:16,child: MSImg(name: 'ms_ad_icon', width: 24.9, height: 24.5,))
                  ],
                ),
              )
          )),
        ],
      ),
    );
  }
}
// miss-A
class MSMissADialog extends StatefulWidget {
  MSMissADialog({super.key});
  @override
  State<MSMissADialog> createState() => MSMissADialogState();
}

class MSMissADialogState extends State<MSMissADialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    // 顶部图片放大缩小动画 ✅ 修复版
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _scaleAnimation = Tween(begin: 1.0, end: 1.1)
        .animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      playbgMUsic();
    });
  }

  Future<void> playbgMUsic() async {
    if (MSLocalProvider.instance.ms_sound_music){
      await MSAudioUtils().playUnAwardAudio();
      Future.delayed(Duration(milliseconds: 1000), () async {
        await MSAudioUtils().stopAllTempAudio();
      });
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        children: [
          Positioned(top: 200.h, left: (0.width(context) - 375.w) * 0.5, child: ScaleTransition(scale: _scaleAnimation,child: MSImg(name: 'ms_miss_title', width: 375.w, height: 227.h))),
          Positioned(top: 481.h,left: (0.width(context) - 260) * 0.5, child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: (){
                if (MSAdAHelper().getIntShow()){
                  MSAdAHelper().show_int(context, (hasCache){
                    if (!hasCache){
                      MSAdAHelper().resetBlock();
                      Navigator.pop(context, 0);
                    }
                  }, (finished){
                    MSAdAHelper().resetBlock();
                    Navigator.pop(context, 0);
                  });
                } else {
                  Navigator.pop(context, 0);
                }
              },
              child: Container(
                width: 255, height: 55,
                decoration: BoxDecoration(image: MSDImg('ms_green_bg_btn')),
                child: Stack(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 0),child: Center(child: MSGradientStrokeText(text: 'Try Again', gradientColors: ['#FFFFFF'.color(),'#FFFFFF'.color(),'#FFFFFF'.color(),'#FFFFFF'.color(),], fontSize: 20, strokeWidth: 1, strokeColor: '#000000'.color(),width: 260, height: 40,))),
                    // Positioned(left:58, top:16,child: MSImg(name: 'ms_ad_icon', width: 24.9, height: 24.5,))
                  ],
                ),
              )
          )),
        ],
      ),
    );
  }
}
// needs
class MSNeedsADialog extends StatefulWidget {
  MSNeedsADialog({super.key});
  @override
  State<MSNeedsADialog> createState() => MSNeedsADialogState();
}

class MSNeedsADialogState extends State<MSNeedsADialog>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    });
    ms_event_fire('wheel_pop_v', {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        children: [
          Positioned(top: 124.16.h, left: (0.width(context) - 331.5.w) * 0.5, child: MSImg(name: 'ms_wheelaward_top1', width: 332.5.w, height: 83.2.h)),
          Positioned(top: 137.h, left: (0.width(context) - 296) * 0.5, child: MSImg(name: 'ms_need_title1', width: 296, height: 28)),
          Positioned(top: 164.h, left: (0.width(context) - 347) * 0.5, child: MSImg(name: 'ms_need_title2', width: 347, height: 28)),
          Positioned(top: 210.h, left: (0.width(context) - 375.w) * 0.5, child:
          Container(
            width: 375.w,
            height: 445.w,
            decoration: BoxDecoration(
                image: MSDImg('ms_wheel_center_bg_0')
            ),
            child: InkWell(onTap: (){
              ms_event_fire('wheel_pop_c', {});
              MSMegaAds().ms_showAd(context, 'pppuz_wheellock_rv', onCacheResponse: (onCacheResponse){
                Navigator.pop(context, 0);
              }, adDidClosed: (adDidClosed) async {
                Navigator.pop(context, 0);
                await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_wheel_numberName, MSLocalProvider.instance.ms_wheel_number + 1);
              });
            },child: MSScratchWheelPage(imagePath: 'ms_wheel_center_bg_b'.image(),)),
          )),
          Positioned(left: (0.width(context) - 104) * 0.5,top: 373.78.h,child: Container(
            width: 104, height: 126.8,
            decoration: BoxDecoration(
                image: MSDImg('ms_wheel_btn')
            ),
            child: InkWell(
              onTap: (){
                ms_event_fire('wheel_pop_c', {});
                MSMegaAds().ms_showAd(context, 'pppuz_wheellock_rv', onCacheResponse: (onCacheResponse){
                  Navigator.pop(context, 0);
                }, adDidClosed: (adDidClosed) async {
                  Navigator.pop(context, 0);
                  await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_wheel_numberName, MSLocalProvider.instance.ms_wheel_number + 1);
                });
              },
              child: Stack(
                  children: [
                    Positioned(top: 50,left: 28,child: MSImg(name: 'ms_unlock_icons2', width: 46.71, height: 46.71)),
                  ],
                ),
            ),
            ),
          ),
          Positioned(top: 628.h,left: (0.width(context) - 260) * 0.5, child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: (){
                ms_event_fire('wheel_pop_c', {});
                MSMegaAds().ms_showAd(context, 'pppuz_wheellock_rv', onCacheResponse: (onCacheResponse){
                  Navigator.pop(context, 0);
                }, adDidClosed: (adDidClosed) async {
                  Navigator.pop(context, 0);
                  await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_wheel_numberName, MSLocalProvider.instance.ms_wheel_number + 1);
                });
              },
              child: Container(
                width: 255, height: 55,
                decoration: BoxDecoration(image: MSDImg('ms_green_bg_btn')),
                child: Stack(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 32),child: Center(child: MSGradientStrokeText(text: 'Get One Free Unlock Now!', gradientColors: ['#FFFFFF'.color(),'#FFFFFF'.color(),'#FFFFFF'.color(),'#FFFFFF'.color(),], fontSize: 15, strokeWidth: 1, strokeColor: '#000000'.color(),width: 260, height: 40,))),
                    Positioned(left:22, top:16,child: MSImg(name: 'ms_ad_icon', width: 24.9, height: 24.5,))
                  ],
                ),
              )
          )),
          Positioned(top: 628.h + 55,left: (0.width(context) - 260) * 0.5, child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: (){
                Navigator.pop(context, 0);
                MSNavigationService().changeTab(0);
              },
              child: SizedBox(
                width: 255, height: 55,
                child: MSStrokeText(text: 'Scratch', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#000000'.color()),
              )
          )),
        ],
      ),
    );
  }
}

// unlock
class MSUnlockDialog extends StatefulWidget {
  final int indexs;
  MSUnlockDialog({super.key, required this.indexs});
  @override
  State<MSUnlockDialog> createState() => MSUnlockDialogState();
}

class MSUnlockDialogState extends State<MSUnlockDialog>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    });
    ms_event_fire('unlock_free_v', {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        children: [
          Positioned(top: 200.h, left: (0.width(context) - 239) * 0.5, child:MSImg(name: 'ms_unlocks_titles', width: 239, height: 42)),
          Positioned(top: 230.h,left: (0.width(context) - 322.w) * 0.5, child: Container(
            width: 322.w,
            height: 302.h,
            decoration: BoxDecoration(
              image: MSDImg('ms_unlock_bg')
            ),
            child: Column(
              children: [
                SizedBox(height: 40.h,),
                Container(
                  width: 263.w, height: 116.h,
                  decoration: BoxDecoration(
                      image: MSDImg('ms_scratch_list_${widget.indexs}')
                  ),
                  child: MSImg(name: 'ms_unlocks_icons'),
                ),
                SizedBox(height: 20.5.h,),
                Container(
                  width: 255, height: 55,
                  decoration: BoxDecoration(image: MSDImg('ms_green_bg_btn')),
                  child: InkWell(
                    onTap: (){
                      ms_event_fire('unlock_free_c', {});
                      MSMegaAds().ms_showAd(context, 'pppuz_unlockpop_rv', onCacheResponse: (onCacheResponse){
                        Navigator.pop(context, 0);
                      }, adDidClosed: (adDidClosed) async {
                        if (widget.indexs == 2){
                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scratch_status_2Name, true);
                        } else if (widget.indexs == 3){
                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scratch_status_3Name, true);
                        } else if (widget.indexs == 4){
                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scratch_status_4Name, true);
                        } else if (widget.indexs == 5){
                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scratch_status_5Name, true);
                        } else if (widget.indexs == 6){
                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scratch_status_6Name, true);
                        }
                        MSSUpdateHomeListNotificationService.sendToDomandNumberNotification(0);
                        Navigator.pop(context, 0);
                      });
                      // MSAdAHelper().show(context, (hasCache){
                      //   if (!hasCache){
                      //     Navigator.pop(context, 1);
                      //     MSAdAHelper().resetBlock();
                      //   }
                      // }, (finished) async {
                      //   Navigator.pop(context, 1);
                      //   MSAdAHelper().resetBlock();
                      //   if (widget.indexs == 2){
                      //     await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scratch_status_2Name, true);
                      //   } else if (widget.indexs == 3){
                      //     await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scratch_status_3Name, true);
                      //   } else if (widget.indexs == 4){
                      //     await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scratch_status_4Name, true);
                      //   } else if (widget.indexs == 5){
                      //     await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scratch_status_5Name, true);
                      //   } else if (widget.indexs == 6){
                      //     await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scratch_status_6Name, true);
                      //   }
                      //   MSSUpdateHomeListNotificationService.sendToDomandNumberNotification(0);
                      // });
                    },
                    child: Stack(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 42),child: Center(child: MSGradientStrokeText(text: 'Free Unlock', gradientColors: ['#FFFFFF'.color(),'#FFFFFF'.color(),'#FFFFFF'.color(),'#FFFFFF'.color(),], fontSize: 20, strokeWidth: 1, strokeColor: '#000000'.color(),width: 260, height: 40,))),
                        Positioned(left:58, top:16,child: MSImg(name: 'ms_ad_icon', width: 24.9, height: 24.5,))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 255, height: 40,
                  child: InkWell(
                    onTap: () async {
                        // if (MSLocalProvider.instance.ms_domand_number < 2000){
                        //   Navigator.pop(context, 0);
                        //   MSDialogTool.toast(context, "You don't have enough gold coins! Play games to earn more gold coins!");
                        // } else {
                        //   Navigator.pop(context, 1);
                        //   await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_domand_numberName, MSLocalProvider.instance.ms_domand_number - 2000);
                        //   if (widget.indexs == 2){
                        //     await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scratch_status_2Name, true);
                        //   } else if (widget.indexs == 3){
                        //     await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scratch_status_3Name, true);
                        //   } else if (widget.indexs == 4){
                        //     await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scratch_status_4Name, true);
                        //   } else if (widget.indexs == 5){
                        //     await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scratch_status_5Name, true);
                        //   } else if (widget.indexs == 6){
                        //     await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scratch_status_6Name, true);
                        //   }
                        //   MSSUpdateHomeListNotificationService.sendToDomandNumberNotification(0);
                        // }
                      Navigator.pop(context, 0);
                    },
                    child: MSStrokeText(text: 'Scratch to Upgrade', size: 15, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#000000'.color()),
                    // child: MSStrokeText(text: 'Spend 2000 Coins', size: 15, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#000000'.color()),
                  ),
                ),
              ],
            ),
          )),
          Positioned(top: 220.h, right: 30.w, width: 50, height: 50,child: InkWell(
            onTap: (){
              Navigator.pop(context);
            }, child: Center(child: MSImg(name: 'ms_close_icon', width: 32, height: 31)))),
        ],
      ),
    );
  }
}

// all10
class MSAll10Dialog extends StatefulWidget {
  final int type;
  MSAll10Dialog({super.key, required this.type});
  @override
  State<MSAll10Dialog> createState() => MSAll10DialogState();
}

class MSAll10DialogState extends State<MSAll10Dialog>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    });
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        children: [
          Positioned(top: 200.h, left: (0.width(context) - 393) * 0.5, child:MSImg(name: 'ms_all10_titles', width: 375, height: 422)),
          Positioned(top: 540.h,left: (0.width(context) - 322.w) * 0.5, child: SizedBox(
            width: 322.w,
            height: 200.h,
            child: Column(
              children: [
                Container(
                  width: 255, height: 55,
                  decoration: BoxDecoration(image: MSDImg('ms_green_bg_btn')),
                  child: InkWell(
                    onTap: (){
                      MSMegaAds().ms_showAd(context, 'pppuz_srcmore_rv', onCacheResponse: (onCacheResponse){
                        Navigator.pop(context, 1);
                      }, adDidClosed: (adDidClosed) async {
                        Navigator.pop(context, 1);
                        if (widget.type == 0){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_0Name, 5);
                        } else if (widget.type == 1){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_1Name, 5);
                        } else if (widget.type == 2){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_2Name, 5);
                        } else if (widget.type == 3){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_3Name, 5);
                        } else if (widget.type == 4){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_4Name, 5);
                        } else if (widget.type == 5){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_5Name, 5);
                        } else if (widget.type == 6){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_6Name, 5);
                        }
                        MSSUpdateHomeListNotificationService.sendToDomandNumberNotification(0);
                      });
                      // MSAdAHelper().show(context, (hasCache){
                      //   if (!hasCache){
                      //     Navigator.pop(context, 1);
                      //     MSAdAHelper().resetBlock();
                      //   }
                      // }, (finished) async {
                      //   Navigator.pop(context, 1);
                      //   MSAdAHelper().resetBlock();
                      //   if (widget.type == 0){
                      //     await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_0Name, 0);
                      //   } else if (widget.type == 1){
                      //     await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_1Name, 0);
                      //   } else if (widget.type == 2){
                      //     await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_2Name, 0);
                      //   } else if (widget.type == 3){
                      //     await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_3Name, 0);
                      //   } else if (widget.type == 4){
                      //     await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_4Name, 0);
                      //   } else if (widget.type == 5){
                      //     await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_5Name, 0);
                      //   } else if (widget.type == 6){
                      //     await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_6Name, 0);
                      //   }
                      //   MSSUpdateHomeListNotificationService.sendToDomandNumberNotification(0);
                      // });
                    },
                    child: Stack(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 42),child: Center(child: MSGradientStrokeText(text: 'Scratch 5 More', gradientColors: ['#FFFFFF'.color(),'#FFFFFF'.color(),'#FFFFFF'.color(),'#FFFFFF'.color(),], fontSize: 20, strokeWidth: 1, strokeColor: '#000000'.color(),width: 260, height: 40,))),
                        Positioned(left:38, top:16,child: MSImg(name: 'ms_ad_icon', width: 24.9, height: 24.5,))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 255, height: 40,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(context, 0);
                    },
                    child: MSStrokeText(text: 'Other Tasks', size: 15, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#000000'.color()),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
// 设置
class MSPopSettingDialog extends StatefulWidget {
  MSPopSettingDialog({super.key});
  @override
  State<MSPopSettingDialog> createState() => MSPopSettingDialogState();
}

class MSPopSettingDialogState extends State<MSPopSettingDialog> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 339.w,
            height: 288.h,
            decoration: BoxDecoration(
                image: MSDImg('ms_set_bg')
            ),
            child: Column(
              children: [
                SizedBox(height: 12.h,),
                MSStrokeText(text: 'Settings', size: 32, color: '#FFFFFF'.color(), weight: FontWeight.w800, skWidth: 2, skColor: '#B050CC'.color()),
                SizedBox(height: 42.h,),
                Row(
                  children: [
                    SizedBox(width: 56.w,),
                    MSImg(name: 'ms_music_icon', width: 32.5, height: 32.5,),
                    SizedBox(width: 6.5.w,),
                    MSText(text: 'Background Music', size: 15, color: '#FFFFFF'.color(), weight: FontWeight.w700),
                    SizedBox(width: 20.5.w,),
                    InkWell(
                      onTap: () async {
                        if (MSLocalProvider.instance.ms_bg_music){
                          await MSAudioUtils().pauseBGM();
                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_bg_musicName, false);
                        } else {
                          await MSAudioUtils().playBGM();
                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_bg_musicName, true);
                        }
                        setState(() {});
                      },
                      child: MSImg(name: MSLocalProvider.instance.ms_bg_music ? 'ms_music_on' : 'ms_music_off', width: 55, height: 21,),
                    )
                  ],
                ),
                SizedBox(height: 23.8.h,),
                Row(
                  children: [
                    SizedBox(width: 56.w,),
                    MSImg(name: 'ms_sound_icon', width: 32.5, height: 32.5,),
                    SizedBox(width: 6.5.w,),
                    MSText(text: 'Sound Effects', size: 15, color: '#FFFFFF'.color(), weight: FontWeight.w700),
                    SizedBox(width: 47.5.w,),
                    InkWell(
                      onTap: () async {
                        if (MSLocalProvider.instance.ms_sound_music){
                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_sound_musicName, false);
                        } else {
                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_sound_musicName, true);
                        }
                        setState(() {});
                      },
                      child: MSImg(name: MSLocalProvider.instance.ms_sound_music ? 'ms_music_on' : 'ms_music_off', width: 55, height: 21,),
                    )
                  ],
                ),
                SizedBox(height: 40.8.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (builder) {
                            return MSwebkitview(
                              url: "https://luckyscratchgame.com/terms/",
                              title: 'Contact Us',
                            );
                          }),
                        );
                      },
                      child: SizedBox(
                        width: 131,
                        height: 41,
                        child: Container(
                          decoration: BoxDecoration(
                            image: MSDImg('ms_red_btn')
                          ),
                          child: MSStrokeText(text: 'Contact Us', size: 15, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#000000'.color()),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w,),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (builder) {
                            return MSwebkitview(
                              url: "https://luckyscratchgame.com/privacy/",
                              title: 'Privacy Policy',
                            );
                          }),
                        );
                      },
                      child: SizedBox(
                        width: 131,
                        height: 41,
                        child: Container(
                          decoration: BoxDecoration(
                              image: MSDImg('ms_green_btn')
                          ),
                          child: MSStrokeText(text: 'Privacy Policy', size: 15, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#000000'.color()),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(right: 30.w, top: (0.height(context) - 266.h) * 0.51, child: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: MSImg(name: 'ms_close_btn', width: 16, height: 16,),
              ),
            ),
          ))
        ],
      ),
    );
  }

}
// 任务A
class MSPopTaskADialog extends StatefulWidget {
  MSPopTaskADialog({super.key});
  @override
  State<MSPopTaskADialog> createState() => MSPopTaskADialogState();
}

class MSPopTaskADialogState extends State<MSPopTaskADialog> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 330.w,
            height: 551.h,
            decoration: BoxDecoration(
                image: MSDImg('ms_taska_bg')
            ),
            child: Column(
              children: [
                SizedBox(height: 12.h,),
                MSStrokeText(text: '7-Day Streak: Day ${MSLocalProvider.instance.ms_login_index}/7', size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w800, skWidth: 1, skColor: '#000000'.color()),
        SizedBox(
          width: 330.w,
          height: 524.h,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(), // 禁止滑动
            padding: EdgeInsets.zero, // 移除默认的 padding
            itemCount: 7, // 列表项数量
            itemBuilder: (context, index) {
              return Container(
                width: 330.w,
                height: 65, // 设置列表项高度为 200
                margin: EdgeInsets.symmetric(vertical: 8), // 设置上下间距为 12
                child: Stack(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 18.w,),
                        MSGradientStrokeText(text: 'DAY${index + 1}', gradientColors: ['#FFF4DF'.color(),'#FFF171'.color(),'#FFF171'.color(),'#FFD829'.color()], width: 65, height: 22, fontSize: 24, strokeColor: '#000000'.color(), strokeWidth: 1,),
                        SizedBox(width: 20.w,),
                        Container(
                          width: 239, height: 65,
                          decoration: BoxDecoration(
                              image: MSDImg('ms_taska_center_s')
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 22,),
                              MSImg(name: 'ms_domands_icons',width: 35, height: 35,),
                              SizedBox(width: 8,),
                              MSGradientStrokeText(text: '${(index + 1) * 1000}', gradientColors: ['#FFF4DF'.color(),'#FFF171'.color(),'#FFF171'.color(),'#FFD829'.color()], width: 65, height: 22, fontSize: 24, strokeColor: '#000000'.color(), strokeWidth: 1,),
                              SizedBox(width: 8,),
                              SizedBox(
                                width: 91,
                                height: 39,
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: MSDImg(MSLocalProvider.instance.ms_login_index >= index + 1 ? 'ms_taska_btn_s' : 'ms_taska_btn_n')
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      if (MSLocalProvider.instance.ms_login_index >= index + 1) {
                                        if (index == 0){
                                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_login_award_0Name, true);
                                        } else if (index == 1){
                                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_login_award_1Name, true);
                                        } else if (index == 2){
                                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_login_award_2Name, true);
                                        } else if (index == 3){
                                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_login_award_3Name, true);
                                        } else if (index == 4){
                                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_login_award_4Name, true);
                                        } else if (index == 5){
                                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_login_award_5Name, true);
                                        } else if (index == 6){
                                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_login_award_6Name, true);
                                        }
                                        await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_domand_numberName, MSLocalProvider.instance.ms_domand_number + (1000 * (index + 1)));
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(right: 20,child: Visibility(visible: showbgs(index),child: MSImg(name: 'ms_taska_center_n',width: 239, height: 65,)))
                  ],
                ),
              );
            },
          ),
        )
              ],
            ),
          ),
          Positioned(right: 30.w, top: (0.height(context) - 551.h) * 0.51, child: InkWell(
            onTap: (){
              if (MSAdAHelper().getIntShow()){
                MSAdAHelper().show_int(context, (hasCache){
                  if (!hasCache){
                    MSAdAHelper().resetBlock();
                    Navigator.pop(context, 0);
                  }
                }, (finished){
                  MSAdAHelper().resetBlock();
                  Navigator.pop(context, 0);
                });
              } else {
                Navigator.pop(context, 0);
              }
            },
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: MSImg(name: 'ms_close_btn', width: 16, height: 16,),
              ),
            ),
          )),
          Positioned(right: (0.width(context) - 344) * 0.5, top: 94.h, child:MSImg(name: 'ms_taska_title_bg', width: 344, height: 41,)),
          Positioned(right: (0.width(context) - 351) * 0.5, top: 96.h, child:MSImg(name: 'ms_taska_title', width: 351, height: 50,)),
        ],
      ),
    );
  }

  bool showbgs(int index){
    if (MSLocalProvider.instance.ms_login_award_0 == false && index == 0){
      return false;
    } else if (index == 1 && MSLocalProvider.instance.ms_login_award_1 == false){
      return false;
    } else if (index == 2 && MSLocalProvider.instance.ms_login_award_2 == false){
      return false;
    } else if (index == 3 && MSLocalProvider.instance.ms_login_award_3 == false){
      return false;
    } else if (index == 4 && MSLocalProvider.instance.ms_login_award_4 == false){
      return false;
    } else if (index == 5 && MSLocalProvider.instance.ms_login_award_5 == false){
      return false;
    } else if (index == 6 && MSLocalProvider.instance.ms_login_award_6 == false){
      return false;
    }
    return true;
  }

}