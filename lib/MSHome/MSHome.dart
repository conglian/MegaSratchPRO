import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:megascratch/MSTool/ms_LocalProvider.dart';
import 'package:megascratch/MSTool/ms_stroke_text.dart';
import 'package:megascratch/MSTool/ms_text.dart';
import 'package:provider/provider.dart';

import '../MSDialog/MSDialog.dart';
import '../MSTool/ms_GradientNumber.dart';
import '../MSTool/ms_extension_help.dart';
import '../MSTool/ms_img.dart';
import '../MSTool/ms_scratch_card_image_prize.dart';
import 'MSScratchDetails.dart';
import 'MSTbabar.dart';

class MSHomeContentPage extends StatefulWidget {
  @override
  _MSHomeContentPageState createState() => _MSHomeContentPageState();
}

class _MSHomeContentPageState extends State<MSHomeContentPage> {
  // 用于控制页面内容的变量
  String pageContent = "这是首页内容"; // 初始内容

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      shownewguide();
    });

    MSSUpdateHomeListNotificationService.stream.listen((value) async {
      setState(() {});
    });
  }

  Future<void> shownewguide() async {
    if (!MSLocalProvider.instance.ms_new_guide){
      if (!mounted) return;
      context.tipShow(MSNewGuideADialog());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: 0.width(context),
          height: 0.height(context),
          decoration: BoxDecoration(
              image: MSDImg('ms_luanch_bg')
          ),
          child: Stack(
            children: [
               Column(
                 children: [
                   MSNavBarWidget(),
                   VerticalListView(),
                 ],
               )
            ],
          )
      ),
    );
  }

}
class VerticalListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 创建一个数据列表
    final List<String> items = List.generate(7, (index) => 'Item $index');

    // 获取屏幕宽度
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: 0.width(context),
      height: 0.height(context) - 118 - 87,
      child: ListView.builder(
        padding: EdgeInsets.zero, // 移除默认的 padding
        itemCount: items.length, // 列表项数量
        itemBuilder: (context, index) {
          return Container(
            width: screenWidth, // 设置列表项宽度为屏幕宽度
            height: 220, // 设置列表项高度为 200
            margin: EdgeInsets.symmetric(vertical: 0), // 设置上下间距为 12
            child: Stack(
              children: [
                InkWell(
                  onTap: (){
                    pushTodetails(index, context);
                  },
                    child: Consumer<MSLocalProvider>(
                        builder:(context, provider, child) {
                          if (index == 2 && MSLocalProvider.instance.ms_Level_number < 3 && MSLocalProvider.instance.ms_scratch_status_2 == false) {
                            return Center(child: MSImg(name: 'ms_scratch_list_${index}_n', width: 363.w, height: 166.h,));
                          } else if (index == 3 && MSLocalProvider.instance.ms_Level_number < 4 && MSLocalProvider.instance.ms_scratch_status_3 == false){
                             return Center(child: MSImg(name: 'ms_scratch_list_${index}_n', width: 363.w, height: 166.h,));
                           } else if (index == 4 && MSLocalProvider.instance.ms_Level_number < 5 && MSLocalProvider.instance.ms_scratch_status_4 == false){
                             return Center(child: MSImg(name: 'ms_scratch_list_${index}_n', width: 363.w, height: 166.h,));
                           } else if (index == 5 && MSLocalProvider.instance.ms_Level_number < 6 && MSLocalProvider.instance.ms_scratch_status_5 == false){
                             return Center(child: MSImg(name: 'ms_scratch_list_${index}_n', width: 363.w, height: 166.h,));
                           } else if (index == 6 && MSLocalProvider.instance.ms_Level_number < 7 && MSLocalProvider.instance.ms_scratch_status_6 == false){
                             return Center(child: MSImg(name: 'ms_scratch_list_${index}_n', width: 363.w, height: 166.h,));
                          }
                          return Center(child: MSImg(name: 'ms_scratch_list_$index', width: 363.w, height: 166.h,));
                        })
                ),
                Positioned(bottom: 8,left: (0.width(context) - 196) * 0.5,child: InkWell(
                  onTap: (){
                    pushTodetails(index, context);
                  },
                  child:
                      Consumer<MSLocalProvider>(
                        builder: (context, provider, child) {
                           return Container(
                             width: 196, height: 45,
                             decoration: BoxDecoration(
                                 image: MSDImg(_getGoBtnName(index))
                             ),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 if (index == 2 && (MSLocalProvider.instance.ms_Level_number < 3 && MSLocalProvider.instance.ms_scratch_status_2 == false))
                                   MSImg(name: 'ms_unlock_icon', width: 19, height: 23,),
                                 if (index == 2 && (MSLocalProvider.instance.ms_Level_number < 3 && MSLocalProvider.instance.ms_scratch_status_2 == false))
                                   SizedBox(width: 12.w,),
                                 if (index == 3 && (MSLocalProvider.instance.ms_Level_number < 4 && MSLocalProvider.instance.ms_scratch_status_3 == false))
                                   MSImg(name: 'ms_unlock_icon', width: 19, height: 23,),
                                 if (index == 3 && (MSLocalProvider.instance.ms_Level_number < 4 && MSLocalProvider.instance.ms_scratch_status_3 == false))
                                   SizedBox(width: 12.w,),
                                 if (index == 4 && (MSLocalProvider.instance.ms_Level_number < 5 && MSLocalProvider.instance.ms_scratch_status_4 == false))
                                   MSImg(name: 'ms_unlock_icon', width: 19, height: 23,),
                                 if (index == 4 && (MSLocalProvider.instance.ms_Level_number < 5 && MSLocalProvider.instance.ms_scratch_status_4 == false))
                                   SizedBox(width: 12.w,),
                                 if (index == 5 && (MSLocalProvider.instance.ms_Level_number < 6 && MSLocalProvider.instance.ms_scratch_status_5 == false))
                                   MSImg(name: 'ms_unlock_icon', width: 19, height: 23,),
                                 if (index == 5 && (MSLocalProvider.instance.ms_Level_number < 6 && MSLocalProvider.instance.ms_scratch_status_5 == false))
                                   SizedBox(width: 12.w,),
                                 if (index == 6 && (MSLocalProvider.instance.ms_Level_number < 7 && MSLocalProvider.instance.ms_scratch_status_6 == false))
                                   MSImg(name: 'ms_unlock_icon', width: 19, height: 23,),
                                 if (index == 6 && (MSLocalProvider.instance.ms_Level_number < 7 && MSLocalProvider.instance.ms_scratch_status_6 == false))
                                   SizedBox(width: 12.w,),
                                 MSStrokeText(text: _getGoBtnTitleName(index), size: 18, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#713409'.color()),
                               ],
                             ),
                           );
                      }
                   )
                )
                ),
                Positioned(bottom: 57.h,child: Row(
                  children: [
                    SizedBox(width: 118.w,),
                    MSStrokeText(text: 'Win Up To', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#413210'.color()),
                    SizedBox(width: 10.w,),
                    MSImg(name: 'ms_domands_icons', width: 19, height: 19,),
                    SizedBox(width: 10.w,),
                    MSStrokeText(text: '${1000 * (index + 1)}', size: 16, color: '#FBF544'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#322107'.color()),
                  ],
                )),
                Positioned(
                  right: 15.w,
                  top: 33.h,
                  child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(pi / 4),
                  child: Consumer<MSLocalProvider>(
                           builder:(context, provider, child) {
                             if (index == 0){
                               return MSStrokeText(text: '${provider.ms_scrach_end_number_0}/10', size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0.5, skColor: '#49100F'.color());
                             } else if (index == 1){
                               return MSStrokeText(text: '${provider.ms_scrach_end_number_1}/10', size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0.5, skColor: '#49100F'.color());
                             } else if (index == 2){
                               return MSStrokeText(text: '${provider.ms_scrach_end_number_2}/10', size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0.5, skColor: '#49100F'.color());
                             } else if (index == 3){
                               return MSStrokeText(text: '${provider.ms_scrach_end_number_3}/10', size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0.5, skColor: '#49100F'.color());
                             } else if (index == 4){
                               return MSStrokeText(text: '${provider.ms_scrach_end_number_4}/10', size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0.5, skColor: '#49100F'.color());
                             } else if (index == 5){
                               return MSStrokeText(text: '${provider.ms_scrach_end_number_5}/10', size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0.5, skColor: '#49100F'.color());
                             } else if (index == 6){
                               return MSStrokeText(text: '${provider.ms_scrach_end_number_6}/10', size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0.5, skColor: '#49100F'.color());
                             }
                             return MSStrokeText(text: '0/10', size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0.5, skColor: '#49100F'.color());
                           })
                   ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
  String _getGoBtnName(int index){
    if (index == 2 && (MSLocalProvider.instance.ms_Level_number < 3 || MSLocalProvider.instance.ms_scratch_status_2 == false)) {
      if (MSLocalProvider.instance.ms_scratch_status_2 == true) {
        return 'ms_go_btns_s';
      }
      return 'ms_go_btns_n';
    } else if (index == 3 && (MSLocalProvider.instance.ms_Level_number < 4 || MSLocalProvider.instance.ms_scratch_status_3 == false)){
      if (MSLocalProvider.instance.ms_scratch_status_3 == true) {
        return 'ms_go_btns_s';
      }
      return 'ms_go_btns_n';
    } else if (index == 4 && (MSLocalProvider.instance.ms_Level_number < 5 || MSLocalProvider.instance.ms_scratch_status_4 == false)){
      if (MSLocalProvider.instance.ms_scratch_status_4 == true) {
        return 'ms_go_btns_s';
      }
      return 'ms_go_btns_n';
    } else if (index == 5 && (MSLocalProvider.instance.ms_Level_number < 6 || MSLocalProvider.instance.ms_scratch_status_5 == false)){
      if (MSLocalProvider.instance.ms_scratch_status_5 == true) {
        return 'ms_go_btns_s';
      }
      return 'ms_go_btns_n';
    } else if (index == 6 && (MSLocalProvider.instance.ms_Level_number < 7 || MSLocalProvider.instance.ms_scratch_status_6 == false)){
      if (MSLocalProvider.instance.ms_scratch_status_6 == true) {
        return 'ms_go_btns_s';
      }
      return 'ms_go_btns_n';
    } else {
      return 'ms_go_btns_s';
    }
  }
  String _getGoBtnTitleName(int index){
    if (index == 2 && (MSLocalProvider.instance.ms_Level_number < 3 || MSLocalProvider.instance.ms_scratch_status_2 == false)) {
      if (MSLocalProvider.instance.ms_scratch_status_2 == true) {
        return 'GO PLAY！';
      }
      return 'Level 3';
    } else if (index == 3 && (MSLocalProvider.instance.ms_Level_number < 4 || MSLocalProvider.instance.ms_scratch_status_3 == false)){
      if (MSLocalProvider.instance.ms_scratch_status_3 == true) {
        return 'GO PLAY！';
      }
      return 'Level 4';
    } else if (index == 4 && (MSLocalProvider.instance.ms_Level_number < 5 || MSLocalProvider.instance.ms_scratch_status_4 == false)){
      if (MSLocalProvider.instance.ms_scratch_status_4 == true) {
        return 'GO PLAY！';
      }
      return 'Level 5';
    } else if (index == 5 && (MSLocalProvider.instance.ms_Level_number < 6 || MSLocalProvider.instance.ms_scratch_status_5 == false)){
      if (MSLocalProvider.instance.ms_scratch_status_5 == true) {
        return 'GO PLAY！';
      }
      return 'Level 6';
    } else if (index == 6 && (MSLocalProvider.instance.ms_Level_number < 7 || MSLocalProvider.instance.ms_scratch_status_6 == false)){
      if (MSLocalProvider.instance.ms_scratch_status_6 == true) {
        return 'GO PLAY！';
      }
      return 'Level 7';
    } else {
      return 'GO PLAY！';
    }
  }
  // 详情页
  void pushTodetails(int index, BuildContext cxt){
    if (index == 2 && (MSLocalProvider.instance.ms_Level_number < 3 || MSLocalProvider.instance.ms_scratch_status_2 == false)) {
      if (MSLocalProvider.instance.ms_scratch_status_2 == true) {
        pushdetails(cxt, index);
      } else {
        cxt.tipShow(MSUnlockDialog(indexs: index));
      }
      return;
    } else if (index == 3 && (MSLocalProvider.instance.ms_Level_number < 4 || MSLocalProvider.instance.ms_scratch_status_3 == false)){
      if (MSLocalProvider.instance.ms_scratch_status_3 == true) {
        pushdetails(cxt, index);
      } else {
        cxt.tipShow(MSUnlockDialog(indexs: index));
      }
      return;
    } else if (index == 4 && (MSLocalProvider.instance.ms_Level_number < 5 || MSLocalProvider.instance.ms_scratch_status_4 == false)){
      if (MSLocalProvider.instance.ms_scratch_status_4 == true) {
        pushdetails(cxt, index);
      } else {
        cxt.tipShow(MSUnlockDialog(indexs: index));
      }
      return;
    } else if (index == 5 && (MSLocalProvider.instance.ms_Level_number < 6 || MSLocalProvider.instance.ms_scratch_status_5 == false)){
      if (MSLocalProvider.instance.ms_scratch_status_5 == true) {
        pushdetails(cxt, index);
      } else {
        cxt.tipShow(MSUnlockDialog(indexs: index));
      }
      return;
    } else if (index == 6 && (MSLocalProvider.instance.ms_Level_number < 7 || MSLocalProvider.instance.ms_scratch_status_6 == false)){
      if (MSLocalProvider.instance.ms_scratch_status_6 == true) {
        pushdetails(cxt, index);
      } else {
        cxt.tipShow(MSUnlockDialog(indexs: index));
      }
      return;
    } else if (index == 0 && MSLocalProvider.instance.ms_scrach_end_number_0 >= 10) {
      cxt.tipShow(MSAll10Dialog(type: index));
      return;
    } else if (index == 1 && MSLocalProvider.instance.ms_scrach_end_number_1 >= 10) {
      cxt.tipShow(MSAll10Dialog(type: index));
      return;
    } else if (index == 2 && MSLocalProvider.instance.ms_scrach_end_number_2 >= 10) {
      cxt.tipShow(MSAll10Dialog(type: index));
      return;
    } else if (index == 3 && MSLocalProvider.instance.ms_scrach_end_number_3 >= 10) {
      cxt.tipShow(MSAll10Dialog(type: index));
      return;
    } else if (index == 4 && MSLocalProvider.instance.ms_scrach_end_number_4 >= 10) {
      cxt.tipShow(MSAll10Dialog(type: index));
      return;
    } else if (index == 5 && MSLocalProvider.instance.ms_scrach_end_number_5 >= 10) {
      cxt.tipShow(MSAll10Dialog(type: index));
      return;
    } else if (index == 6 && MSLocalProvider.instance.ms_scrach_end_number_6 >= 10) {
      cxt.tipShow(MSAll10Dialog(type: index));
      return;
    } else {
      Navigator.of(cxt).push(
        MaterialPageRoute(
          builder: (builder) {
            return MSScrachDetails(
                index: index);
          },
        ),
      );
    }

  }
  void pushdetails(BuildContext cxt,int index){
    Navigator.of(cxt).push(
      MaterialPageRoute(
        builder: (builder) {
          return MSScrachDetails(
              index: index);
        },
      ),
    );
  }
}

class MSNavBarWidget extends StatefulWidget {
  MSNavBarWidget({super.key});
  @override
  State<MSNavBarWidget> createState() => _MSNavBarWidgetState();
}

class _MSNavBarWidgetState extends State<MSNavBarWidget> {

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 0.width(context),
      height: 118,
      decoration: BoxDecoration(
          image: MSDImg('ms_navbar_bg')
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Spacer(),
              Row(
                children: [
                  SizedBox(width: 10.22.w,),
                  Container(
                    width: 130.w,
                    height: 27.h,
                    decoration: BoxDecoration(
                      image: MSDImg('ms_plays_n')
                    ),
                    child: Padding(padding: EdgeInsets.only(left: 38.w, top: 1.h),child: Consumer<MSLocalProvider>(
                        builder: (context, provider, child) {
                          return MSGradientNumberRoller(
                              value: provider.ms_domand_number,
                              duration: 800,
                              fontSize: 20.0,
                              gradientColors: ['#FFFFFF'.color(), '#FFFFFF'.color()],
                              borderColor: '#FFFFFF'.color(),
                              borderWidth: 0.0,
                              decimalPlaces: 0,
                            );
                        }
                    ),),
                  ),
                  SizedBox(width: 3.83.w,),
                  Container(
                    width: 130.w,
                    height: 27.h,
                    decoration: BoxDecoration(
                        image: MSDImg('ms_plays_n')
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  '#FFFB38'.color(),
                                  '#F1B727'.color(),
                                  '#C37E23'.color(),
                                ],
                              ).createShader(bounds);
                            },
                            child:
                            Consumer<MSLocalProvider>(
                                builder: (context, provider, child) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: SizedBox(
                                      width: 128.w,
                                      height: 25.h,
                                      child: LinearProgressIndicator(
                                        value: provider.ms_Level_inedx / 5.0,
                                        minHeight: 25.h,
                                        backgroundColor: Colors.transparent,
                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                  );
                                }
                            )
                          ),
                        ),
                        Consumer<MSLocalProvider>(
                            builder: (context, provider, child) {
                              return Center(
                                child: MSStrokeText(text: 'Lv.${provider.ms_Level_number}', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#3E210C'.color()),
                              );
                            }
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: (){
                      context.tipShow(MSPopTaskADialog());
                    },
                    child: MSImg(name: 'ms_task_icon', width: 43, height: 42,),
                  ),
                  SizedBox(width: 7.27.w,),
                  InkWell(
                    onTap: (){
                      context.tipShow(MSPopSettingDialog());
                    },
                    child: MSImg(name: 'ms_set_icon', width: 43, height: 42,),
                  ),
                  SizedBox(width: 7.34.w,)
                ],
              ),
              SizedBox(height: 8.8.h,)
            ],
          ),
          Positioned(left: 7.w, bottom: 10.7.h,child: MSImg(name: 'ms_domands_icons', width: 37, height: 37,)),
          Positioned(left: 141.w, bottom: 9.0.h,child: Container(
                    width: 37.65, height: 42.3,
                    decoration: BoxDecoration(
                      image: MSDImg('ms_level_bg')
                    ),
            child: Consumer<MSLocalProvider>(
               builder: (context, provider, child) {
                  return Center(
                     child: MSText(text: '${provider.ms_Level_number}', size: 20, color: '#FBE933'.color(), weight: FontWeight.w700),
                  );
               }
             )
          ))
        ],
      ),
    );
  }
}

