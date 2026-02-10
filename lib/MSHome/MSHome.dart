import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:megascratch/MSTool/ms_LocalProvider.dart';
import 'package:megascratch/MSTool/ms_stroke_text.dart';
import 'package:megascratch/MSTool/ms_text.dart';
import 'package:megascratch/main.dart';
import 'package:provider/provider.dart';
import '../MSDialog/MSDialog.dart';
import '../MSTool/ms_GradientNumber.dart';
import '../MSTool/ms_GradientText.dart';
import '../MSTool/ms_NoticeTool.dart';
import '../MSTool/ms_NumberHelper.dart';
import '../MSTool/ms_TBAInfoTool.dart';
import '../MSTool/ms_WebKitView.dart';
import '../MSTool/ms_extension_help.dart';
import '../MSTool/ms_fkmanger.dart';
import '../MSTool/ms_img.dart';
import '../MSTool/ms_scratch_card_image_prize.dart';
import 'MSScrachWeCome.dart';
import 'MSScratchDetailsB.dart';
import 'MSTbabar.dart';
import 'package:flutter/widgets.dart';

class MSHomeContentPage extends StatefulWidget {
  @override
  _MSHomeContentPageState createState() => _MSHomeContentPageState();
}

class _MSHomeContentPageState extends State<MSHomeContentPage> {

  // 总倒计时时间，单位是秒
  int _remainingTime = MSLocalProvider.instance.ms_dao_time_index; // 5 分钟倒计时（300秒）

  late Timer _timer;

