import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:megascratch/MSTool/ms_TBAInfoTool.dart';
import 'package:megascratch/MSTool/ms_stroke_text.dart';
import 'package:megascratch/MSTool/ms_text.dart';
import 'package:provider/provider.dart';
import '../MSDialog/MSDialog.dart';
import '../MSTool/MSScratchWheelPage.dart';
import '../MSTool/ms_LocalProvider.dart';
import '../MSTool/ms_extension_help.dart';
import '../MSTool/ms_img.dart';
import '../MSTool/ms_wheel_spin.dart';
import 'MSHome.dart';
import 'MSScratchDetailsB.dart';
import 'MSTbabar.dart';


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
      // tapwheelSender();
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
              alignment: AlignmentGeometry.center,
              children: [
                Column(
                  children: [
                    MSNavBarWidget(source_from: 'home'),
                    SizedBox(height: 27.37.h,),
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
                    // Container(
                    //   width: 327.w,
                    //   height: 40.h,
                    //   decoration: BoxDecoration(
                    //     image: MSDImg('ms_unlocks_bgs')
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       SizedBox(width: 32.w,),
                    //       MSImg(name: 'ms_unlock_b_icon', width: 24, height: 29,),
                    //       SizedBox(width: 12.w,),
                    //       Container(
                    //         width: 198,
                    //         height: 17,
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(17),
                    //           border: Border.all(
                    //             color: Colors.black, // 设置边框颜色为黑色
                    //             width: 1.0,          // 设置边框宽度为 1
                    //           ),
                    //         ),
                    //         child:
                    //         ClipRRect(
                    //           borderRadius: BorderRadius.circular(15),
                    //           child: ShaderMask(
                    //             shaderCallback: (Rect bounds) {
                    //               return LinearGradient(
                    //                 begin: Alignment.topCenter,
                    //                 end: Alignment.bottomCenter,
                    //                 colors: [
                    //                   '#59FF69'.color(),
                    //                   '#118C25'.color(),
                    //                 ],
                    //               ).createShader(bounds);
                    //             },
                    //             child: Padding(
                    //               padding: EdgeInsets.only(top: 1),
                    //               child: Consumer<MSLocalProvider>(
                    //                   builder: (context, provider, child) {
                    //                     return SizedBox(
                    //                       width: 198,
                    //                       height: 17,
                    //                       child: LinearProgressIndicator(
                    //                         value: provider.ms_wheel_index / 5.0,
                    //                         minHeight: 17,
                    //                         backgroundColor: Colors.transparent,
                    //                         valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    //                       ),
                    //                     );
                    //                   }
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(width: 12.w,),
                    //       Consumer<MSLocalProvider>(
                    //           builder: (context, provider, child) {
                    //             return MSStrokeText(text: '${provider.ms_wheel_index}/5', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#000000'.color());
                    //           }
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                ),
                Positioned(left: (0.width(context) - 368.2.w) * 0.5,top: 114.78.h,child: MSImg(name: 'ms_wheel_top_0', width: 368.2.w, height: 64.86.h,)),
                Positioned(left: (0.width(context) - 283.81.w) * 0.5,top: 109.78.h,child: MSImg(name: 'ms_wheel_top_1', width: 283.81.w, height: 55.17.h,)),
                Positioned(left: (0.width(context) - 104) * 0.5,top: 283.78.h,child: Container(
                  width: 104, height: 126.8,
                  decoration: BoxDecoration(
                    image: MSDImg('ms_wheel_btn')
                  ),
                  child: InkWell(
                    onTap: (){
                      tapwheelSender();
                    },
                    child:Consumer<MSLocalProvider>(
                        builder: (context, provider, child) {
                          return Stack(
                            children: [
                              Visibility(visible: provider.ms_wheel_number > 0,child: Positioned(top: 56,left: 25,child: MSImg(name: 'ms_wheel_btn1', width: 55, height: 42,))),
                              Visibility(visible: provider.ms_wheel_number <= 0,child: Positioned(top: 50,left: 30,child: MSImg(name: 'ms_unlock_icons2', width: 46.71, height: 46.71))),
                            ],
                          );
                        }
                    ),
                  ),
                 )
                ),
                Consumer<MSLocalProvider>(
                    builder: (context, provider, child) {
                      return
                        Positioned(
                          bottom: 220.h,
                          right: 100.w,
                          width: 80,
                          height: 80,
                          child: Visibility(
                            visible: provider.ms_wheel_number > 0,
                            child: InkWell(
                              onTap: (){
                                tapwheelSender();
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
                        );
                    }
                ),
                Positioned(bottom: 40.h,child:
                Consumer<MSLocalProvider>(
                    builder: (context, provider, child) {
                      return Container(
                        width: 356.w,
                        height: 167,
                        decoration: BoxDecoration(
                            image: MSDImg('ms_wheel_bottom_bg')
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 8),
                            Row(
                              children: [
                                SizedBox(width: 12),
                                MSText(text: 'UNLOCK PROGRESS', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700),
                                Spacer(),
                                Container(
                                  width: 58,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    image: MSDImg('ms_wheel_tip_bg')
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MSText(text: '${provider.ms_key_all_index} Keys', size: 11, color: '#FFD663'.color(), weight: FontWeight.w700)
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20)
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MSImg(name: provider.ms_key_all_index >= 1 ? 'ms_wheel_key_s' : 'ms_wheel_key_n', width: 35, height: 42),
                                SizedBox(width: 12),
                                MSImg(name: provider.ms_key_all_index >= 2 ? 'ms_wheel_key_s' : 'ms_wheel_key_n', width: 35, height: 42),
                                SizedBox(width: 12),
                                MSImg(name: provider.ms_key_all_index >= 3 ? 'ms_wheel_key_s' : 'ms_wheel_key_n', width: 35, height: 42),
                                SizedBox(width: 12),
                                MSImg(name: provider.ms_key_all_index >= 4 ? 'ms_wheel_key_s' : 'ms_wheel_key_n', width: 35, height: 42),
                                SizedBox(width: 12),
                                MSImg(name: provider.ms_key_all_index >= 5 ? 'ms_wheel_key_s' : 'ms_wheel_key_n', width: 35, height: 42),
                              ],
                            ),
                            SizedBox(height: 4),
                            MSText(text: 'Find keys in Scratch Cards!', size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w700),
                            SizedBox(height: 10),
                            Container(
                                width: 171, height: 48,
                                decoration: BoxDecoration(image: MSDImg('ms_green_bg_btn')),
                                child: InkWell(
                                  onTap: (){
                                      MSNavigationService().changeTab(0);
                                      int row = 0;
                                      if (provider.ms_scrach_end_number_0 < 10){
                                        row = 0;
                                      } else if (provider.ms_scrach_end_number_1 < 10){
                                        row = 1;
                                      } else if (provider.ms_scrach_end_number_2 < 10){
                                        row = 2;
                                      } else if (provider.ms_scrach_end_number_3 < 10){
                                        row = 3;
                                      } else if (provider.ms_scrach_end_number_4 < 10){
                                        row = 4;
                                      } else if (provider.ms_scrach_end_number_5 < 10){
                                        row = 5;
                                      } else if (provider.ms_scrach_end_number_6 < 10){
                                        row = 6;
                                      }
                                      Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (builder) {
                                          return MSScrachDetails_b(
                                              index: row);
                                        },
                                      ),
                                     );
                                  },
                                  child: Stack(
                                    children: [
                                      Padding(padding: EdgeInsets.only(left: 0),child: Center(child: MSText(text: 'Go Scratch Card', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w900))),
                                      // Positioned(left:12, top:12,child: MSImg(name: 'ms_ad_icon', width: 24.9, height: 24.5,))
                                    ],
                                  ),
                                )
                            )
                          ],
                        ),
                      );
                    }
                )),
                Consumer<MSLocalProvider>(
                    builder: (context, provider, child) {
                      return Positioned(left: 2.w,top: 180.h,child: Container(
                        width: 82,
                        height: 76,
                        decoration: BoxDecoration(
                            image: MSDImg('ms_wheel_num_bgs')
                        ),
                        child: Stack(
                          children: [
                            Positioned(right: 0,top: 9,child: SizedBox(width: 33.5, height: 14.2, child: Center(
                              child: MSStrokeText(text: '${provider.ms_wheel_number}', size: 13, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#000000'.color()),
                            ),))
                          ],
                        ),
                      ));
                    }
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
      return;

    } else {
      ms_event_fire('wheel_go_c', {});
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_wheel_numberName, MSLocalProvider.instance.ms_wheel_number - 1);
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_key_all_indexName, MSLocalProvider.instance.ms_key_all_index - 5);
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



