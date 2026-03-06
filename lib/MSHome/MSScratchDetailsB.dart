import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:megascratch/MSHome/MSCashs.dart';
import 'package:megascratch/MSHome/MSTbabar.dart';
import 'package:megascratch/MSTool/ms_GradientText.dart';
import 'package:megascratch/MSTool/ms_TBAInfoTool.dart';
import 'package:megascratch/MSTool/ms_scratch_card_image_prize.dart';
import 'package:megascratch/MSTool/ms_stroke_text.dart';
import 'package:megascratch/MSTool/ms_text.dart';
import 'package:provider/provider.dart';
import '../MSDialog/MSDialog.dart';
import '../MSTool/MSScratchWheelPage.dart';
import '../MSTool/ms_LocalProvider.dart';
import '../MSTool/ms_NumberHelper.dart';
import '../MSTool/ms_ad_manger.dart';
import '../MSTool/ms_extension_help.dart';
import '../MSTool/ms_img.dart' hide MSAnimatedImageMove;
import '../MSTool/ms_mp3_player.dart';
import 'MSHome.dart';
import 'package:spine_flutter/spine_flutter.dart' as spine;

import 'MSScratchDetails.dart';

final GlobalKey targetimageKey = GlobalKey();

class MSScrachDetails_b extends StatefulWidget {
  final int index;
  MSScrachDetails_b({super.key, required this.index});
  @override
  State<MSScrachDetails_b> createState() => _MSScrachDetails_bState();
}

class _MSScrachDetails_bState extends State<MSScrachDetails_b> with TickerProviderStateMixin{

  bool _show_animation = false;

  bool _show_animation1 = false;

  bool _show_animation2 = false;

  bool _show_animation3 = false;

  bool _show_image1 = false;

  bool _show_image2 = false;

  bool _show_image3 = false;

  bool _show_guide = false;

  MSPlayJoyResult? result1;

  MSPlayJoyResult? result2;

  MSPlayJoyResult? result3;

  MSPlayJoyResult? result4;

  MSPlayJoyResult? result5;

  MSPlayJoyResult? result6;

  MSPlayJoyResult? result7;

  bool scractchEnd = false;

  late spine.SpineWidgetController _controller0;
  // 总倒计时时间，单位是秒
  int _remainingTime = MSLocalProvider.instance.ms_dao_time_index; // 5 分钟倒计时（300秒）

  late Timer _timer;

  late Timer _timer2;

  int award_pool_number = MSNumberAHelper().getAwardPoolNumber();

  bool show_all_reveal = false;

  int scrach_un_index = 0;

  List<int> show_key_indexs = [2,5,3,7,2];

  // 创建 AnimationController
  late AnimationController _controller;

