import 'dart:async';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:megascratch/MSHome/MSLuckyWheel.dart';
import 'package:megascratch/MSTool/ms_extension_help.dart';
import 'package:megascratch/MSTool/ms_img.dart';
import 'package:megascratch/MSTool/ms_stroke_text.dart';
import 'MSHome.dart';

// MSHomePage.dart
class MSHomePage extends StatefulWidget {
  @override
  _MSHomePageState createState() => _MSHomePageState();
}
class _MSHomePageState extends State<MSHomePage> {
  int _page = 0;

  final List<Widget> _pages = [
    MSHomeContentPage(),
    MSLuckWheel(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MSHomeTbaBarNotificationService.stream.listen((value) async {
      switchTab(value);
    });
  }

  // 添加一个方法来外部调用，切换页面
  void switchTab(int index) {
    setState(() {
      _page = index;  // 切换到指定页面
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_page],
      bottomNavigationBar: Container(
        height: 87,
        decoration: BoxDecoration(
          image: MSDImg('ms_tabbar_bg'),
        ),
        child: CurvedNavigationBar(
          index: _page,
          height: 75.0,
          items: <Widget>[
            _buildNavItem(
                icon: MSImg(name: 'ms_card_s', width: 66, height: 72),
                text: "Card",
                color: '#FFFFFF'.color(),
                index: 0
            ),
            _buildNavItem(
                icon: MSImg(name: 'ms_wheel_s', width: 67, height: 62),
                text: "Lucky Wheel",
                color: '#D9C6DE'.color(),
                index: 1
            ),
          ],
          color: '#FFF06D'.color(),
          buttonBackgroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          animationDuration: Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildNavItem({required Widget icon, required String text, required Color color, required int index}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          icon,
          Positioned(
            left: index == 0 ? 64.w : 42.w,
            bottom: 10,
            child: MSStrokeText(
              text: text,
              size: 17,
              color: color,
              weight: FontWeight.w900,
              skWidth: 1,
              skColor: index == 0 ? '#752A8B'.color() : '#752A8B'.color(),
            ),
          ),
        ],
      ),
    );
  }
}


class MSHomeTbaBarNotificationService {
  static final StreamController<int> _streamController = StreamController<int>.broadcast();

  static Stream<int> get stream => _streamController.stream;

  static void sendToDomandNumberNotification(int value) {
    _streamController.sink.add(value);
  }

  static void close() {
    _streamController.close();
  }
}
