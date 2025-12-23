import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:megascratch/MSTool/ms_scratch_card_image_prize.dart';
import 'package:megascratch/MSTool/ms_stroke_text.dart';
import 'package:megascratch/MSTool/ms_text.dart';
import '../MSDialog/MSDialog.dart';
import '../MSTool/MSScratchWheelPage.dart';
import '../MSTool/ms_LocalProvider.dart';
import '../MSTool/ms_NumberHelper.dart';
import '../MSTool/ms_extension_help.dart';
import '../MSTool/ms_img.dart' hide MSAnimatedImageMove;
import 'MSHome.dart';
import 'package:spine_flutter/spine_flutter.dart' as spine;

final GlobalKey targetimageKey1 = GlobalKey();
final GlobalKey targetimageKey2 = GlobalKey();
final GlobalKey targetimageKey3 = GlobalKey();

class MSScrachDetails extends StatefulWidget {
  final int index;
  MSScrachDetails({super.key, required this.index});
  @override
  State<MSScrachDetails> createState() => _MSScrachDetailsState();
}

class _MSScrachDetailsState extends State<MSScrachDetails> {

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

  late spine.SpineWidgetController _controller0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setNumberContent();
    // 当前帧构建完成后
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在这里执行需要更新UI的操作
      shownewguide();
    });
    _controller0 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });
  }

  Future<void> shownewguide() async {
    if (!MSLocalProvider.instance.ms_new_guide){
      setState(() {
        _show_guide = true;
      });
    }
  }

  void setNumberContent(){
    if (widget.index == 0){
      result1 = MSNumberAHelper().generatelucku_Numbers();
    } else if (widget.index == 1){
      result2 = MSNumberAHelper().generatelucku_diamonds();
    } else if (widget.index == 2){
      result3 = MSNumberAHelper().generatelucku_partpay();
    } else if (widget.index == 3){
      result4 = MSNumberAHelper().generatelucku_emojifun();
    } else if (widget.index == 4){
      result5 = MSNumberAHelper().generatelucku_goldpotdig();
    } else if (widget.index == 5){
      result6 = MSNumberAHelper().generatelucku_77n();
    } else if (widget.index == 6){
      result7 = MSNumberAHelper().generatelucku_coincraze();
    }
  }

  @override
  void dispose() {
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
            alignment: AlignmentGeometry.center,
            children: [
              if (widget.index == 0)
                Positioned(top:110.h,left: (0.width(context) - 375.w) * 0.5,child: MSImg(name: 'ms_scratch_center_${widget.index}', width: 375.w, height: 232.h,)),
              if (widget.index == 1)
                Positioned(top:50.h,left: (0.width(context) - 375.w) * 0.5,child: MSImg(name: 'ms_scratch_center_${widget.index}', width: 375.w, height: 297.h,)),
              if (widget.index == 2)
                Positioned(top:70.h,left: (0.width(context) - 352.w) * 0.5,child: MSImg(name: 'ms_scratch_center_${widget.index}', width: 352.w, height: 202.h,)),
              if (widget.index == 3)
                Positioned(top:100.h,left: (0.width(context) - 375.w) * 0.5,child: MSImg(name: 'ms_scratch_center_${widget.index}', width: 375.w, height: 166.h,)),
              if (widget.index == 4)
                Positioned(top:84.h,left: (0.width(context) - 375.w) * 0.5,child: MSImg(name: 'ms_scratch_center_${widget.index}', width: 375.w, height: 154.h,)),
              Positioned(top: _getContentTopH(widget.index),child: _setScratchContentWidget(widget.index)),
              if (widget.index == 5)
                Positioned(top:60.h,left: (0.width(context) - 375.w) * 0.5,child: MSImg(name: 'ms_scratch_center_${widget.index}', width: 375.w, height: 313.h,)),
              if (widget.index == 6)
                Positioned(top:100.h,left: (0.width(context) - 322.w) * 0.5,child: MSImg(name: 'ms_scratch_center_${widget.index}', width: 322.w, height: 143.h,)),
              Column(
                children: [
                  MSNavBarWidget(),
                  Spacer(),
                  MSBottomBarWidget(),
                ],
              ),
              if (widget.index == 0)
                Positioned(top: 292.h,child: Row(
                  children: [
                   SizedBox(width: 0.w,),
                   MSStrokeText(text: 'Win Up To', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#413210'.color()),
                   SizedBox(width: 10.w,),
                   MSImg(name: 'ms_domands_icons', width: 19, height: 19,),
                   SizedBox(width: 10.w,),
                   MSStrokeText(text: '${1000}', size: 16, color: '#FBF544'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#322107'.color()),
                ],
              )),
              Positioned(left: 0, top: 300.h, width: 0.width(context), height: 400, child: Visibility(visible: _show_guide,child: Lottie.asset(
                  width: 320.w,
                  height: 260.h,
                  fit: BoxFit.fill,
                  "ms_scratch_guide.zip".files(),
                  repeat: false,
                  onLoaded: (composition) async {
                    Future.delayed(Duration(milliseconds: 1200), () async {
                      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_new_guideName, true);
                      _show_guide = false;
                      setState(() {});
                    });
                  }
              ))),
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
      h = 220.h;
    } else if (index == 6) {
      h = 214.h;
    }
    return h;
  }

  Future<void> showAwardDialog(int index, int award, bool isWin) async {
    await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_Level_inedxName, MSLocalProvider.instance.ms_Level_inedx + 1);
    if (isWin){
      if (!mounted)return;
      int code = await context.tipShow(MSYouWinADialog(award: award));
      if (code >= 0){
        backToHome(index);
      }
    } else {
      if (!mounted)return;
      int code = await context.tipShow(MSMissADialog());
      if (code >= 0){
        backToHome(index);
      }
    }
  }

  // popBack
  void backToHome(int index){
    if (index == 0 && MSLocalProvider.instance.ms_scrach_end_number_0 >= 10) {
      if (!mounted)return;
      Navigator.pop(context, 0);
    } else if (index == 1 && MSLocalProvider.instance.ms_scrach_end_number_1 >= 10) {
      if (!mounted)return;
      Navigator.pop(context, 0);
    } else if (index == 2 && MSLocalProvider.instance.ms_scrach_end_number_2 >= 10) {
      if (!mounted)return;
      Navigator.pop(context, 0);
    } else if (index == 3 && MSLocalProvider.instance.ms_scrach_end_number_3 >= 10) {
      if (!mounted)return;
      Navigator.pop(context, 0);
    } else if (index == 4 && MSLocalProvider.instance.ms_scrach_end_number_4 >= 10) {
      if (!mounted)return;
      Navigator.pop(context, 0);
    } else if (index == 5 && MSLocalProvider.instance.ms_scrach_end_number_5 >= 10) {
      if (!mounted)return;
      Navigator.pop(context, 0);
    } else if (index == 6 && MSLocalProvider.instance.ms_scrach_end_number_6 >= 10) {
      if (!mounted)return;
      Navigator.pop(context, 0);
    }
  }

  Future<void> _scratchEndtap(int index) async {
    setState(() {
      _show_animation = true;
    });
     if (index == 0){
       Future.delayed(Duration(seconds: 2), () {
         showAwardDialog(0, result1!.totalNumber.toInt(), result1!.isWin);
         setState(() {
           result1 = MSNumberAHelper().generatelucku_Numbers();
           _show_animation = false;
         });
         // 刷新下一张
         MSScratchUpdateNotificationService.sendToDomandNumberNotification(0);
         // UI切换下一张
         swapKey0.currentState!.runSwap(_buildScratchCard1(index));
       });
       await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_0Name, MSLocalProvider.instance.ms_scrach_end_number_0 + 1);
       await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_wheel_indexName, MSLocalProvider.instance.ms_wheel_index + 1);
     } else if (index == 1){
       Future.delayed(Duration(seconds: 2), () {
         showAwardDialog(1, result2!.totalNumber.toInt(), result2!.isWin);
         setState(() {
         result2 = MSNumberAHelper().generatelucku_diamonds();
           _show_animation = false;
         });
         // 刷新下一张
         MSScratchUpdateNotificationService.sendToDomandNumberNotification(0);
         // UI切换下一张
         swapKey1.currentState!.runSwap(_buildScratchCard2(index));
       });
       await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_1Name, MSLocalProvider.instance.ms_scrach_end_number_1 + 1);
       await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_wheel_indexName, MSLocalProvider.instance.ms_wheel_index + 1);
     } else if (index == 2){
       Future.delayed(Duration(seconds: 2), () {
         showAwardDialog(2, result3!.totalNumber.toInt(), result3!.isWin);
         setState(() {
           result3 = MSNumberAHelper().generatelucku_partpay();
           _show_animation = false;
         });
         // 刷新下一张
         MSScratchUpdateNotificationService.sendToDomandNumberNotification(0);
         // UI切换下一张
         swapKey2.currentState!.runSwap(_buildScratchCard3(index));
       });
       await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_2Name, MSLocalProvider.instance.ms_scrach_end_number_2 + 1);
       await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_wheel_indexName, MSLocalProvider.instance.ms_wheel_index + 1);
     } else if (index == 3){
       Future.delayed(Duration(seconds: 2), () {
         showAwardDialog(3, result4!.totalNumber.toInt(), result4!.isWin);
         setState(() {
           result4 = MSNumberAHelper().generatelucku_emojifun();
           _show_animation = false;
         });
         // 刷新下一张
         MSScratchUpdateNotificationService.sendToDomandNumberNotification(0);
         // UI切换下一张
         swapKey3.currentState!.runSwap(_buildScratchCard4(index));
       });
       await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_3Name, MSLocalProvider.instance.ms_scrach_end_number_3 + 1);
       await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_wheel_indexName, MSLocalProvider.instance.ms_wheel_index + 1);
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
       Future.delayed(Duration(seconds: 3), () {
         showAwardDialog(4, result5!.totalNumber.toInt(), result5!.isWin);
         _show_animation1 = false;
         _show_animation2 = false;
         _show_animation3 = false;
         setState(() {
           result5 = MSNumberAHelper().generatelucku_goldpotdig();
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
       await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_wheel_indexName, MSLocalProvider.instance.ms_wheel_index + 1);
     } else if (index == 5){
       Future.delayed(Duration(seconds: 2), () {
         showAwardDialog(5, result6!.totalNumber.toInt(), result6!.isWin);
         setState(() {
           result6 = MSNumberAHelper().generatelucku_77n();
           _show_animation = false;
         });
         // 刷新下一张
         MSScratchUpdateNotificationService.sendToDomandNumberNotification(0);
         // UI切换下一张
         swapKey5.currentState!.runSwap(_buildScratchCard6(index));
       });
       await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_5Name, MSLocalProvider.instance.ms_scrach_end_number_5 + 1);
       await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_wheel_indexName, MSLocalProvider.instance.ms_wheel_index + 1);
     } else if (index == 6){
       Future.delayed(Duration(seconds: 2), () {
         showAwardDialog(6, result7!.totalNumber.toInt(), result7!.isWin);
         setState(() {
           result7 = MSNumberAHelper().generatelucku_coincraze();
           _show_animation = false;
         });
         // 刷新下一张
         MSScratchUpdateNotificationService.sendToDomandNumberNotification(0);
         // UI切换下一张
         swapKey6.currentState!.runSwap(_buildScratchCard7(index));
       });
       await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_scrach_end_number_6Name, MSLocalProvider.instance.ms_scrach_end_number_6 + 1);
       await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_wheel_indexName, MSLocalProvider.instance.ms_wheel_index + 1);
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
        height: 471.h,
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
      _scratchEndtap(index);
    }, coverImagePath: 'ms_scratch_top_0'.image(), contentW: 366.w, contentH: 455.h, child: Container(
      width: 366.w,
      height: 455.h,
      decoration: BoxDecoration(
        image: MSDImg('ms_scratch_bottom_0')
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
                            Positioned(child: Center(child: MSBouncyText(text: '${result1!.displayNumbers[index]}', fontSize: 36, color:result1!.winIndex.contains(index) ? '#FF7CD3'.color() :'#FFFFFF'.color(), enableAnimation: _show_animation && result1!.winIndex.contains(index)))),
                          Positioned(top: 40.h,left: 14.w,child: Row(
                            children: [
                              MSImg(name: 'ms_domand_s_icon', width: 12, height: 12,),
                              SizedBox(width: 3.w,),
                              MSBouncyText(text: '${result1!.winMatchNumbers[index]}', fontSize: 15, color: '#FFFFFF'.color(), borderWidth: 1, borderColor: '#000000'.color(),enableAnimation: false)
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
    }, coverImagePath: 'ms_scratch_top_1'.image(), contentW: 375.w, contentH: 455.h, child: Container(
      width: 375.w,
      height: 455.h,
      decoration: BoxDecoration(
          image: MSDImg('ms_scratch_bottom_1')
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
          SizedBox(height: 14.h,),
          SizedBox(
            width: 312.w,
            height: 222.h,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 一行5个
                mainAxisSpacing: 0, // 垂直间距
                crossAxisSpacing: 0, // 水平间距
                childAspectRatio: 78.w / 74.h, // 宽高比
              ),
              itemCount: 12,
              padding: EdgeInsets.only(top: 0.h, left: 0.w), // 移除默认的padding// 最多显示10个
              itemBuilder: (context, index) {
                return SizedBox(
                    width: 78.w,
                    height: 74.h,
                    child: Stack(
                        children: [
                          if (result2!.displayNumbers[index] == 1)
                            Positioned(top: 5.h,left: 12.w,child: MSBouncyImage(imagePath: 'ms_scratch_conten_1_${result2!.displayNumbers[index]}'.image(), width: 56.52, height: 56.52, enableAnimation: false)),
                          if (result2!.displayNumbers[index] == 2)
                            Positioned(top: 5.h,left: 12.w,child: MSBouncyImage(imagePath: 'ms_scratch_conten_1_${result2!.displayNumbers[index]}'.image(), width: 59, height: 59, enableAnimation: false)),
                          if (result2!.displayNumbers[index] == 0)
                            Positioned(top: 12.h,left: 12.w,child: MSBouncyImage(imagePath: 'ms_scratch_conten_1_${result2!.displayNumbers[index]}'.image(), width: 64.14, height: 45.34, enableAnimation: _show_animation)),
                          Positioned(top: 48.h,left: 22.w,child: Row(
                            children: [
                              MSImg(name: 'ms_domand_s_icon', width: 12, height: 12,),
                              SizedBox(width: 3.w,),
                              MSBouncyText(text: '${result2!.winMatchNumbers[index]}', fontSize: 20, color: '#F4B22A'.color(), borderWidth: 1, borderColor: '#322107'.color(),enableAnimation: false)
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

  Widget _buildScratchCard3(int index){
    return MSLocalImageScratchCard(onScratchEnd: (){
      _scratchEndtap(index);
    }, coverImagePath: 'ms_scratch_top_2'.image(), contentW: 375.w, contentH: 500.h, child: Container(
      width: 375.w,
      height: 500.h,
      decoration: BoxDecoration(
          image: MSDImg('ms_scratch_bottom_2')
      ),
      child: Column(
        children: [
          SizedBox(height: 148.h,),
          SizedBox(
            width: 270.w,
            height: 270.w,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 一行5个
                mainAxisSpacing: 0, // 垂直间距
                crossAxisSpacing: 0, // 水平间距
                childAspectRatio: 90.w / 90.w, // 宽高比
              ),
              itemCount: 9,
              padding: EdgeInsets.only(top: 0.h, left: 0.w), // 移除默认的padding// 最多显示10个
              itemBuilder: (context, index) {
                return SizedBox(
                    width: 90.w,
                    height: 90.w,
                    child: Stack(
                        children: [
                          Positioned(child: Center(child: MSBouncyImage(imagePath: 'ms_scratch_conten_2_${result3!.displayNumbers[index]}'.image(), width: 51.34, height: 52, enableAnimation: result3!.winIndex.contains(index),))),
                          Positioned(top: 68.h,left: 32.w,child: Row(
                            children: [
                              MSImg(name: 'ms_domand_s_icon', width: 12, height: 12,),
                              SizedBox(width: 3.w,),
                              MSBouncyText(text: '${result3!.winMatchNumbers[index]}', fontSize: 15, color: '#FFFFFF'.color(), borderWidth: 1, borderColor: '#000000'.color(),enableAnimation: false)
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
    }, coverImagePath: 'ms_scratch_top_3'.image(), contentW: 375.w, contentH: 459.h, child: Container(
      width: 375.w,
      height: 459.h,
      decoration: BoxDecoration(
          image: MSDImg('ms_scratch_bottom_3')
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
                    SizedBox(width: 28.w,),
                    MSImg(name: 'ms_domand_s_icon', width: 22.41, height: 22.41,),
                    SizedBox(width: 3.w,),
                    MSBouncyText(text: '${result4!.winMatchNumbers[0]}', fontSize: 15, color: '#FFFFFF'.color(), borderWidth: 1, borderColor: '#000000'.color(),enableAnimation: false)
                  ],
                ),
              ),
              SizedBox(
                width: 100.w,
                height: 90.w,
                child: Row(
                  children: [
                    SizedBox(width: 28.w,),
                    MSImg(name: 'ms_domand_s_icon', width: 22.41, height: 22.41,),
                    SizedBox(width: 3.w,),
                    MSBouncyText(text: '${result4!.winMatchNumbers[1]}', fontSize: 15, color: '#FFFFFF'.color(), borderWidth: 1, borderColor: '#000000'.color(),enableAnimation: false)
                  ],
                ),
              ),
              SizedBox(
                width: 100.w,
                height: 90.w,
                child: Row(
                  children: [
                    SizedBox(width: 28.w,),
                    MSImg(name: 'ms_domand_s_icon', width: 22.41, height: 22.41,),
                    SizedBox(width: 3.w,),
                    MSBouncyText(text: '${result4!.winMatchNumbers[2]}', fontSize: 15, color: '#FFFFFF'.color(), borderWidth: 1, borderColor: '#000000'.color(),enableAnimation: false)
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
    }, coverImagePath: 'ms_scratch_top_4'.image(), contentW: 0.width(context), contentH: 500.h, child: Container(
      width: 0.width(context),
      height: 500.h,
      decoration: BoxDecoration(
          image: MSDImg('ms_scratch_bottom_4')
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
          SizedBox(height: 72.h,),
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
                                SizedBox(width: 12.w,),
                                MSImg(name: 'ms_domand_s_icon', width: 15.41, height: 15.41,),
                                SizedBox(width: 3.w,),
                                MSBouncyText(text: '${result5!.winMatchNumbers[index]}', fontSize: 15, color: '#FFFFFF'.color(), borderWidth: 1, borderColor: '#000000'.color(),enableAnimation: false)
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
    }, coverImagePath: 'ms_scratch_top_5'.image(), contentW: 0.width(context), contentH: 471.h, child: Container(
      width: 0.width(context),
      height: 471.h,
      decoration: BoxDecoration(
          image: MSDImg('ms_scratch_bottom_5')
      ),
      child: Column(
        children: [
          SizedBox(height: 110.h,),
          Padding(
            padding: EdgeInsets.only(left: 0.w),
            child: SizedBox(
              width: 325.w,
              height: 188.w,
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
                padding: EdgeInsets.only(top: 16.h, left: 24.w), // 移除默认的padding// 最多显示10个
                itemBuilder: (context, index) {
                  return SizedBox(
                      width: 65.w,
                      height: 62.6.w,
                      child: Stack(
                          children: [
                            if (result6!.displayNumbers[index] != 0 && result6!.displayNumbers[index] != 1 && result6!.displayNumbers[index] != 2)
                              Positioned(left: 1.w,child: MSBouncyText(text: '${result6!.displayNumbers[index]}', fontSize: 36, color: '#FFFFFF'.color(), borderWidth: 1, borderColor: '#000000'.color(), enableAnimation: false,)),
                            if (result6!.displayNumbers[index] == 0)
                              Positioned(left: 8.w,top: 10.h,child:MSBouncyImage(imagePath: 'ms_scratch_conten_5_${result6!.displayNumbers[index]}'.image(), width: 28.64, height: 30.54, enableAnimation: _show_animation)),
                            if (result6!.displayNumbers[index] == 1)
                              Positioned(top: 10.h,child:MSBouncyImage(imagePath: 'ms_scratch_conten_5_${result6!.displayNumbers[index]}'.image(), width: 46.04, height: 29.81, enableAnimation: _show_animation)),
                            if (result6!.displayNumbers[index] == 2)
                              Positioned(top: 7.h,child:MSBouncyImage(imagePath: 'ms_scratch_conten_5_${result6!.displayNumbers[index]}'.image(), width: 66.34, height: 34.84, enableAnimation: _show_animation)),
                            Positioned(bottom: 2.h,child:
                            SizedBox(
                              width: 65.w,
                              height: 20.6.w,
                              child: Row(
                                children: [
                                  SizedBox(width: 4.w,),
                                  MSImg(name: 'ms_domand_s_icon', width: 14, height: 14,),
                                  SizedBox(width: 3.w,),
                                  MSBouncyText(text: '${result6!.winMatchNumbers[index]}', fontSize: 15, color: (result6!.displayNumbers[index] == 0 || result6!.displayNumbers[index] == 1 || result6!.displayNumbers[index] == 2) ? '#57D81F'.color() : '#FFFFFF'.color(), borderWidth: 1, borderColor: '#000000'.color(),enableAnimation: false)
                                ],
                              ),
                            ))
                          ]
                      )
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildScratchCard7(int index){
    return MSLocalImageScratchCard(onScratchEnd: (){
      _scratchEndtap(index);
    }, coverImagePath: 'ms_scratch_top_6'.image(), contentW: 0.width(context), contentH: 484.h, child: Container(
      width: 0.width(context),
      height: 484.h,
      decoration: BoxDecoration(
          image: MSDImg('ms_scratch_bottom_6')
      ),
      child: Column(
        children: [
          SizedBox(height: 156.h,),
          SizedBox(
            width: 321.w,
            height: 211.w,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 一行5个
                mainAxisSpacing: 0, // 垂直间距
                crossAxisSpacing: 0, // 水平间距
                childAspectRatio: 80.25.w / 70.3.w, // 宽高比
              ),
              itemCount: 12,
              padding: EdgeInsets.only(top: 0.h, left: 0.w), // 移除默认的padding// 最多显示10个
              itemBuilder: (context, index) {
                return SizedBox(
                    width: 80.25.w,
                    height: 70.3.w,
                    child: Stack(
                        children: [
                          if (result7!.displayNumbers[index] == 0)
                            Positioned(left: 14.w,top: 10.h,child:MSBouncyImage(imagePath: 'ms_scratch_conten_6_${result7!.displayNumbers[index]}'.image(), width: 56, height: 47, enableAnimation: false)),
                          if (result7!.displayNumbers[index] != 0)
                            Positioned(left: 10.w, top: 18.h, child: MSImg(name: 'ms_domand_b_icon', width: 27, height: 27,)),
                          if (result7!.displayNumbers[index] != 0)
                            Positioned(left: 34.w, top: 8.h,child:
                            MSBouncyText(text: '${result7!.winMatchNumbers[index]}', fontSize: 32, color:'#F1951F'.color(), borderWidth: 1, borderColor: '#322107'.color(),enableAnimation: _show_animation)
                            )
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

}