class MSBottomBarWidget extends StatefulWidget {
  MSBottomBarWidget({super.key});
  @override
  State<MSBottomBarWidget> createState() => _MSBottomBarWidgetState();
}

class _MSBottomBarWidgetState extends State<MSBottomBarWidget> {

  @override
  Widget build(BuildContext context) {

    return Container(
        width: 0.width(context),
        height: 88,
        decoration: BoxDecoration(
            image: MSDImg('ms_bottom_bar_bg')
        ),
        child: Row(
          children: [
            SizedBox(width: 17.09.w,),
            InkWell(
              onTap: (){
                Navigator.pop(context);// 外部调用
                MSHomeTbaBarNotificationService.sendToDomandNumberNotification(1);
              },
              child: Container(
                width: 55,
                height: 50,
                decoration: BoxDecoration(
                    image: MSDImg('ms_wheel_b_btn')
                ),
                child: Stack(
                  children: [
                  Positioned(
                    right: 2,
                    top: 5,
                    child: Container(
                    width: 26,
                    height: 11,
                    decoration: BoxDecoration(
                      color: '#000000'.color(opacity: 0.38),
                      borderRadius: BorderRadius.circular(5.5),
                    ),
                    child: Center(
                      child:
                      Consumer<MSLocalProvider>(
                          builder: (context, provider, child) {
                            return MSStrokeText(text: '${provider.ms_wheel_index}/5', size: 11, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0.3, skColor: '#000000'.color());
                          }
                      ),
                     ),
                    ),
                  ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 11.25.w,),
            Container(
              width: 207,
              height: 59,
              decoration: BoxDecoration(
                  image: MSDImg('ms_green_b_btn')
              ),
              child: InkWell(
                onTap: () async {
                  'ms_scractch_auto=${MSLocalProvider.instance.ms_scractch_auto}'.log();
                  if (!MSLocalProvider.instance.ms_scractch_auto){
                    await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scractch_autoName, true);
                    MSScratchUpdateNotificationService.sendToDomandNumberNotification(1);
                  }
                },
                child: Center(
                  child: MSStrokeText(text: 'REVEAL ALL', size: 22, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#FFFFFF'.color()),
                ),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                width: 37,
                height: 40,
                decoration: BoxDecoration(
                    image: MSDImg('ms_back_icon')
                ),
                child: Stack(
                  children: [
                  ],
                ),
              ),
            ),
            SizedBox(width: 20.w,),
          ],
        )
    );
  }
}


final swapKey0 = GlobalKey<_MSCardSwapAnimatorState>();
final swapKey1 = GlobalKey<_MSCardSwapAnimatorState>();
final swapKey2 = GlobalKey<_MSCardSwapAnimatorState>();
final swapKey3 = GlobalKey<_MSCardSwapAnimatorState>();
final swapKey4 = GlobalKey<_MSCardSwapAnimatorState>();
final swapKey5 = GlobalKey<_MSCardSwapAnimatorState>();
final swapKey6 = GlobalKey<_MSCardSwapAnimatorState>();

class MSCardSwapAnimator extends StatefulWidget {
  final Widget child;                 // 初始卡片
  final Duration duration;

  const MSCardSwapAnimator({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 650),
  });

  @override
  State<MSCardSwapAnimator> createState() => _MSCardSwapAnimatorState();
}

class _MSCardSwapAnimatorState extends State<MSCardSwapAnimator>
    with SingleTickerProviderStateMixin {

  late Widget _current;
  Widget? _next;

  late AnimationController _controller;

  late Animation<double> oldOffsetX;
  late Animation<double> oldRotation;

  late Animation<double> newOffsetX;
  late Animation<double> newRotation;
  late Animation<double> newOpacity;

  @override
  void initState() {
    super.initState();

    _current = widget.child;

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    oldOffsetX = Tween<double>(begin: 0, end: 280).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0.0, 0.65, curve: Curves.easeIn)),
    );

    oldRotation = Tween<double>(begin: 0, end: 0.35).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0.0, 0.7, curve: Curves.easeIn)),
    );

    newOffsetX = Tween<double>(begin: -280, end: 0).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0.35, 1.0, curve: Curves.easeOutBack)),
    );

    newRotation = Tween<double>(begin: -0.35, end: 0).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0.35, 1.0, curve: Curves.easeOut)),
    );

    newOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0.3, 1.0, curve: Curves.easeOut)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override void didUpdateWidget(MSCardSwapAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当外部 child 改变时，如果没有正在动画，需要更新 _current
    if (oldWidget.child != widget.child && _next == null) {
      setState(() {
        _current = widget.child;
      });
    }
  }

  /// 外部调用 controller.swapTo(newCard) 时触发此处
  Future<void> runSwap(Widget newCard) async {
    await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scractch_autoName, false);
    if (!mounted) return;

    if (_next != null) return; // 动画未结束时不允许叠加切换

    _next = newCard;

    await _controller.forward();

    if (!mounted) return;

    // 动画结束：替换 current
    setState(() {
      _current = _next!;
      _next = null;
      MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scractch_autoName, false);
    });

    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Stack(
          children: [

            /// OLD CARD
            Transform.translate(
              offset: Offset(oldOffsetX.value, 0),
              child: Transform.rotate(
                angle: oldRotation.value,
                child: _current,
              ),
            ),

            /// NEW CARD（可能为空）
            if (_next != null)
              Opacity(
                opacity: newOpacity.value,
                child: Transform.translate(
                  offset: Offset(newOffsetX.value, 0),
                  child: Transform.rotate(
                    angle: newRotation.value,
                    child: _next!,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}


class MSSUpdateHomeListNotificationService {
  static final StreamController<int> _streamController = StreamController<int>.broadcast();

  static Stream<int> get stream => _streamController.stream;

  static void sendToDomandNumberNotification(int value) {
    _streamController.sink.add(value);
  }

  static void close() {
    _streamController.close();
  }
}
