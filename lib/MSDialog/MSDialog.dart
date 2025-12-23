import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_toast/fl_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:megascratch/MSTool/ms_GradientText.dart';
import 'package:megascratch/MSTool/ms_text.dart';
import 'package:provider/provider.dart';
import '../MSHome/MSHome.dart';
import '../MSHome/MSScratchDetails.dart';
import '../MSHome/MSTbabar.dart';
import '../MSTool/MSScratchWheelPage.dart';
import '../MSTool/ms_AdAHelp.dart';
import '../MSTool/ms_LocalProvider.dart';
import '../MSTool/ms_WebKitView.dart';
import '../MSTool/ms_extension_help.dart';
import '../MSTool/ms_img.dart';
import '../MSTool/ms_mp3_player.dart';
import '../MSTool/ms_stroke_text.dart';
import 'package:spine_flutter/spine_flutter.dart' as spine;

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
    if (MSLocalProvider.instance.ms_bg_music) {
      await MSMP3Player().pauseBackground();
    }
    if (MSLocalProvider.instance.ms_sound_music){
      await MSMP3Player().playEffect();
      Future.delayed(Duration(milliseconds: 1000), () async {
        await MSMP3Player().pauseEffect();
        if (MSLocalProvider.instance.ms_bg_music){
          await MSMP3Player().playBackground();
        }
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
        onTap: (){
          Navigator.pop(context, 0);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (builder) {
                return MSScrachDetails(
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
                MSImg(name: 'ms_domands_icons', width: 19, height: 19,),
                SizedBox(width: 10.w,),
                MSStrokeText(text: '1000', size: 16, color: '#FBF544'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#322107'.color()),
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
              right: 15.w,
              top: 138.h,
              child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(pi / 4),
                  child: Consumer<MSLocalProvider>(
                      builder:(context, provider, child) {
                        return MSStrokeText(text: '0/10', size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0.5, skColor: '#49100F'.color());
                      })
              ),
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
    if (MSLocalProvider.instance.ms_bg_music) {
      await MSMP3Player().pauseBackground();
    }
    if (MSLocalProvider.instance.ms_sound_music){
      await MSMP3Player().playEffect4();
      Future.delayed(Duration(milliseconds: 1000), () async {
        await MSMP3Player().pauseEffect4();
        if (MSLocalProvider.instance.ms_bg_music){
          await MSMP3Player().playBackground();
        }
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
            },child: MSScratchWheelPage(imagePath: 'ms_wheel_center_bg'.image(),)),
          )),
          Positioned(left: (0.width(context) - 104) * 0.5,top: 373.78.h,child: Container(
            width: 104, height: 126.8,
            decoration: BoxDecoration(
                image: MSDImg('ms_wheel_btn')
            ),
            child: Stack(
                children: [
                  Positioned(top: 50,left: 28,child: MSImg(name: 'ms_unlock_icons2', width: 46.71, height: 46.71)),
                ],
              ),
            ),
          ),
          Positioned(top: 628.h,left: (0.width(context) - 260) * 0.5, child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: (){
                // ad->自动转
                MSAdAHelper().show(context, (hasCache){
                  if (!hasCache){
                    MSAdAHelper().resetBlock();
                    Navigator.pop(context, 0);
                  }
                }, (finished) async {
                  MSAdAHelper().resetBlock();
                  Navigator.pop(context, 0);
                  MSHomeTbaBarNotificationService.sendToDomandNumberNotification(0);
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
                MSHomeTbaBarNotificationService.sendToDomandNumberNotification(0);
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
                      MSAdAHelper().show(context, (hasCache){
                        if (!hasCache){
                          Navigator.pop(context, 1);
                          MSAdAHelper().resetBlock();
                        }
                      }, (finished) async {
                        Navigator.pop(context, 1);
                        MSAdAHelper().resetBlock();
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
                      });
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
                        if (MSLocalProvider.instance.ms_domand_number < 2000){
                          Navigator.pop(context, 0);
                          MSDialogTool.toast(context, "You don't have enough gold coins! Play games to earn more gold coins!");
                        } else {
                          Navigator.pop(context, 1);
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_domand_numberName, MSLocalProvider.instance.ms_domand_number - 2000);
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
                        }
                    },
                    child: MSStrokeText(text: 'Spend 2000 Coins', size: 15, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#000000'.color()),
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
          Positioned(top: 200.h, left: (0.width(context) - 393) * 0.5, child:MSImg(name: 'ms_all10_titles', width: 393, height: 381)),
          Positioned(top: 500.h,left: (0.width(context) - 322.w) * 0.5, child: SizedBox(
            width: 322.w,
            height: 200.h,
            child: Column(
              children: [
                Container(
                  width: 255, height: 55,
                  decoration: BoxDecoration(image: MSDImg('ms_green_bg_btn')),
                  child: InkWell(
                    onTap: (){
                      MSAdAHelper().show(context, (hasCache){
                        if (!hasCache){
                          Navigator.pop(context, 1);
                          MSAdAHelper().resetBlock();
                        }
                      }, (finished) async {
                        Navigator.pop(context, 1);
                        MSAdAHelper().resetBlock();
                        if (widget.type == 0){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_0Name, 0);
                        } else if (widget.type == 1){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_1Name, 0);
                        } else if (widget.type == 2){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_2Name, 0);
                        } else if (widget.type == 3){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_3Name, 0);
                        } else if (widget.type == 4){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_4Name, 0);
                        } else if (widget.type == 5){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_5Name, 0);
                        } else if (widget.type == 6){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_6Name, 0);
                        }
                        MSSUpdateHomeListNotificationService.sendToDomandNumberNotification(0);
                      });
                    },
                    child: Stack(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 42),child: Center(child: MSGradientStrokeText(text: 'Scratch 10 More', gradientColors: ['#FFFFFF'.color(),'#FFFFFF'.color(),'#FFFFFF'.color(),'#FFFFFF'.color(),], fontSize: 20, strokeWidth: 1, strokeColor: '#000000'.color(),width: 260, height: 40,))),
                        Positioned(left:38, top:16,child: MSImg(name: 'ms_ad_icon', width: 24.9, height: 24.5,))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 255, height: 40,
                  child: InkWell(
                    onTap: () async {
                      if (MSLocalProvider.instance.ms_domand_number < 2000){
                        Navigator.pop(context, 0);
                        MSDialogTool.toast(context, "You don't have enough gold coins! Play games to earn more gold coins!");
                      } else {
                        Navigator.pop(context, 1);
                        await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_domand_numberName, MSLocalProvider.instance.ms_domand_number - 2000);
                        if (widget.type == 0){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_0Name, 0);
                        } else if (widget.type == 1){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_1Name, 0);
                        } else if (widget.type == 2){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_2Name, 0);
                        } else if (widget.type == 3){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_3Name, 0);
                        } else if (widget.type == 4){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_4Name, 0);
                        } else if (widget.type == 5){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_5Name, 0);
                        } else if (widget.type == 6){
                          await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_6Name, 0);
                        }
                        MSSUpdateHomeListNotificationService.sendToDomandNumberNotification(0);
                      }
                    },
                    child: MSStrokeText(text: 'Spend 2000 Coins', size: 15, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#000000'.color()),
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
            height: 266.h,
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
                          await MSMP3Player().pauseBackground();
                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_bg_musicName, false);
                        } else {
                          await MSMP3Player().playBackground();
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