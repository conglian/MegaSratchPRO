import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:megascratch/MSTool/ms_TBAInfoTool.dart';
import 'package:megascratch/MSTool/ms_stroke_text.dart';
import 'package:provider/provider.dart';
import '../MSDialog/MSDialog.dart';
import '../MSTool/MSScratchWheelPage.dart';
import '../MSTool/ms_LocalProvider.dart';
import '../MSTool/ms_extension_help.dart';
import '../MSTool/ms_img.dart';
import '../MSTool/ms_wheel_spin.dart';
import 'MSHome.dart';


class MSLuckWheel extends StatefulWidget {
  MSLuckWheel({super.key});
  @override
  State<MSLuckWheel> createState() => _MSLuckWheelState();
}

class _MSLuckWheelState extends State<MSLuckWheel> {

  BuildContext get ctx => context;

  Timer? _timer;

  bool is_tap = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 当前帧构建完成后
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在这里执行需要更新UI的操作
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
                image: MSDImg('ms_wheel_bg')
            ),
            child:  Stack(
              children: [
                Column(
                  children: [
                    MSNavBarWidget(source_from: 'home'),
                    SizedBox(height: 113.37.h,),
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
                    Container(
                      width: 327.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        image: MSDImg('ms_unlocks_bgs')
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 32.w,),
                          MSImg(name: 'ms_unlock_b_icon', width: 24, height: 29,),
                          SizedBox(width: 12.w,),
                          Container(
                            width: 198,
                            height: 17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17),
                              border: Border.all(
                                color: Colors.black, // 设置边框颜色为黑色
                                width: 1.0,          // 设置边框宽度为 1
                              ),
                            ),
                            child:
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      '#59FF69'.color(),
                                      '#118C25'.color(),
                                    ],
                                  ).createShader(bounds);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 1),
                                  child: Consumer<MSLocalProvider>(
                                      builder: (context, provider, child) {
                                        return SizedBox(
                                          width: 198,
                                          height: 17,
                                          child: LinearProgressIndicator(
                                            value: provider.ms_wheel_index / 5.0,
                                            minHeight: 17,
                                            backgroundColor: Colors.transparent,
                                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        );
                                      }
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w,),
                          Consumer<MSLocalProvider>(
                              builder: (context, provider, child) {
                                return MSStrokeText(text: '${provider.ms_wheel_index}/5', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#000000'.color());
                              }
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(left: (0.width(context) - 368.2.w) * 0.5,top: 154.78.h,child: MSImg(name: 'ms_wheel_top_0', width: 368.2.w, height: 64.86.h,)),
                Positioned(left: (0.width(context) - 283.81.w) * 0.5,top: 149.78.h,child: MSImg(name: 'ms_wheel_top_1', width: 283.81.w, height: 55.17.h,)),
                Positioned(left: (0.width(context) - 104) * 0.5,top: 373.78.h,child: Container(
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
            )
      ),
    );
  }

  Future<void> tapwheelSender() async {

    if (is_tap){
      return;
    }
    is_tap = true;

    if (MSLocalProvider.instance.ms_wheel_number <= 0) {
      is_tap = false;
      ms_event_fire('wheel_unlock_c', {});
      context.tipShow(MSNeedsADialog());

    } else {
      ms_event_fire('wheel_go_c', {});
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_wheel_numberName, MSLocalProvider.instance.ms_wheel_number - 1);

      // 创建一个 Random 实例
      int random = WheelSpin().spinWheel();
      // 生成一个随机索引
      int randomIndex = 1;
      // 获取随机索引
     'random=$random'.log();
      if (random == 100){
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

      MSScratchWheelStartNotificationService.sendToStartIndexNotification(randomIndex);

      Future.delayed(Duration(milliseconds: 1000), () async {
        is_tap = false;
        if (!mounted) return;
        if (random == 1000){
          // 卡片
          Random random = Random();
          // 生成 0 到 2 之间的随机整数
          int randomNumber = random.nextInt(3);
          if (randomNumber == 0) {
            context.tipShow(MSFruitCardDialog());
          } else if (randomNumber == 1) {
            context.tipShow(MSDoubleCardDialog());
          } else if (randomNumber == 2) {
            context.tipShow(MS777baoCardDialog());
          }
        } else {
          context.tipShow(MSYouWinDialog(award_num: random.toDouble(), index: 0, is_wheel: true));
        }
      });

    }

  }
}