  late AnimationController _breathAnimationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ms_event_fire('card_detail_page', {'source_from' : _getindexName()});
    // 开始倒计时
    // _startCountdown();
    setNumberContent();
    // 当前帧构建完成后
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrachTimer();
      // 在这里执行需要更新UI的操作
      shownewguide();
      // 每刮五张出现防止退出页面没显示
      // if (MSLocalProvider.instance.ms_wheel_pop_showName == true) {
      //   context.tipShow(MSLuckyWheelDialog());
      // }
    });
    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    MSScratchTapNotificationService.stream.listen((value) {
      updatescrachStatus();
    });

    // 初始化控制器，设置动画的持续时间
    _controller = AnimationController(
      duration: Duration(seconds: 10), // 设置旋转动画的周期为5秒
      vsync: this,
    )..repeat(); // 使其循环播放

    // 呼吸动画的控制器，持续时间更短，呼吸加快
    _breathAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // 更快的呼吸动画
    )..repeat(reverse: true);

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
    }
    return name;
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

  void updatescrachStatus(){
    scrach_un_index = 0;
    if (mounted){
      setState(() {
        show_all_reveal = false;
      });
    }
  }

  void _startScrachTimer() {

    _timer2 = Timer.periodic(Duration(seconds: 1), (timer) {
      scrach_un_index += 1;
      if (scrach_un_index >= 3){
        if (!context.mounted) return;
        setState(() {
          show_all_reveal = true;
        });
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

  Future<void> shownewguide() async {
    await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scractch_autoName, false);
    if (!MSLocalProvider.instance.ms_new_guide2){
      setState(() {
        _show_guide = true;
      });
    }
  }

  void setNumberContent(){
    if (widget.index == 0){
      result1 = MSNumberAHelper().generatelucku_Numbers(forceWin: MSLocalProvider.instance.ms_unaward_index >= 2);
    } else if (widget.index == 1){
      result2 = MSNumberAHelper().generatelucku_diamonds(forceWin: MSLocalProvider.instance.ms_unaward_index >= 2);
    } else if (widget.index == 2){
      result3 = MSNumberAHelper().generatelucku_partpay(forceWin: MSLocalProvider.instance.ms_unaward_index >= 2);
    } else if (widget.index == 3){
      result4 = MSNumberAHelper().generatelucku_emojifun(forceWin: MSLocalProvider.instance.ms_unaward_index >= 2);
    } else if (widget.index == 4){
      result5 = MSNumberAHelper().generatelucku_goldpotdig(forceWin: MSLocalProvider.instance.ms_unaward_index >= 2);
    } else if (widget.index == 5){
      result6 = MSNumberAHelper().generatelucku_77n(forceWin: MSLocalProvider.instance.ms_unaward_index >= 2);
    } else if (widget.index == 6){
      result7 = MSNumberAHelper().generatelucku_coincraze(forceWin: MSLocalProvider.instance.ms_unaward_index >= 2);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _breathAnimationController.dispose();
    _timer2.cancel(); // 取消定时器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
          width: 0.width(context),
          height: 0.height(context),
          decoration: BoxDecoration(
              image: MSDImg('ms_scratch_bg_${widget.index}')
          ),
          child:  Stack(
            children: [
              if (widget.index == 0)
                Positioned(top:110.h,left: (0.width(context) - 375.w) * 0.5,child: MSImg(name: 'ms_scratch_center_${widget.index}', width: 375.w, height: 232.h,)),
              if (widget.index == 1)
                Positioned(top:50.h,left: (0.width(context) - 375.w) * 0.5,child: MSImg(name: 'ms_scratch_center_${widget.index}_b', width: 375.w, height: 297.h,)),
              if (widget.index == 2)
                Positioned(top:70.h,left: (0.width(context) - 352.w) * 0.5,child: MSImg(name: 'ms_scratch_center_${widget.index}_b', width: 352.w, height: 202.h,)),
              if (widget.index == 3)
                Positioned(top:100.h,left: (0.width(context) - 375.w) * 0.5,child: MSImg(name: 'ms_scratch_center_${widget.index}', width: 375.w, height: 166.h,)),
              if (widget.index == 4)
                Positioned(top:84.h,left: (0.width(context) - 375.w) * 0.5,child: MSImg(name: 'ms_scratch_center_${widget.index}_b', width: 375.w, height: 154.h,)),
              if (widget.index == 6)
                Positioned(top:100.h,left: (0.width(context) - 365.w) * 0.5,child: MSImg(name: 'ms_scratch_center_${widget.index}_b', width: 365.w, height: 218.h,)),
              // if (widget.index == 5)
              //   Positioned(top:60.h,left: (0.width(context) - 375.w) * 0.5,child: MSImg(name: 'ms_scratch_center_${widget.index}', width: 375.w, height: 313.h,)),
              Positioned(
                child: Column(
                  children: [
                    MSNavBarWidget(source_from: 'card'),
                    Spacer(),
                    MSBottomBarWidget(),
                  ],
                ),
              ),
              Positioned(top: _getContentTopH(widget.index),left: _getContentLeftX(widget.index),child: _setScratchContentWidget(widget.index)),
              Positioned(child: MSBubbleButton()),
              if (widget.index == 0)
                Positioned(top: 274.h,child: Row(
                  children: [
                    SizedBox(width: 108.w,),
                    MSStrokeText(text: 'Win Up To', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#413210'.color()),
                    SizedBox(width: 10.w,),
                    MSImg(name: 'ms_dolas_icon', width: 40, height: 50,),
                    SizedBox(width: 10.w,),
                    MSStrokeText(text: '\$${50}', size: 16, color: '#FBF544'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#322107'.color()),
                  ],
                )),
              Positioned(left: 0, top: 300.h, width: 0.width(context), height: 400, child: Visibility(visible: _show_guide,child: Lottie.asset(
                  width: 320.w,
                  height: 260.h,
                  fit: BoxFit.fill,
                  "ms_scratch_guide.zip".files(),
                  repeat: false,
                  onLoaded: (composition) async {
                    ms_event_fire('card_guide_v', {});
                    Future.delayed(Duration(milliseconds: 1200), () async {
                      ms_event_fire('card_guide_c', {});
                      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_new_guide2Name, true);
                      _show_guide = false;
                      setState(() {});
                    });
                  }
              ))),
              Positioned(left: 12.w,top: 155.h,child: Consumer<MSLocalProvider>(
                  builder: (context, provider, child) {
                    if (provider.ms_pool_show){
                      ms_event_fire('new_bonus_pool_v', {});
                    }
                    return Visibility(
                      visible: true,
                      child: InkWell(
                        onTap: () async {
                          ms_event_fire('new_bonus_pool_c', {});
                          ms_event_fire('bonus_pool_c_n', {});
                          context.tipShow(MSAwardPoolBDialog(award_num: award_pool_number, time_index: _remainingTime, index: -1, is_home: false));
                        },
                        child:SizedBox(
                          width: 85,
                          height: 85,
                          child: Stack(
                            children:  [
                              Positioned(
                                left: 8,
                                top: 8,
                                child: AnimatedBuilder(
                                  animation: _breathAnimationController,
                                  builder: (context, child) {
                                    // 通过scale动画控制大小变化来实现呼吸效果
                                    return Transform.scale(
                                      scale: 1 + 0.05 * _breathAnimationController.value,
                                      child: MSImg(
                                        name: 'ms_pool_btn_bg',
                                        width: 75,
                                        height: 76,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(left: 10,top: 50,child: MSGradientStrokeText(text: '\$100000', gradientColors: ['#FFFFFF'.color(),'#FFFFFF'.color()], width: 72, height: 21, fontSize: 16, strokeWidth: 1, strokeColor: '#000000'.color())),
                              Positioned(right: 12, top: 18,child: MSText(text: '${MSLocalProvider.instance.ms_pool_card_index}/20', size: 8, color: '#FFFFFF'.color(), weight: FontWeight.w800))
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              ), ),
              Positioned(right: 12.w,top: 124.h,child: InkWell(
                onTap: (){
                  context.tipShow(MSPopTaskBDialog(is_guide: false));
                },
                child: MSImg(name: MSLocalProvider.instance.ms_today_sign_status == true ? 'ms_sigin_btn' : 'ms_tasks_icon', width: 45, height: 45),
              )),
              Positioned(
                child: Consumer<MSLocalProvider>(
                    builder: (context, provider, child) {
                      return Visibility(visible: provider.ms_show_dolas_ani, child: Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Lottie.asset(
                            width: 0.width(context),
                            height: 720.h,
                            fit: BoxFit.fill,
                            "ms_dolas_aniamtion.zip".files(),
                            repeat: false,
                            onLoaded: (composition) async {
                              Future.delayed(Duration(milliseconds: 1800), (){
                                MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_show_dolas_aniName, false);
                              });
                            }
                        ),
                      ));
                    }
                ),
              ),
              Positioned(
                bottom: 0.h,
                left: 32.w,
                width: 80,
                height: 80,
                child: Consumer<MSLocalProvider>(
                  builder: (context, provider, child) {
                    return InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        MSNavigationService().changeTab(1);
                      },
                      child: Visibility(
                        visible: provider.ms_wheel_number > 0,
                        child: Lottie.asset(
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill,
                          "ms_shou_anmation.zip".files(),
                          repeat: true,
                        ),
                      ),
                    );
                  }
                )
              ),
              Positioned(
                bottom: -8.h,
                right: 88.w,
                width: 80,
                height: 80,
                child: Visibility(
                  visible: show_all_reveal,
                  child: InkWell(
                      onTap: () async {
                        if (!MSLocalProvider.instance.ms_scractch_auto) {
                          await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scractch_autoName, true);
                          MSScratchUpdateNotificationService.sendToDomandNumberNotification(1);
                        }
                      },
                      child: Lottie.asset(
                        width: 80,
                        height: 80,
                        fit: BoxFit.fill,
                        "ms_shou_anmation.zip".files(),
                        repeat: true,
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

  double _getContentTopH(int index){
    double h = 266.h;
    if (index == 2) {
      h = 228.h;
    } else if (index == 3) {
      h = 248.h;
    } else if (index == 4) {
      h = 238.h;
    } else if (index == 5) {
      h = 80.h;
    } else if (index == 6) {
      h = 228.h;
    }
    return h;
  }

  double _getContentLeftX(int index){
    double h = 0.w;
    if (index == 0) {
      h = (0.width(context) - 366.w) * 0.5;
    }
    return h;
  }

  Future<void> showAwardDialog(int index, double award, bool isWin, bool isKey) async {
    updateLocatice(isKey);
    if (isWin){
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_today_card_indexName, MSLocalProvider.instance.ms_today_card_index + 1);
      showWheelCardDialog(index, award);
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_card_award_indexName, MSLocalProvider.instance.ms_card_award_index + 1);
    } else {
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_card_award_indexName, 0);
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_unaward_indexName, MSLocalProvider.instance.ms_unaward_index + 1);
      if (MSLocalProvider.instance.ms_unaward_index >= 3) {
        await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_unaward_indexName, 0);
      }
      if (!mounted)return;
      int code = await context.tipShow(MSUnAwardDialog(index: widget.index));
      if (code >= 0){
        backToHome(index);
      }
    }
  }

  Future<void> updateLocatice(bool isKey) async {
    await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_Level_inedxName, MSLocalProvider.instance.ms_Level_inedx + 1);
    await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_card_numberName, MSLocalProvider.instance.ms_card_number + 1);
    await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_pool_indexName, MSLocalProvider.instance.ms_pool_index + 1);
    if (MSLocalProvider.instance.ms_txing_status == true && MSLocalProvider.instance.ms_rank_index <= 10){
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_tx_card_indexName, MSLocalProvider.instance.ms_tx_card_index + 1);
      MSScratchCashUpdateotificationService.sendToDomandNumberNotification(0);
    }
    if (isKey){
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_key_indexName, MSLocalProvider.instance.ms_key_index + 1);
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_key_all_indexName, MSLocalProvider.instance.ms_key_all_index + 1);
    }
    if (MSLocalProvider.instance.ms_key_index >= 5){
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_key_indexName, 0);
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_wheel_numberName, MSLocalProvider.instance.ms_wheel_number + 1);
    }
  }

  Future<void> showAwardTool(int index, double award) async {
    // 显示中奖dialog
    if (award < 30){
      int code = await context.tipShow(MSYouWinDialog(award_num: award.toDouble(), index: widget.index, is_wheel: false));
      if (code >= 0){
        backToHome(index);
      }
    } else if (award >= 30 && award < 50){
      int code = await context.tipShow(MSBigWinDialog(award_num: award.toDouble(), index: widget.index));
      if (code >= 0){
        backToHome(index);
      }
    } else if (award >= 50 && award < 80){
      int code = await context.tipShow(MSSuperWinDialog(award_num: award.toDouble(), index: widget.index));
      if (code >= 0){
        backToHome(index);
      }
    } else if (award >= 80){
      int code = await context.tipShow(MSJackPotDialog(award_num: award.toDouble(), index: widget.index));
      if (code >= 0){
        backToHome(index);
      }
    }
  }
  // 判断有没有概率卡需要现实的内容
  Future<void> showWheelCardDialog(int index, double award) async {
    if (MSLocalProvider.instance.ms_double_card == true) {
       context.tipShow(MSX2Dialog());
       Future.delayed(const Duration(milliseconds: 1800), () {
         showAwardTool(index, award * 2.0);
       });
    } else if (MSLocalProvider.instance.ms_fruit_card == true && widget.index == 2) {
      context.tipShow(MSFruitDialog());
      Future.delayed(const Duration(milliseconds: 1800), () {
        showAwardTool(index, award * 1.5);
      });
    } else {
      showAwardTool(index, award);
    }

  }

  // popBack
  Future<void> backToHome(int index) async {
    if (index == 0 && MSLocalProvider.instance.ms_scrach_end_number_0 >= 10) {
      int code = await context.tipShow(MSAll10Dialog(type: index));
      if (code == 0){
        if (!mounted) return;
        Navigator.pop(context, 0);
      }
    } else if (index == 1 && MSLocalProvider.instance.ms_scrach_end_number_1 >= 10) {
      int code = await context.tipShow(MSAll10Dialog(type: index));
      if (code == 0){
        if (!mounted) return;
        Navigator.pop(context, 0);
      }
    } else if (index == 2 && MSLocalProvider.instance.ms_scrach_end_number_2 >= 10) {
      int code = await context.tipShow(MSAll10Dialog(type: index));
      if (code == 0){
        if (!mounted) return;
        Navigator.pop(context, 0);
      }
    } else if (index == 3 && MSLocalProvider.instance.ms_scrach_end_number_3 >= 10) {
      int code = await context.tipShow(MSAll10Dialog(type: index));
      if (code == 0){
        if (!mounted) return;
        Navigator.pop(context, 0);
      }
    } else if (index == 4 && MSLocalProvider.instance.ms_scrach_end_number_4 >= 10) {
      int code = await context.tipShow(MSAll10Dialog(type: index));
      if (code == 0){
        if (!mounted) return;
        Navigator.pop(context, 0);
      }
    } else if (index == 5 && MSLocalProvider.instance.ms_scrach_end_number_5 >= 10) {
      int code = await context.tipShow(MSAll10Dialog(type: index));
      if (code == 0){
        if (!mounted) return;
        Navigator.pop(context, 0);
      }
    } else if (index == 6 && MSLocalProvider.instance.ms_scrach_end_number_6 >= 10) {
      int code = await context.tipShow(MSAll10Dialog(type: index));
      if (code == 0){
        if (!mounted) return;
        Navigator.pop(context, 0);
      }
    } else {
      // 每刮五张出现
      // if (MSLocalProvider.instance.ms_wheel_pop_show == true) {
      //   context.tipShow(MSLuckyWheelDialog());
      // }
      // 每日首次刮卡
      if (MSLocalProvider.instance.ms_today_card_index == 1){
        context.tipShow(MSCardPoolDialog());
      }
    }
  }
  // 获取是否显示钥匙
  Future<bool> showKeyStatus() async {
    await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_key_pro_indexName, MSLocalProvider.instance.ms_key_pro_index + 1);
    if (show_key_indexs[MSLocalProvider.instance.ms_key_list_index >= 5 ? 0 : MSLocalProvider.instance.ms_key_list_index] <= MSLocalProvider.instance.ms_key_pro_index + 1){
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_key_pro_indexName, 0);
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_key_list_indexName, MSLocalProvider.instance.ms_key_list_index + 1);
      if (MSLocalProvider.instance.ms_key_list_index > 4 || MSLocalProvider.instance.ms_key_list_index >= 5){
        await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_key_list_indexName, 0);
      }
      return true;
    } else {
      return false;
    }
  }

  Future<void> _scratchEndtap(int index) async {
    setState(() {
      _show_animation = true;
    });
    ms_event_fire('scratch_t', {});
    await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_pool_card_indexName, MSLocalProvider.instance.ms_pool_card_index + 1);
    if (MSLocalProvider.instance.ms_pool_card_index >= 20){
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_pool_card_indexName, 20);
    }
    if (result1?.diceHit == true || result2?.diceHit == true || result3?.diceHit == true || result4?.diceHit == true || result5?.diceHit == true || result6?.diceHit == true || result7?.diceHit == true){
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_wheel_indexName, MSLocalProvider.instance.ms_wheel_index + 1);
    }
    if (index == 0) {
      Future.delayed(Duration(seconds: 2), () async {
        showAwardDialog(0, result1!.totalNumber.toDouble(), result1!.isWin, result1!.diceHit);
        result1 = MSNumberAHelper().generatelucku_Numbers(forceWin: MSLocalProvider.instance.ms_unaward_index >= 2, keyHit: await showKeyStatus());
        _show_animation = false;
        // 刷新下一张
        MSScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        // UI切换下一张
        swapKey0.currentState!.runSwap(_buildScratchCard1(index));
      });
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_0Name, MSLocalProvider.instance.ms_scrach_end_number_0 + 1);
    } else if (index == 1){
      Future.delayed(Duration(seconds: 2), () async {
        showAwardDialog(1, result2!.totalNumber.toDouble(), result2!.isWin, result2!.diceHit);
        result2 = MSNumberAHelper().generatelucku_diamonds(forceWin: MSLocalProvider.instance.ms_unaward_index >= 2, keyHit: await showKeyStatus());
          _show_animation = false;
        // 刷新下一张
        MSScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        // UI切换下一张
        swapKey1.currentState!.runSwap(_buildScratchCard2(index));
      });
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_1Name, MSLocalProvider.instance.ms_scrach_end_number_1 + 1);
    } else if (index == 2){
      Future.delayed(Duration(seconds: 2), () async {
        showAwardDialog(2, result3!.totalNumber.toDouble(), result3!.isWin, result3!.diceHit);
        result3 = MSNumberAHelper().generatelucku_partpay(forceWin: MSLocalProvider.instance.ms_unaward_index >= 2, keyHit: await showKeyStatus());
          _show_animation = false;
        // 刷新下一张
        MSScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        // UI切换下一张
        swapKey2.currentState!.runSwap(_buildScratchCard3(index));
      });
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_2Name, MSLocalProvider.instance.ms_scrach_end_number_2 + 1);
    } else if (index == 3){
      Future.delayed(Duration(seconds: 2), () async {
        showAwardDialog(3, result4!.totalNumber.toDouble(), result4!.isWin, result4!.diceHit);
        result4 = MSNumberAHelper().generatelucku_emojifun(forceWin: MSLocalProvider.instance.ms_unaward_index >= 2, keyHit: await showKeyStatus());
          _show_animation = false;
        // 刷新下一张
        MSScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        // UI切换下一张
        swapKey3.currentState!.runSwap(_buildScratchCard4(index));
      });
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_3Name, MSLocalProvider.instance.ms_scrach_end_number_3 + 1);
    } else if (index == 4){
      setState(() {
        if (result5!.isWin){
          _show_animation1 = true;
        }
      });
      if (result5!.isWin){
        Future.delayed(Duration(milliseconds: 1000), () async {
          setState(() {
            _show_image1 = true;
            _show_animation1 = false;
            _show_animation2 = true;
          });
        });
      }
      if (result5!.winIndex.length >= 2){
        Future.delayed(Duration(milliseconds: 2000), () async {
          setState(() {
            _show_image2 = true;
          });
        });
      }
      if (result5!.winIndex.length >= 3){
        Future.delayed(Duration(milliseconds: 3000), () async {
          setState(() {
            _show_image2 = true;
            _show_animation1 = false;
            _show_animation2 = false;
            _show_animation3 = true;
          });
        });
      }
      if (result5!.winIndex.length >= 3){
        Future.delayed(Duration(milliseconds: 3000), () async {
          setState(() {
            _show_animation3 = false;
            _show_image3 = true;
          });
        });
      }
      Future.delayed(Duration(seconds: 3), () async {
        showAwardDialog(4, result5!.totalNumber.toDouble(), result5!.isWin, result5!.diceHit);
        result5 = MSNumberAHelper().generatelucku_goldpotdig(forceWin: MSLocalProvider.instance.ms_unaward_index >= 2, keyHit: await showKeyStatus());
        _show_animation1 = false;
        _show_animation2 = false;
        _show_animation3 = false;
        setState(() {
          _show_animation = false;
          _show_image1 = false;
          _show_image2 = false;
          _show_image3 = false;
        });
        // 刷新下一张
        MSScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        // UI切换下一张
        swapKey4.currentState!.runSwap(_buildScratchCard5(index));
      });
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_4Name, MSLocalProvider.instance.ms_scrach_end_number_4 + 1);
    } else if (index == 5){
      Future.delayed(Duration(seconds: 2), () async {
        showAwardDialog(5, result6!.totalNumber.toDouble(), result6!.isWin, result6!.diceHit);
        result6 = MSNumberAHelper().generatelucku_77n(forceWin: MSLocalProvider.instance.ms_unaward_index >= 2, keyHit: await showKeyStatus());
        setState(() {
          _show_animation = false;
        });
        // 刷新下一张
        MSScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        // UI切换下一张
        swapKey5.currentState!.runSwap(_buildScratchCard6(index));
      });
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_5Name, MSLocalProvider.instance.ms_scrach_end_number_5 + 1);
    } else if (index == 6){
      Future.delayed(Duration(seconds: 2), () async {
        showAwardDialog(6, result7!.totalNumber.toDouble(), result7!.isWin, result7!.diceHit);
        result7 = MSNumberAHelper().generatelucku_coincraze(forceWin: MSLocalProvider.instance.ms_unaward_index >= 2, keyHit: await showKeyStatus());
          _show_animation = false;
        // 刷新下一张
        MSScratchUpdateNotificationService.sendToDomandNumberNotification(0);
        // UI切换下一张
        swapKey6.currentState!.runSwap(_buildScratchCard7(index));
      });
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_6Name, MSLocalProvider.instance.ms_scrach_end_number_6 + 1);
    }
  }

  Widget _setScratchContentWidget(int index){
    if (index == 0) {
      return SizedBox(
        width: 366.w,
        height: 455.h,
        child: MSCardSwapAnimator(
          key: swapKey0,
          child: _buildScratchCard1(index),   // 封装你的刮卡UI
        ),
      );
    } else if (index == 1) {
      return SizedBox(
        width: 0.width(context),
        height: 455.h,
        child: MSCardSwapAnimator(
          key: swapKey1,
          child: _buildScratchCard2(index),   // 封装你的刮卡UI
        ),
      );
    } else if (index == 2) {
      return SizedBox(
        width: 0.width(context),
        height: 500.h,
        child: MSCardSwapAnimator(
          key: swapKey2,
          child: _buildScratchCard3(index),   // 封装你的刮卡UI
        ),
      );
    } else if (index == 3) {
      return Padding(
        padding: EdgeInsets.only(left: 0.w),
        child: SizedBox(
          width: 0.width(context),
          height: 459.h,
          child: MSCardSwapAnimator(
            key: swapKey3,
            child: _buildScratchCard4(index),   // 封装你的刮卡UI
          ),
        ),
      );
    } else if (index == 4) {
      return SizedBox(
        width: 0.width(context),
        height: 500.h,
        child: MSCardSwapAnimator(
          key: swapKey4,
          child: _buildScratchCard5(index),   // 封装你的刮卡UI
        ),
      );
    } else if (index == 5) {
      return SizedBox(
        width: 0.width(context),
        height: 595.h,
        child: MSCardSwapAnimator(
          key: swapKey5,
          child: _buildScratchCard6(index),   // 封装你的刮卡UI
        ),
      );
    } else if (index == 6) {
      return SizedBox(
        width: 0.width(context),
        height: 484.h,
        child: MSCardSwapAnimator(
          key: swapKey6,
          child: _buildScratchCard7(index),   // 封装你的刮卡UI
        ),
      );
    }
    return SizedBox(
      width: 375.w,
      height: 455.h,
      child: MSCardSwapAnimator(
        key: swapKey2,
        child: _buildScratchCard3(index),   // 封装你的刮卡UI
      ),
    );
  }

  Widget _buildScratchCard1(int index){
    return MSLocalImageScratchCard(onScratchEnd: (){
      if (scractchEnd == false){
        _scratchEndtap(index);
      }
    }, coverImagePath: 'ms_scratch_top_0_b'.image(), contentW: 366.w, contentH: 455.h, child: Container(
      width: 366.w,
      height: 455.h,
      decoration: BoxDecoration(
          image: MSDImg('ms_scratch_bottom_0_b')
      ),
      child: Column(
        children: [
          SizedBox(height: 120.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MSBouncyText(text: '${result1!.winNumbers.first}', fontSize: 40, color: result1!.displayNumbers.contains(result1!.winNumbers.first) && _show_animation ? '#FF7CD3'.color() : '#FFFFFF'.color(), borderWidth: 1, borderColor: '#000000'.color(), enableAnimation: _show_animation && result1!.displayNumbers.contains(result1!.winNumbers.first)),
              MSBouncyText(text: '${result1!.winNumbers[1]}', fontSize: 40, color: result1!.displayNumbers.contains(result1!.winNumbers[1]) && _show_animation ? '#FF7CD3'.color() : '#FFFFFF'.color(), borderWidth: 1, borderColor: '#000000'.color(), enableAnimation: _show_animation && result1!.displayNumbers.contains(result1!.winNumbers[1])),
              MSBouncyText(text: '${result1!.winNumbers.last}', fontSize: 40, color: result1!.displayNumbers.contains(result1!.winNumbers.last) && _show_animation ? '#FF7CD3'.color() : '#FFFFFF'.color(), borderWidth: 1, borderColor: '#000000'.color(), enableAnimation: _show_animation && result1!.displayNumbers.contains(result1!.winNumbers.last)),
            ],
          ),
          SizedBox(height: 52.h,),
          SizedBox(
            width: 323.w,
            height: 186.w,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // 一行5个
                mainAxisSpacing: 0, // 垂直间距
                crossAxisSpacing: 4, // 水平间距
                childAspectRatio: 64.6.w / 61.h, // 宽高比
              ),
              itemCount: 15,
              padding: EdgeInsets.only(top: 0.h, left: 0.w), // 移除默认的padding// 最多显示10个
              itemBuilder: (context, index) {
                return SizedBox(
                    width: 64.6.w,
                    height: 61.h,
                    child: Stack(
                        children: [
                          if (result1!.displayNumbers[index] == -2)
                            MSAnimatedImageMove(imageUrl: 'ms_wheel_key_s', isAnimationEnabled: _show_animation, ws: 45, hs: 55, targetKey: targetimageKey),
                          if (result1!.displayNumbers[index] != -2)
                            Positioned(child: Center(child: MSBouncyText(text: '${result1!.displayNumbers[index]}', fontSize: 36, color:result1!.winIndex.contains(index) ? '#FF7CD3'.color() :'#FFFFFF'.color(), enableAnimation: _show_animation && result1!.winIndex.contains(index)))),
                          Positioned(top: 40.h,left: 14.w,child: Row(
                            children: [
                              MSBouncyText(text: '\$${result1!.winMatchNumbers[index].toStringAsFixed(2)}', fontSize: 15, color: '#FFFFFF'.color(), borderWidth: 1, borderColor: '#000000'.color(),enableAnimation: false)
                            ],
                          )),
                        ]
                    )
                );
              },
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildScratchCard2(int index){
    return MSLocalImageScratchCard(onScratchEnd: (){
      _scratchEndtap(index);
    }, coverImagePath: 'ms_scratch_top_1_b'.image(), contentW: 375.w, contentH: 455.h, child: Container(
      width: 375.w,
      height: 455.h,
      decoration: BoxDecoration(
          image: MSDImg('ms_scratch_bottom_1_b')
      ),
      child: Column(
        children: [
          SizedBox(height: 72.h,),
          SizedBox(
            width: 291.83.w,
            height: 75.h,
            child: Stack(
              children: [
                Row(
                  children: [
                    SizedBox( width: 41.69.w, height:47,child: MSBouncyText(text: '3', fontSize: 36, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 3 && _show_animation)),
                    SizedBox( width: 41.69.w, height:47,child: MSBouncyText(text: '4', fontSize: 36, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 4 && _show_animation)),
                    SizedBox( width: 41.69.w, height:47,child: MSBouncyText(text: '5', fontSize: 36, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 5 && _show_animation)),
                    SizedBox( width: 41.69.w, height:47,child: MSBouncyText(text: '6', fontSize: 36, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 6 && _show_animation)),
                    SizedBox( width: 41.69.w, height:47,child: MSBouncyText(text: '7', fontSize: 36, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 7 && _show_animation)),
                    SizedBox( width: 41.69.w, height:47,child: MSBouncyText(text: '8', fontSize: 36, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 8 && _show_animation)),
                    SizedBox( width: 41.69.w, height:47,child: MSBouncyText(text: '9', fontSize: 36, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 9 && _show_animation)),
                  ],
                ),
                Positioned(top: 32.h,child: Row(
                  children: [
                    SizedBox( width: 41.69.w, height:26,child: MSBouncyText(text: 'x1', fontSize: 20, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 3 && _show_animation)),
                    SizedBox( width: 41.69.w, height:26,child: MSBouncyText(text: 'x2', fontSize: 20, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 4 && _show_animation)),
                    SizedBox( width: 41.69.w, height:26,child: MSBouncyText(text: 'x3', fontSize: 20, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 5 && _show_animation)),
                    SizedBox( width: 41.69.w, height:26,child: MSBouncyText(text: 'x4', fontSize: 20, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 6 && _show_animation)),
                    SizedBox( width: 41.69.w, height:26,child: MSBouncyText(text: 'x5', fontSize: 20, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 7 && _show_animation)),
                    SizedBox( width: 41.69.w, height:26,child: MSBouncyText(text: 'x6', fontSize: 20, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 8 && _show_animation)),
                    SizedBox( width: 41.69.w, height:26,child: MSBouncyText(text: 'x7', fontSize: 20, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 9 && _show_animation)),
                  ],
                )),
                Positioned(top: 50.h,child: Row(
                  children: [
                    SizedBox( width: 41.69.w, height:21,child: MSBouncyText(text: 'BET', fontSize: 16, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 3 && _show_animation)),
                    SizedBox( width: 41.69.w, height:21,child: MSBouncyText(text: 'BET', fontSize: 16, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 4 && _show_animation)),
                    SizedBox( width: 41.69.w, height:21,child: MSBouncyText(text: 'BET', fontSize: 16, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 5 && _show_animation)),
                    SizedBox( width: 41.69.w, height:21,child: MSBouncyText(text: 'BET', fontSize: 16, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 6 && _show_animation)),
                    SizedBox( width: 41.69.w, height:21,child: MSBouncyText(text: 'BET', fontSize: 16, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 7 && _show_animation)),
                    SizedBox( width: 41.69.w, height:21,child: MSBouncyText(text: 'BET', fontSize: 16, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 8 && _show_animation)),
                    SizedBox( width: 41.69.w, height:21,child: MSBouncyText(text: 'BET', fontSize: 16, color: '#FFFAF3'.color(), borderWidth: 1, borderColor: '#915523'.color(), enableAnimation: result2!.winIndex.length == 9 && _show_animation)),
                  ],
                )),
              ],
            ),
          ),
          SizedBox(height: 20.h,),
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 一行5个
                mainAxisSpacing: 0, // 垂直间距
                crossAxisSpacing: 0, // 水平间距
                childAspectRatio: 78.w / 74.h, // 宽高比
              ),
              itemCount: 12,
              padding: EdgeInsets.only(top: 0.h, left: 16.w, right: 16.w), // 移除默认的padding// 最多显示10个
              itemBuilder: (context, index) {
                return SizedBox(
                    width: 78.w,
                    height: 74.h,
                    child: Stack(
                        children: [
                          if (result2!.displayNumbers[index] == -2)
                            Positioned(top: 5.h,left: 26.w,child: MSAnimatedImageMove(imageUrl: 'ms_wheel_key_s', isAnimationEnabled: _show_animation, ws: 45, hs: 55, targetKey: targetimageKey)),
                          if (result2!.displayNumbers[index] == 1)
                            Positioned(top: 5.h,left: 12.w,child: MSBouncyImage(imagePath: 'ms_scratch_conten_1_${result2!.displayNumbers[index]}'.image(), width: 56.52, height: 56.52, enableAnimation: false)),
                          if (result2!.displayNumbers[index] == 2)
                            Positioned(top: 5.h,left: 12.w,child: MSBouncyImage(imagePath: 'ms_scratch_conten_1_${result2!.displayNumbers[index]}'.image(), width: 59, height: 59, enableAnimation: false)),
                          if (result2!.displayNumbers[index] == 0)
                            Positioned(top: 12.h,left: 12.w,child: MSBouncyImage(imagePath: 'ms_scratch_conten_1_${result2!.displayNumbers[index]}'.image(), width: 64.14, height: 45.34, enableAnimation: _show_animation)),
                          Positioned(top: 48.h,left: 22.w,child: Row(
                            children: [
                              MSBouncyText(text: '\$${result2!.winMatchNumbers[index].toStringAsFixed(2)}', fontSize: 20, color: '#F4B22A'.color(), borderWidth: 1, borderColor: '#322107'.color(),enableAnimation: false)
                            ],
                          )),
                        ]
                    )
                );
              },
            ),
        ],
      ),
    ));
  }

  Widget _buildScratchCard3(int index){
    return MSLocalImageScratchCard(onScratchEnd: (){
      _scratchEndtap(index);
    }, coverImagePath: 'ms_scratch_top_2_b'.image(), contentW: 375.w, contentH: 500.h, child: Container(
      width: 375.w,
      height: 500.h,
      decoration: BoxDecoration(
          image: MSDImg('ms_scratch_bottom_2_b')
      ),
      child: Column(
        children: [
          SizedBox(height: 80.h,),
          SizedBox(
            width: 360.w,
            height: 390.w,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 一行5个
                mainAxisSpacing: 0, // 垂直间距
                crossAxisSpacing: 0, // 水平间距
                childAspectRatio: 120.w / 130.w, // 宽高比
              ),
              itemCount: 9,
              padding: EdgeInsets.only(top: 0.h, left: 0.w), // 移除默认的padding// 最多显示10个
              itemBuilder: (context, index) {
                return SizedBox(
                    width: 120.w,
                    height: 130.w,
                    child: Stack(
                        children: [
                          if (result3!.displayNumbers[index] == -2)
                            Positioned(left: 28.w,top: 20.h,child: MSAnimatedImageMove(imageUrl: 'ms_wheel_key_s', isAnimationEnabled: _show_animation, ws: 45, hs: 55, targetKey: targetimageKey)),
                          if (result3!.displayNumbers[index] != -2)
                            Positioned(left: 28.w,top: 20.h,child:MSBouncyImage(imagePath: 'ms_scratch_conten_2_${result3!.displayNumbers[index]}'.image(), width: 65, height:result3!.displayNumbers[index] == 0 ? 60 : 70, enableAnimation: result3!.winIndex.contains(index),)),
                          Positioned(top: 82.h,left: 36.w,child: Row(
                            children: [
                              MSBouncyText(text: '\$${result3!.winMatchNumbers[index].toStringAsFixed(2)}', fontSize: 24, color: '#4E4848'.color(), borderWidth: 1, borderColor: '#4E4848'.color(),enableAnimation: false)
                            ],
                          )),
                        ]
                    )
                );
              },
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildScratchCard4(int index){
    return MSLocalImageScratchCard(onScratchEnd: (){
      _scratchEndtap(index);
    }, coverImagePath: 'ms_scratch_top_3_b'.image(), contentW: 375.w, contentH: 459.h, child: Container(
        width: 0.width(context),
        height: 459.h,
        decoration: BoxDecoration(
            image: MSDImg('ms_scratch_bottom_3_b')
        ),
        child: Row(
          children: [
            SizedBox(width: 20.w,),
            Column(
              children: [
                SizedBox(height: 116.h,),
                SizedBox(
                  width: 100.w,
                  height: 90.w,
                  child: Row(
                    children: [
                      SizedBox(width: 20.w,),
                      MSImg(name: 'ms_dolas_icon_s', width: 22.41, height: 22.41,),
                      SizedBox(width: 3.w,),
                      MSBouncyText(text: '${result4!.winMatchNumbers[0].toStringAsFixed(2)}', fontSize: 15, color: '#FBF544'.color(), borderWidth: 1, borderColor: '#322107'.color(),enableAnimation: false)
                    ],
                  ),
                ),
                SizedBox(
                  width: 100.w,
                  height: 90.w,
                  child: Row(
                    children: [
                      SizedBox(width: 20.w,),
                      MSImg(name: 'ms_dolas_icon_s', width: 22.41, height: 22.41,),
                      SizedBox(width: 3.w,),
                      MSBouncyText(text: '${result4!.winMatchNumbers[1].toStringAsFixed(2)}', fontSize: 15, color: '#FBF544'.color(), borderWidth: 1, borderColor: '#322107'.color(),enableAnimation: false)
                    ],
                  ),
                ),
                SizedBox(
                  width: 100.w,
                  height: 90.w,
                  child: Row(
                    children: [
                      SizedBox(width: 20.w,),
                      MSImg(name: 'ms_dolas_icon_s', width: 22.41, height: 22.41,),
                      SizedBox(width: 3.w,),
                      MSBouncyText(text: '${result4!.winMatchNumbers[2].toStringAsFixed(2)}', fontSize: 15, color: '#FBF544'.color(), borderWidth: 1, borderColor: '#322107'.color(),enableAnimation: false)
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 0.w,),
            Column(
              children: [
                SizedBox(height: 118.h,),
                SizedBox(
                  width: 210.w,
                  height: 270.w,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 一行5个
                      mainAxisSpacing: 0, // 垂直间距
                      crossAxisSpacing: 0, // 水平间距
                      childAspectRatio: 70.w / 90.w, // 宽高比
                    ),
                    itemCount: 9,
                    padding: EdgeInsets.only(top: 0.h, left: 0.w), // 移除默认的padding// 最多显示10个
                    itemBuilder: (context, index) {
                      return SizedBox(
                          width: 70.w,
                          height: 90.w,
                          child: Stack(
                              children: [
                                if (result4!.displayNumbers[index] == -2)
                                  Positioned(top: 14.h,left: 24.w,child: MSAnimatedImageMove(imageUrl: 'ms_wheel_key_s', isAnimationEnabled: _show_animation, ws: 45, hs: 55, targetKey: targetimageKey)),
                                if (result4!.displayNumbers[index] != -2)
                                  Positioned(child: Center(child: MSBouncyImage(imagePath: 'ms_scratch_conten_3_${result4!.displayNumbers[index]}'.image(), width: 52.34, height: 52.34, enableAnimation: result4!.winIndex.contains(index),))),
                              ]
                          )
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        )
    ));
  }

  Widget _buildScratchCard5(int index){
    return MSLocalImageScratchCard(onScratchEnd: (){
      _scratchEndtap(index);
    }, coverImagePath: 'ms_scratch_top_4_b'.image(), contentW: 0.width(context), contentH: 500.h, child: Container(
      width: 0.width(context),
      height: 500.h,
      decoration: BoxDecoration(
          image: MSDImg('ms_scratch_bottom_4_b')
      ),
      child: Column(
        children: [
          SizedBox(height: 74.h,),
          Row(
            children: [
              SizedBox(width: 68.w,),
              MSBouncyImage(imagePath: _show_image1 ? 'ms_scratch_conten_4_0'.image() : 'ms_scratch_conten_4_1'.image(), width: 65.74, height: 98.78, enableAnimation: false, key: targetimageKey1),
              SizedBox(width: 32.w,),
              MSBouncyImage(imagePath: _show_image2 ? 'ms_scratch_conten_4_0'.image() : 'ms_scratch_conten_4_1'.image(), width: 65.74, height: 98.78, enableAnimation: false, key: targetimageKey2),
              Spacer(),
              MSBouncyImage(imagePath: _show_image3 ? 'ms_scratch_conten_4_0'.image() : 'ms_scratch_conten_4_1'.image(), width: 65.74, height: 98.78, enableAnimation: false, key: targetimageKey3),
              SizedBox(width: 68.w,),
            ],
          ),
          SizedBox(height: 100.h,),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // 一行5个
              mainAxisSpacing: 0, // 垂直间距
              crossAxisSpacing: 0, // 水平间距
              childAspectRatio: 55.2.w / 70.5.w, // 宽高比
            ),
            itemCount: 10,
            padding: EdgeInsets.only(left: 32.w, right: 32.w), // 移除默认的padding// 最多显示10个
            itemBuilder: (context, index) {
              return Stack(
                  children: [
                    if (result5!.displayNumbers[index] == -2)
                      Positioned(top: 2, left: 14.w,child: MSAnimatedImageMove(imageUrl: 'ms_wheel_key_s', isAnimationEnabled: _show_animation, ws: 45, hs: 55, targetKey: targetimageKey)),
                    if (result5!.displayNumbers[index] == 2)
                      Positioned(left: 4.w, top: 0.h,child:MSBouncyImage(imagePath: 'ms_scratch_conten_4_g'.image(), width: 55.2.w, height: 70.5.w, enableAnimation: result5!.winIndex.contains(index) && _show_animation)),
                    if (result5!.displayNumbers[index] == 3)
                      Positioned(left: 12.w, top: 16.h,child:MSBouncyImage(imagePath: 'ms_scratch_conten_4_${result5!.displayNumbers[index]}'.image(), width: 44.24, height: 36.44, enableAnimation: result5!.winIndex.contains(index) && _show_animation)),
                    if (result5!.displayNumbers[index] == 2)
                      Positioned(left: 16.w, top: 8.h,child:MSBouncyImage(imagePath: 'ms_scratch_conten_4_${result5!.displayNumbers[index]}'.image(), width: 39, height: 58, enableAnimation: false)),
                    if (result5!.displayNumbers[index] == 2)
                      Positioned(left: 16.w, top: 8.h,child:MSAnimatedImageMove(imageUrl: 'ms_scratch_conten_4_${result5!.displayNumbers[index]}', isAnimationEnabled: getimageAnmationStatus(index), ws: 39, hs: 58, targetKey: getglobalkeys())),
                    Positioned(
                      top: result5!.displayNumbers[index] == 2 ? 58.h :48.h,
                      child: Row(
                        children: [
                          SizedBox(width: 8.w,),
                          MSImg(name: 'ms_dolas_icon_s', width: 15.41, height: 15.41,),
                          SizedBox(width: 3.w,),
                          MSBouncyText(text: '${result5!.winMatchNumbers[index].toStringAsFixed(2)}', fontSize: 15, color: '#FFFFFF'.color(), borderWidth: 1, borderColor: '#000000'.color(),enableAnimation: false)
                        ],
                      ),
                    ),
                  ]
              );
            },
          ),
        ],
      ),
    ));
  }

  // 按顺序执行动画
  bool getimageAnmationStatus(int index){
    if (_show_animation1 && result5!.winIndex.first == index){
      return true;
    } else if (_show_animation2 && result5!.winIndex.length >= 2){
      if (result5!.winIndex[1] == index){
        return true;
      }
      return false;
    } else if (_show_animation3 && result5!.winIndex.length >= 3){
      if (result5!.winIndex[2] == index){
        return true;
      }
      return false;
    }
    return false;
  }

  GlobalKey getglobalkeys(){
    if (_show_animation1){
      return targetimageKey1;
    } else if (_show_animation2){
      return targetimageKey2;
    } else if (_show_animation3){
      return targetimageKey3;
    }
    return targetimageKey1;
  }

  Widget _buildScratchCard6(int index){
    return MSLocalImageScratchCard(onScratchEnd: (){
      _scratchEndtap(index);
    }, coverImagePath: 'ms_scratch_top_5_b'.image(), contentW: 0.width(context), contentH: 595.h, autoStartY: 270.h,child: Container(
      width: 0.width(context),
      height: 595.h,
      decoration: BoxDecoration(
          image: MSDImg('ms_scratch_bottom_5_b')
      ),
      child: Column(
        children: [
          SizedBox(height: 268.h,),
          Padding(
            padding: EdgeInsets.only(left: 0.w),
            child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // 一行5个
                  mainAxisSpacing: 0, // 垂直间距
                  crossAxisSpacing: 0, // 水平间距
                  childAspectRatio: 65.w / 62.6.w, // 宽高比
                ),
                itemCount: 15,
                padding: EdgeInsets.only(top: 8.h, left: 40.w, right: 8.w), // 移除默认的padding// 最多显示10个
                itemBuilder: (context, index) {
                  return Stack(
                          children: [
                            if (result6!.displayNumbers[index] == -2)
                              Positioned(left: 8,top: 4,child: MSAnimatedImageMove(imageUrl: 'ms_wheel_key_s', isAnimationEnabled: _show_animation, ws: 45, hs: 55, targetKey: targetimageKey)),
                            if (result6!.displayNumbers[index] != 0 && result6!.displayNumbers[index] != 1 && result6!.displayNumbers[index] != -2)
                              Positioned(left: 1.w,child: MSBouncyText(text: '${result6!.displayNumbers[index]}', fontSize: 36, color: '#5A5A5A'.color(), borderWidth: 1, borderColor: '#5A5A5A'.color(), enableAnimation: false,)),
                            if (result6!.displayNumbers[index] == 0 && result6!.displayNumbers[index] != -2)
                              Positioned(left: 8.w,top: 10.h,child:MSBouncyImage(imagePath: 'ms_scratch_conten_5_${result6!.displayNumbers[index]}'.image(), width: 28.64, height: 30.54, enableAnimation: _show_animation)),
                            if (result6!.displayNumbers[index] == 1 && result6!.displayNumbers[index] != -2)
                              Positioned(top: 10.h,child:MSBouncyImage(imagePath: 'ms_scratch_conten_5_${result6!.displayNumbers[index]}'.image(), width: 46.04, height: 29.81, enableAnimation: _show_animation)),
                            if (result6!.displayNumbers[index] == 2 && result6!.displayNumbers[index] != -2)
                              Positioned(top: 7.h,child:MSBouncyImage(imagePath: 'ms_scratch_conten_5_${result6!.displayNumbers[index]}'.image(), width: 66.34, height: 34.84, enableAnimation: _show_animation)),
                            if (result6!.displayNumbers[index] != -2)
                              Positioned(bottom: 2.h,child:
                            SizedBox(
                              width: 65.w,
                              height: 20.6.w,
                              child: Row(
                                children: [
                                  MSBouncyText(text: '\$${result6!.winMatchNumbers[index].toStringAsFixed(2)}', fontSize: 15, color: (result6!.displayNumbers[index] == 0 || result6!.displayNumbers[index] == 1 || result6!.displayNumbers[index] == 2) ? '#5A5A5A'.color() : '#5A5A5A'.color(), borderWidth: 1, borderColor: '#000000'.color(),enableAnimation: false)
                                ],
                              ),
                            ))
                          ]
                  );
                },
              ),
          ),
        ],
      ),
    ));
  }

  Widget _buildScratchCard7(int index){
    return MSLocalImageScratchCard(onScratchEnd: (){
      _scratchEndtap(index);
    }, coverImagePath: 'ms_scratch_top_6_b'.image(), contentW: 0.width(context), contentH: 484.h, child: Container(
      width: 0.width(context),
      height: 484.h,
      decoration: BoxDecoration(
          image: MSDImg('ms_scratch_bottom_6_b')
      ),
      child: Column(
        children: [
          SizedBox(height: 106.h,),
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 一行5个
                mainAxisSpacing: 0, // 垂直间距
                crossAxisSpacing: 0, // 水平间距
                childAspectRatio: 80.25.w / 80.3.w, // 宽高比
              ),
              itemCount: 12,
              padding: EdgeInsets.only(top: 28.h, left: 16.w, right: 16.w), // 移除默认的padding// 最多显示10个
              itemBuilder: (context, index) {
                return SizedBox(
                    width: 80.25.w,
                    height: 80.3.w,
                    child: Stack(
                        children: [
                          if (result7!.displayNumbers[index] == -2)
                            Positioned(left: 14.w, top: 8.h,child: MSAnimatedImageMove(imageUrl: 'ms_wheel_key_s', isAnimationEnabled: _show_animation, ws: 45, hs: 55, targetKey: targetimageKey)),
                          if (result7!.displayNumbers[index] == 0 && result7!.displayNumbers[index] != -2)
                            Positioned(left: 14.w,top: 10.h,child:MSBouncyImage(imagePath: 'ms_scratch_conten_6_${result7!.displayNumbers[index]}'.image(), width: 56, height: 47, enableAnimation: false)),
                          if (result7!.displayNumbers[index] != 0 && result7!.displayNumbers[index] != -2)
                            Positioned(left: 16.w, top: 8.h, child: MSImg(name: 'ms_dolas_award_0', width: 46, height: 49,)),
                          if (result7!.displayNumbers[index] != 0 && result7!.displayNumbers[index] != -2)
                            Positioned(left: 0.w, top: 38.h,child:
                            MSBouncyText(text: '\$${result7!.winMatchNumbers[index].toStringAsFixed(2)}', fontSize: 22, color:'#FBF544'.color(), borderWidth: 1, borderColor: '#322107'.color(),enableAnimation: _show_animation)
                            )
                        ]
                    )
                );
              },
            ),
        ],
      ),
    ));
  }

}

// 气泡
class MSBubbleButton extends StatefulWidget {
  const MSBubbleButton({super.key});

  @override
  _MSBubbleButtonState createState() => _MSBubbleButtonState();
}

class _MSBubbleButtonState extends State<MSBubbleButton> with SingleTickerProviderStateMixin {

  late Ticker _ticker;

  double _top = 66; // 初始位置从屏幕左上角开始
  double _left = 80; // 初始位置从屏幕左上角开始
  double _dx = 50; // 每秒移动多少 px
  double _dy = 80;

  double _iconSize = 88;

  bool _showPop = true;

  double _pptReward = Random().nextInt(41) + 10;
  late double maxW, maxH;
  late double screenWidth;
  late double screenHeight;

  late int _lastTime; // 用来计算 deltaTime

  @override
  void initState() {
    super.initState();
    _lastTime = DateTime.now().millisecondsSinceEpoch;

    _ticker = createTicker(_onTick)..start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 使用 MediaQuery 获取屏幕的宽度和高度
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final dt = (now - _lastTime) / 1000.0; // dt 秒
    _lastTime = now;

    maxW = screenWidth - _iconSize;
    maxH = screenHeight - _iconSize - 100;

    // 按时间移动，而不是按帧
    _left += _dx * dt;
    _top += _dy * dt;

    if (_left <= 0) {
      _left = 0;
      _dx = -_dx;
    } else if (_left >= maxW) {
      _left = maxW;
      _dx = -_dx;
    }

    if (_top <= 0) {
      _top = 0;
      _dy = -_dy;
    } else if (_top >= maxH) {
      _top = maxH;
      _dy = -_dy;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_showPop) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(left: _left, top: _top),
      child: GestureDetector(
        onTap: _openPopPT,
        child: SizedBox(
          width: _iconSize,
          height: _iconSize + 5,
          child: Container(
            width: _iconSize,
            height: _iconSize + 5,
            decoration: BoxDecoration(image: MSDImg('ms_bubble_icon')),
            child: Column(
              children: [
                Spacer(),
                MSStrokeText(
                  text: '\$${_pptReward.toStringAsFixed(2)}',
                  size: 24,
                  color: '#FBF544'.color(),
                  weight: FontWeight.w700,
                  skWidth: 1,
                  skColor: '#804D00'.color(),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPopPT() {
    ms_event_fire('bubble_c', {});
    MSMegaAds().ms_showAd(context, 'pppuz_bubble_int', onCacheResponse: (onCacheResponse) {
      _hidePoPT();
    }, adDidClosed: (adDidClosed) async {
      await MSLocalProvider.instance.updatedouble(
          MSLocalProvider.instance.ms_dolas_numberName, MSLocalProvider.instance.ms_dolas_number + _pptReward
      );
      playbgMUsic();
      _hidePoPT();
    });
  }

  Future<void> playbgMUsic() async {
    if (MSLocalProvider.instance.ms_sound_music) {
      await MSAudioUtils().playAward2Audio();
      Future.delayed(Duration(milliseconds: 1000), () async {
        await MSAudioUtils().stopAllTempAudio();
      });
    }
  }

  void _hidePoPT() {
    _pptReward = Random().nextInt(41) + 10;
    if (mounted) {
      setState(() {
        _showPop = false;
      });
    }
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showPop = true;
        });
      }
    });
  }
}
class MSAnimatedImageMove extends StatefulWidget {
  final String imageUrl;
  final bool isAnimationEnabled;
  final double ws;
  final double hs;
  final GlobalKey targetKey; // 目标组件的 key

  const MSAnimatedImageMove({
    Key? key,
    required this.imageUrl,
    required this.isAnimationEnabled,
    required this.ws,
    required this.hs,
    required this.targetKey,
  }) : super(key: key);

  @override
  _MSAnimatedImageMoveState createState() => _MSAnimatedImageMoveState();
}

class _MSAnimatedImageMoveState extends State<MSAnimatedImageMove>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _offsetAnimation;
  bool _visible = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 缩放动画
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);

    _offsetAnimation = AlwaysStoppedAnimation(Offset.zero);

    // 动画结束后让组件消失
    _controller.addStatusListener((status) {
      if (!mounted) return;  // ✅ widget 已经销毁了就不继续
      if (status == AnimationStatus.completed) {
        setState(() {
          _visible = false;
        });
      }
    });

    if (widget.isAnimationEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAnimation();
      });
    }
  }

  void _startAnimation() {
    final RenderBox? targetBox =
    widget.targetKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? parentBox =
    context.findRenderObject() as RenderBox?;

    print('targetBox: $targetBox');
    print('parentBox: $parentBox');
    if (targetBox != null && parentBox != null) {
      final targetPosition = targetBox.localToGlobal(Offset.zero);
      final parentPosition = parentBox.localToGlobal(Offset.zero);
      final relativeOffset = targetPosition - parentPosition;

      _offsetAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: relativeOffset,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
        ),
      );
      _controller.forward();
      'startAnimation'.log();
      print('Controller status: ${_controller.status}');
    }
  }

  @override
  void didUpdateWidget(covariant MSAnimatedImageMove oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimationEnabled && !_controller.isAnimating) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _visible = true);
        _controller.reset();
        _startAnimation();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _offsetAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: SizedBox(
              width: widget.ws,
              height: widget.hs,
              child: MSImg(name: widget.imageUrl),
            ),
          ),
        );
      },
    );
  }
}