  int award_pool_number = MSNumberAHelper().getAwardPoolNumber();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ms_event_fire('home_page', {});
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showsignDialog();
      shownewguide();
      showTXPopDialog();
      _startCountdown();
    });

    MSSUpdateHomeListNotificationService.stream.listen((value) async {
      setState(() {});
    });
    MSFKManger().initFK();
    MSNoticeHelp().initNotice();
    MSNoticeHelp().startForegroundService();
  }

  // 启动倒计时
  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (MSLocalProvider.instance.ms_dao_time_index > 0) {
        if (_remainingTime == 0){
          _remainingTime = MSLocalProvider.instance.ms_dao_time_index;
        }
        setState(() {
          _remainingTime--;
          MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_dao_time_indexName, _remainingTime);
        });
      } else {
        setState(() {
          MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_dao_time_indexName, 0);
        });
        // _timer.cancel(); // 时间到，取消定时器
      }
    });
  }

  // 显示签到
  Future<void> showsignDialog() async {
    if (MSLocalProvider.instance.ms_today_sign_status == false && MSLocalProvider.instance.ms_today_sign_show == false && MSLocalProvider.instance.ms_new_guide1 == true){
      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_today_sign_showName, true);
      if (!mounted) return;
      context.tipShow(MSPopTaskBDialog(is_guide: false));
    }
  }

  Future<void> shownewguide() async {
    if (MSLocalProvider.instance.ms_new_guide1 == false){
      context.tipShow(MSSratchWeCome());
    }
  }
  // 隔天显示提现流程
  Future<void> showTXPopDialog() async {
    if (MSLocalProvider.instance.ms_tx_date_str.length <= 0) {
      return;
    }
    await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_today_tx_toast_showName, true);
    'MSLocalProvider.instance.ms_tx_date_str=${MSLocalProvider.instance.ms_tx_date_str}'.log();
    if (MSLocalProvider.instance.ms_txing_status == true){
      int code = await _checkIfConsecutive();
       if (code == 1) {
         // 连续日期
         if (MSLocalProvider.instance.ms_tx_wait_status == true){
           if (!mounted) return;
           context.tipShow(MSTXFourToastDialog());
           await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_wait_statusName, false);
         } else if (MSLocalProvider.instance.ms_tx_task_day_index == 0 && MSLocalProvider.instance.ms_tx_showtask_today_status == false) {
           await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_showtask_today_statusName, true);
           if (!mounted) return;
           context.tipShow(MSTXFiveToastDialog());
         } else if (MSLocalProvider.instance.ms_tx_task_day_index == 1 && MSLocalProvider.instance.ms_tx_showtask_today_status == false) {
           await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_showtask_today_statusName, true);
           if (!mounted) return;
           context.tipShow(MSTXNextDayOneToastDialog());
         } else if (MSLocalProvider.instance.ms_tx_task_day_index == 2 && MSLocalProvider.instance.ms_tx_showtask_today_status == false) {
           await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_showtask_today_statusName, true);
           if (!mounted) return;
           context.tipShow(MSTXDayThreeOneToastDialog());
         } else if (MSLocalProvider.instance.ms_tx_task_day_index == 3 && MSLocalProvider.instance.ms_tx_showtask_today_status == false) {
           await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_showtask_today_statusName, true);
           if (!mounted) return;
           context.tipShow(MSTXDayFourOneToastDialog());
         }
       } else if (code == 2){
         // 隔天
         if (MSLocalProvider.instance.ms_tx_showtask_today_status == false){
           await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_showtask_today_statusName, true);
           if (!mounted) return;
           context.tipShow(MSTXNextDayFourToastDialog());
         }
       }
    }
  }

  // 判断保存的日期和当前日期是否连续
  Future<int> _checkIfConsecutive() async {
    if (MSLocalProvider.instance.ms_tx_date_str.length <= 0) {
      return 0;
    }
    DateTime savedDate = DateFormat('yyyy-MM-dd').parse(MSLocalProvider.instance.ms_tx_date_str);
    final difference = DateTime.now().difference(savedDate).inDays;
    // 获取当前时间
    DateTime now = DateTime.now();
    // 使用 DateFormat 格式化为 yyyy-MM-dd
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    await MSLocalProvider.instance.updateString(MSLocalProvider.instance.ms_tx_date_strName, formattedDate);
    // 判断差值是否为1，表示连续日期（例如：昨天）
    if (difference == 1) {
      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_showtask_today_statusName, false);
      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_zhongduan_statusName, false);
      return 1; // 连续日期
    } else if (difference == 0) {
      return 0; // 当天不处理
    } else {
      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_showtask_today_statusName, false);
      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_zhongduan_statusName, false);
      return 2; // 隔天
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
               SingleChildScrollView(
                 child: Column(
                   children: [
                     MSNavBarWidget(source_from: 'home'),
                     VerticalListView(),
                   ],
                 ),
               ),
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
              Positioned(left: 12,bottom: 20.h,child: InkWell(
                onTap: () async {
                  String gaids = await FlutterTbaInfo.instance.getGaid();
                  Navigator.of(root_navigatorKey.currentState!.context).push(
                    MaterialPageRoute(builder: (builder) {
                      return MSwebkitview(
                        url: "https://s.gamifyspace.com/tml?pid=20086&appk=UR91J64cW2uF0fpw6P5IpNycOGFKUe5j&did=${gaids}",
                        title: 'luckyscratchgame',
                      );
                    }),
                  );
                },
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    children: [
                      Positioned(left: 3,child: MSImg(name: 'ms_game_icon', width: 51, height: 50,)),
                      Positioned(bottom: 0,child: MSStrokeText(text: 'More Game', size: 10, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 0.5, skColor: '#000000'.color()))
                    ],
                  ),
                ),
              )),
              Positioned(left: 12.w,top: 155.h,child: Consumer<MSLocalProvider>(
                  builder: (context, provider, child) {
                    if (provider.ms_pool_show){
                      ms_event_fire('new_bonus_pool_v', {});
                    }
                    return Visibility(
                      visible: provider.ms_pool_show,
                      child: InkWell(
                        onTap: () async {
                          ms_event_fire('new_bonus_pool_c', {});
                          ms_event_fire('bonus_pool_c_n', {});
                          context.tipShow(MSAwardPoolDialog(award_num: award_pool_number, time_index: _remainingTime, index: -1));
                        },
                        child:SizedBox(
                          width: 72,
                          height: 72,
                          child: Stack(
                            children: [
                              MSBouncyImage(imagePath: 'ms_jiangjin_btn'.image(), width: 72, height: 72, enableAnimation: true),
                              Positioned(left: 3.5,top: 50,child: Visibility(
                                visible: MSLocalProvider.instance.ms_dao_time_index != 0,
                                child: Container(
                                  width: 65,
                                  height: 18,
                                  decoration: BoxDecoration(
                                      color: '#EAEFFF'.color(),
                                      borderRadius: BorderRadius.circular(9)
                                  ),
                                  child: Center(
                                    child: MSText(text: _formatTime(_remainingTime), size: 12, color: '#393939'.color(), weight: FontWeight.w700),
                                  ),
                                ),
                              )),
                              Positioned(left: 0,top: 34,child: MSGradientStrokeText(text: '\$10000', gradientColors: ['#FBF544'.color(),'#F4B22A'.color()], width: 72, height: 21, fontSize: 16, strokeWidth: 1, strokeColor: '#804D00'.color())),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              ), ),
            ],
          )
      ),
    );
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

}
class VerticalListView extends StatefulWidget {
  @override
  _VerticalListViewState createState() => _VerticalListViewState();
}
class _VerticalListViewState extends State<VerticalListView> with TickerProviderStateMixin {
  late List<AnimationController> _scaleControllers;
  late List<Animation<double>> _scaleAnimations;
  List<bool> _isZoomed = [];
  List<int> listnum = [2000, 3000, 5000,5000,5000,8000,10000];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    int itemCount = 7;
    _scaleControllers = List.generate(itemCount, (index) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200), // 每张图片动画时长为200ms
      );
    });

    _scaleAnimations = List.generate(itemCount, (index) {
      return Tween<double>(
        begin: 1.0,
        end: 1.15, // 放大1.5倍
      ).animate(
        CurvedAnimation(
          parent: _scaleControllers[index],
          curve: Curves.easeInOut,
        ),
      );
    });

    _isZoomed = List.generate(itemCount, (index) => false); // 初始化每个图片的状态

    MSSUpdateListNotificationService.stream.listen((value) async {
      showLockAnimation();
    });

  }

  Future<void> showLockAnimation() async {
    if (MSLocalProvider.instance.ms_Level_number >= 3 && MSLocalProvider.instance.ms_scratch_status_2 == true && MSLocalProvider.instance.ms_show_animation_2 == false){
      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_show_animation_2Name, true);
      animation_index(2);
    } else if (MSLocalProvider.instance.ms_Level_number >= 4 && MSLocalProvider.instance.ms_scratch_status_3 == true && MSLocalProvider.instance.ms_show_animation_3 == false){
      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_show_animation_3Name, true);
      animation_index(3);
    } else if (MSLocalProvider.instance.ms_Level_number >= 5 && MSLocalProvider.instance.ms_scratch_status_4 == true && MSLocalProvider.instance.ms_show_animation_4 == false){
      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_show_animation_4Name, true);
      animation_index(4);
    } else if (MSLocalProvider.instance.ms_Level_number >= 6 && MSLocalProvider.instance.ms_scratch_status_5 == true && MSLocalProvider.instance.ms_show_animation_5 == false){
      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_show_animation_5Name, true);
      animation_index(5);
    } else if (MSLocalProvider.instance.ms_Level_number >= 7 && MSLocalProvider.instance.ms_scratch_status_6 == true && MSLocalProvider.instance.ms_show_animation_6 == false){
      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_show_animation_6Name, true);
      animation_index(6);
    }
  }

  void animation_index(int index){

    // 触发放大并立即缩小
    setState(() {
      if (_scaleControllers[index].isCompleted || _scaleControllers[index].isDismissed) {
        // 如果动画完成或尚未开始，重新启动
        _scaleControllers[index].reset();
        _scaleControllers[index].forward(); // 放大
        // 延迟后执行缩小动画
        Future.delayed(Duration(milliseconds: 100), () {
          _scaleControllers[index].reverse(); // 缩小
        });
      } else {
        // 如果动画没有完成，直接反向执行
        _scaleControllers[index].reverse(); // 缩小
      }
    });

    // 在放大后立刻开始缩小动画
    Future.delayed(Duration(milliseconds: 100), () {
      _scaleControllers[index].reverse();
    });
  }

  @override
  void dispose() {
    for (var controller in _scaleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 创建一个数据列表
    final List<String> items = List.generate(7, (index) => 'Item $index');

    // 获取屏幕宽度
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: 0.width(context),
      height: 0.height(context) - 118 - 88,
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
                            return AnimatedBuilder(
                                animation: _scaleControllers[index],
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _scaleAnimations[index].value, // 动态缩放图片
                                    child: Center(child: MSImg(
                                      name: 'ms_scratch_list_${index}_n',
                                      width: 363.w,
                                      height: 188,)),
                                  );
                                });
                          } else if (index == 3 && MSLocalProvider.instance.ms_Level_number < 4 && MSLocalProvider.instance.ms_scratch_status_3 == false){
                             return AnimatedBuilder(
                                 animation:_scaleControllers[index],
                                 builder: (context, child) {
                                   return Transform.scale(
                                     scale:_scaleAnimations[index].value, // 动态缩放图片
                                     child: Center(child: MSImg(
                                       name: 'ms_scratch_list_${index}_n',
                                       width: 363.w,
                                       height: 188,)),
                                   );
                                 });
                           } else if (index == 4 && MSLocalProvider.instance.ms_Level_number < 5 && MSLocalProvider.instance.ms_scratch_status_4 == false){
                             return AnimatedBuilder(
                                 animation: _scaleControllers[index],
                                 builder: (context, child) {
                                   return Transform.scale(
                                     scale: _scaleAnimations[index].value, // 动态缩放图片
                                     child: Center(child: MSImg(
                                       name: 'ms_scratch_list_${index}_n',
                                       width: 363.w,
                                       height: 188,)),
                                   );
                                 });
                           } else if (index == 5 && MSLocalProvider.instance.ms_Level_number < 6 && MSLocalProvider.instance.ms_scratch_status_5 == false){
                             return AnimatedBuilder(
                                 animation: _scaleControllers[index],
                                 builder: (context, child) {
                                   return Transform.scale(
                                     scale: _scaleAnimations[index].value, // 动态缩放图片
                                     child: Center(child: MSImg(
                                       name: 'ms_scratch_list_${index}_n',
                                       width: 363.w,
                                       height: 188,)),
                                   );
                                 });
                           } else if (index == 6 && MSLocalProvider.instance.ms_Level_number < 7 && MSLocalProvider.instance.ms_scratch_status_6 == false){
                             return AnimatedBuilder(
                                 animation: _scaleControllers[index],
                                 builder: (context, child) {
                                   return Transform.scale(
                                     scale: _scaleAnimations[index].value, // 动态缩放图片
                                     child: Center(child: MSImg(
                                       name: 'ms_scratch_list_${index}_n',
                                       width: 363.w,
                                       height: 188,)),
                                   );
                                 });
                          }
                          return AnimatedBuilder(
                              animation:_scaleControllers[index],
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _scaleAnimations[index].value, // 动态缩放图片
                                  child: Center(child: MSImg(
                                    name: 'ms_scratch_list_${index}',
                                    width: 363.w,
                                    height: 188,)),
                                );
                              });
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
                Positioned(bottom: getNameToBottomH(index),child: Row(
                  children: [
                    SizedBox(width: 118.w,),
                    MSStrokeText(text: 'Win Up To', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#413210'.color()),
                    SizedBox(width: 10.w,),
                    MSImg(name: 'ms_dolas_icon_s', width: 22, height: 22,),
                    SizedBox(width: 10.w,),
                    MSStrokeText(text: '${listnum[index]}', size: 16, color: '#FBF544'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#322107'.color()),
                  ],
                )),
                Positioned(
                  right: 37.w,
                  bottom: getindexToBottomH(index),
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
              ],
            ),
          );
        },
      ),
    );
  }

  double getNameToBottomH(int index){
    double doubles = 58;
    return doubles;
  }

  double getindexToBottomH(int index){
    double doubles = 62;
    return doubles;
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
    ms_event_fire('card_list_c', {});
    if (index == 2 && (MSLocalProvider.instance.ms_Level_number < 3 || MSLocalProvider.instance.ms_scratch_status_2 == false)) {
      if (MSLocalProvider.instance.ms_scratch_status_2 == true) {
        animationshow(cxt, index);
      } else {
        cxt.tipShow(MSUnlockDialog(indexs: index));
      }
      return;
    } else if (index == 3 && (MSLocalProvider.instance.ms_Level_number < 4 || MSLocalProvider.instance.ms_scratch_status_3 == false)){
      if (MSLocalProvider.instance.ms_scratch_status_3 == true) {
        animationshow(cxt, index);
      } else {
        cxt.tipShow(MSUnlockDialog(indexs: index));
      }
      return;
    } else if (index == 4 && (MSLocalProvider.instance.ms_Level_number < 5 || MSLocalProvider.instance.ms_scratch_status_4 == false)){
      if (MSLocalProvider.instance.ms_scratch_status_4 == true) {
        animationshow(cxt, index);
      } else {
        cxt.tipShow(MSUnlockDialog(indexs: index));
      }
      return;
    } else if (index == 5 && (MSLocalProvider.instance.ms_Level_number < 6 || MSLocalProvider.instance.ms_scratch_status_5 == false)){
      if (MSLocalProvider.instance.ms_scratch_status_5 == true) {
        animationshow(cxt, index);
      } else {
        cxt.tipShow(MSUnlockDialog(indexs: index));
      }
      return;
    } else if (index == 6 && (MSLocalProvider.instance.ms_Level_number < 7 || MSLocalProvider.instance.ms_scratch_status_6 == false)){
      if (MSLocalProvider.instance.ms_scratch_status_6 == true) {
        animationshow(cxt, index);
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
      animationshow(cxt, index);
    }

  }
  void animationshow(BuildContext ctx, int index){
    // 触发放大并立即缩小
    setState(() {
      if (_scaleControllers[index].isCompleted || _scaleControllers[index].isDismissed) {
        // 如果动画完成或尚未开始，重新启动
        _scaleControllers[index].reset();
        _scaleControllers[index].forward(); // 放大
        // 延迟后执行缩小动画
        Future.delayed(Duration(milliseconds: 100), () {
          _scaleControllers[index].reverse(); // 缩小
        });
      } else {
        // 如果动画没有完成，直接反向执行
        _scaleControllers[index].reverse(); // 缩小
      }
    });

    // 在放大后立刻开始缩小动画
    Future.delayed(Duration(milliseconds: 100), () {
      _scaleControllers[index].reverse();
    });
    Future.delayed(Duration(milliseconds: 200), () {
      pushdetails(ctx, index);
    });

  }
  void pushdetails(BuildContext cxt,int index){
    Navigator.of(cxt).push(
      MaterialPageRoute(
        builder: (builder) {
          return MSScrachDetails_b(
              index: index);
        },
      ),
    );
  }
}

