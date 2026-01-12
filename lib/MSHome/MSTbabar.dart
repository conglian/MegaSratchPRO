import 'dart:async';
import 'package:flutter/material.dart';
import 'package:megascratch/MSHome/MSLuckyWheel.dart';
import 'package:megascratch/MSTool/ms_extension_help.dart';
import 'package:megascratch/MSTool/ms_stroke_text.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'MSCashs.dart';
import 'MSHome.dart';

// 使用单例模式管理导航状态
class MSNavigationService {
  static final MSNavigationService _instance = MSNavigationService._internal();
  factory MSNavigationService() => _instance;
  MSNavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<_MSBottomNavigationExampleState> bottomNavKey = GlobalKey<_MSBottomNavigationExampleState>();

  void changeTab(int index) {
    bottomNavKey.currentState?.changeTab(index);
  }

  // 示例：从任意位置导航到首页并切换Tab
  void navigateToHomeAndChangeTab(int index) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/home', (route) => false);
    Future.delayed(Duration.zero, () => changeTab(index));
  }
}


class MSBottomNavigationExample extends StatefulWidget {
  const MSBottomNavigationExample({Key? key}) : super(key: key);

  @override
  State<MSBottomNavigationExample> createState() => _MSBottomNavigationExampleState();
}

class _MSBottomNavigationExampleState extends State<MSBottomNavigationExample> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    MSHomeContentPage(),
    MSLuckWheel(),
    MSCashPage(),
  ];

  final List<String> _titles = ['Card', 'Lucky Wheel', 'Cash'];

  // 外部切换底部导航栏的方法
  void changeTab(int index) {
    if (index >= 0) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomNavBarWidget(
        [
          PersistentBottomNavBarItem(
            icon: Image.asset('ms_card_tabbar_icon'.image()),
            inactiveIcon: Image.asset('ms_card_tabbar_icon'.image()),
            activeColorPrimary: Colors.transparent,
            inactiveColorPrimary: Colors.transparent,
            title: _titles[0],
          ),
          PersistentBottomNavBarItem(
            icon: Image.asset('ms_wheel_s'.image()),
            inactiveIcon: Image.asset('ms_wheel_s'.image()),
            activeColorPrimary: Colors.transparent,
            inactiveColorPrimary: Colors.transparent,
            title: _titles[1],
          ),
          PersistentBottomNavBarItem(
            icon: Image.asset('ms_cash_icon_s'.image()),
            inactiveIcon: Image.asset('ms_cash_icon_s'.image()),
            activeColorPrimary: Colors.transparent,
            inactiveColorPrimary: Colors.transparent,
            title: _titles[2],
          ),
        ],
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class CustomNavBarWidget extends StatelessWidget {
  const CustomNavBarWidget(
      this.items, {
        required this.selectedIndex,
        required this.onItemSelected,
        Key? key,
      }) : super(key: key);

  final int selectedIndex;
  final List<PersistentBottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;

  Widget _buildItem(final PersistentBottomNavBarItem item, final bool isSelected) {
    return Container(
      alignment: Alignment.center,
      height: 88, // 高度设置为88
      child: Stack(
        fit: .expand,
        alignment: AlignmentGeometry.center,
        children: <Widget>[
          // 背景图片
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Image.asset(
                'ms_card_seletecd'.image(), // 选中的背景图
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 图标
          Positioned(
            top: 0,
            child: Container(
              width: 78, // 图标宽度
              height: 78, // 图标高度
              child: isSelected ? item.icon : item.inactiveIcon,
            ),
          ),
          // 标签
          Positioned(
            bottom: 10, // 标签距离底部的间距
            child: MSStrokeText(text: item.title!, size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700, skWidth: 1, skColor: '#360859'.color()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('ms_card_tabbar_bgs'.image()), // 底部导航栏背景图
          fit: BoxFit.cover,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 88, // 高度设置为88
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((final item) {
            final int index = items.indexOf(item);
            return Flexible(
              child: GestureDetector(
                onTap: () => onItemSelected(index),
                child: _buildItem(item, selectedIndex == index),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
