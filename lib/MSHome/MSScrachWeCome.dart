import 'dart:async'; // 用于 Future.delayed
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:megascratch/MSTool/ms_img.dart';
import 'package:megascratch/main.dart'; // 替换为实际目标页面
import '../MSTool/ms_extension_help.dart';
import 'MSHome.dart';
import 'MSScratchWinNow.dart'; // 目标页面示例

class MSSratchWeCome extends StatefulWidget {
  MSSratchWeCome({super.key});

  @override
  State<MSSratchWeCome> createState() => MSSratchJoyLaunchState();
}

class MSSratchJoyLaunchState extends State<MSSratchWeCome> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    // 延时 1 秒后跳转到其他页面
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      context.tipShow(MSSratchWinNow());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          MSImg(name: 'ms_wecome_bg', width: 0.width(context), height: 0.height(context)),
          Column(
            children: [
              SizedBox(height: 240.h,),
              MSImg(name: 'ms_wecome_title', width: 351, height: 125,),
            ],
          ),
        ],
      ),
    );
  }
}
