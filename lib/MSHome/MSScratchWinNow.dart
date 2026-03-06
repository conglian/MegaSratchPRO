import 'dart:async'; // 用于 Future.delayed
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:megascratch/MSTool/ms_img.dart';
import '../MSDialog/MSDialog.dart';
import '../MSTool/ms_TBAInfoTool.dart';
import '../MSTool/ms_extension_help.dart';
import 'MSTbabar.dart'; // 目标页面示例

class MSSratchWinNow extends StatefulWidget {
  MSSratchWinNow({super.key});
  @override
  State<MSSratchWinNow> createState() => MSSratchWinNowState();
}

class MSSratchWinNowState extends State<MSSratchWinNow> with SingleTickerProviderStateMixin {

  bool _show_guide = true;

  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    ms_event_fire('new_user_guide', {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: Opacity(opacity: 0.4,child: MSImg(name: 'ms_now_bgs', width: 0.width(context), height: 0.height(context)))),
          Positioned.fill(
            child: Column(
                children: [
                  SizedBox(height: 200.h,),
                  MSImg(name: 'ms_now_title', width: 365, height: 76,),
                  SizedBox(height: 35.h,),
                  MSImg(name: 'ms_now_center', width: 328, height: 190,),
                ],
            ),
          ),
          Positioned(left: 0, top: 240.h, width: 0.width(context), height: 400, child: InkWell(onTap: (){
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => MSBottomNavigationExample(key: MSNavigationService().bottomNavKey),
            //   ),
            // );
            Navigator.pop(context, 0);
            context.tipShow(MSNewAwardDialog());
          },child: Lottie.asset(
              width: 0.width(context),
              height: 120.h,
              fit: BoxFit.fill,
              "ms_scratch_guide.zip".files(),
              repeat: true,
              // onLoaded: (composition) async {
              //   Future.delayed(Duration(milliseconds: 1200), () async {
              //     if (!mounted) return;
              //     setState(() {
              //       _show_guide = false;
              //     });
              //   });
              // }
          ))),
          Positioned.fill(
            child: GestureDetector(
              onPanStart: (t) {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => MSBottomNavigationExample(key: MSNavigationService().bottomNavKey),
                //   ),
                // );
                Navigator.pop(context, 0);
                context.tipShow(MSNewAwardDialog());
              },
              onTap: (){
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => MSBottomNavigationExample(key: MSNavigationService().bottomNavKey),
                //   ),
                // );
                Navigator.pop(context, 0);
                context.tipShow(MSNewAwardDialog());
              },
            ),
          )
        ],
      ),
    );
  }
}