// 自定义画一个斜着的闪光线条
class DiagonalFlashPainter extends CustomPainter {
  final double opacity;
  final Size size;

  DiagonalFlashPainter({required this.opacity, required this.size});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white.withOpacity(opacity) // 白色，透明度控制
      ..strokeWidth = 5.0 // 线条宽度
      ..style = PaintingStyle.stroke; // 只绘制线条

    // 从左上角到右下角绘制斜线
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MSNavBarWidget extends StatefulWidget {
  final String source_from;
  MSNavBarWidget({super.key, required this.source_from});
  @override
  State<MSNavBarWidget> createState() => _MSNavBarWidgetState();
}

class _MSNavBarWidgetState extends State<MSNavBarWidget> {

  @override
  Widget build(BuildContext context) {
    ms_event_fire('day7_status', {'task_status' : MSLocalProvider.instance.ms_today_sign_status == true ? 1 : 0});
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
                  InkWell(
                    onTap: (){
                      ms_event_fire('home_reward_c', {});
                      MSNavigationService().changeTab(2);
                    },
                    child: Container(
                      width: 130.w,
                      height: 27.h,
                      decoration: BoxDecoration(
                        image: MSDImg('ms_plays_n')
                      ),
                      child: Padding(padding: EdgeInsets.only(left: 38.w, top: 1.h),child: Consumer<MSLocalProvider>(
                          builder: (context, provider, child) {
                            return MSGradientNumberRoller(
                                value: provider.ms_dolas_number,
                                duration: 800,
                                fontSize: 20.0,
                                gradientColors: ['#FFFFFF'.color(), '#FFFFFF'.color()],
                                borderColor: '#FFFFFF'.color(),
                                borderWidth: 0.0,
                                decimalPlaces: 2,
                              );
                          }
                      ),),
                    ),
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
                      if (widget.source_from == 'home'){
                        ms_event_fire('7day_c', {'source_from' : widget.source_from});
                        context.tipShow(MSPopTaskBDialog(is_guide: false));
                      } else {
                        Navigator.pop(context, 1);
                      }
                    },
                    child: Consumer<MSLocalProvider>(
                        builder: (context, provider, child) {
                          return Container(
                            width: 42,
                            height: 43,
                            decoration: BoxDecoration(
                                image: MSDImg(widget.source_from == 'home' ? (provider.ms_today_sign_status == true ? 'ms_sigin_btn' : 'ms_tasks_icon') : 'ms_back_icon')
                            ),
                            child: Stack(
                              children: [
                                Visibility(visible: !provider.ms_today_sign_status && widget.source_from == 'home',child: Positioned(right: 0,top: -2,child: MSImg(name:'ms_tasks_gantan',width: 15, height: 15,)))
                              ],
                            ),
                          );
                        }
                    )
                  ),
                  SizedBox(width: 2.w,),
                  InkWell(
                    onTap: (){
                      context.tipShow(MSPopSettingDialog());
                      // context.tipShow(MSNewNoticeDialog());
                    },
                    child: MSImg(name: 'ms_set_icon', width: 43, height: 42,),
                  ),
                  SizedBox(width: 4.w,),
                ],
              ),
              SizedBox(height: 8.8.h,)
            ],
          ),
          Positioned(left: 1.w, bottom: 4.7.h,child: MSImg(name: 'ms_dolas_icon', width: 54, height: 52,)),
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
      height: 102,
      decoration: BoxDecoration(
          image: MSDImg('ms_tabbar_bgs')
      ),
      child: Row(
        children: [
          SizedBox(
            width: (0.width(context) - 156) * 0.5,
            height: 102,
            child: InkWell(
              onTap: () {
                Navigator.pop(context); // 外部调用
                ms_event_fire('wheel_c', {'source_from' : 'card'});
                MSNavigationService().changeTab(1);
              },
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 18.w,
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
                                child: Consumer<MSLocalProvider>(
                                    builder: (context, provider, child) {
                                      return MSStrokeText(
                                          text: '${provider.ms_wheel_index}/5',
                                          size: 11,
                                          color: '#FFFFFF'.color(),
                                          weight: FontWeight.w700,
                                          skWidth: 0.3,
                                          skColor: '#000000'.color()
                                      );
                                    }
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      left: 22.w,
                      top: 60,
                      child: MSStrokeText(
                          text: 'Wheel',
                          size: 16,
                          color: '#FFFFFF'.color(),
                          weight: FontWeight.w700,
                          skWidth: 1,
                          skColor: '#360859'.color()
                      )
                  ),
                ],
              ),
            ),
          ),
          // 中间按钮
          SizedBox(
            width: 156,
            height: 102,
            child: Padding(
              padding: EdgeInsets.only(top: 30, bottom: 10),
              child: Container(
                  width: 156,
                  height: 59,
                  decoration: BoxDecoration(
                      image: MSDImg('ms_tabbar_bottom_btn')
                  ),
                  child: InkWell(
                    onTap: () async {
                      'ms_scractch_auto=${MSLocalProvider.instance.ms_scractch_auto}'.log();
                      if (!MSLocalProvider.instance.ms_scractch_auto) {
                        await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_scractch_autoName, true);
                        MSScratchUpdateNotificationService.sendToDomandNumberNotification(1);
                      }
                    },
                    child: Stack(
                      children: [
                        Positioned(
                          left: 18,
                          top: 16,
                          child: MSStrokeText(
                              text: 'REVEAL ALL',
                              size: 22,
                              color: '#FFFFFF'.color(),
                              weight: FontWeight.w700,
                              skWidth: 1,
                              skColor: '#0E820E'.color()
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ),
          ),
          SizedBox(
            width: (0.width(context) - 156) * 0.5,
            height: 102,
            child: InkWell(
              onTap: () {
                Navigator.pop(context); // 外部调用
                MSNavigationService().changeTab(2);
              },
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    right: 18.w,
                    child: Container(
                      width: 61.73,
                      height: 61.73,
                      decoration: BoxDecoration(
                          image: MSDImg('ms_tabbar_cash')
                      ),
                    ),
                  ),
                  Positioned(
                      right: 36.w,
                      top: 64,
                      child: MSStrokeText(
                          text: 'Cash',
                          size: 16,
                          color: '#FFFFFF'.color(),
                          weight: FontWeight.w700,
                          skWidth: 1,
                          skColor: '#360859'.color()
                      )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
