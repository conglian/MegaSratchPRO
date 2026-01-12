import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:megascratch/MSTool/ms_stroke_text.dart';
import 'package:megascratch/MSTool/ms_text.dart';
import 'package:provider/provider.dart';
import '../MSDialog/MSDialog.dart';
import '../MSTool/MSScratchWheelPage.dart';
import '../MSTool/ms_LocalProvider.dart';
import '../MSTool/ms_extension_help.dart';
import '../MSTool/ms_img.dart';
import 'MSHome.dart';


class MSCashPage extends StatefulWidget {
  MSCashPage({super.key});
  @override
  State<MSCashPage> createState() => _MSCashPageState();
}

class _MSCashPageState extends State<MSCashPage> {


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
              image: MSDImg('ms_cash_bg')
          ),
          child:  Stack(
            fit: .expand,
            children: [
              Column(
                children: [
                  SizedBox(height: 44.h,),
                  Container(
                    width: 350.w,
                    height: 126.6.h,
                    decoration: BoxDecoration(
                      image: MSDImg('ms_cash_center_icon')
                    ),
                    child: Stack(
                      alignment: AlignmentGeometry.center,
                      children: [
                        MSImg(name: 'ms_cash_tops_icon', width: 233, height: 155,),
                        Positioned(bottom: 10,child: Container(
                          width: 319,
                          height: 31,
                          decoration: BoxDecoration(
                            image: MSDImg('ms_cash_top_pros')
                          ),
                          child: Center(
                            child: MSText(text: '100% CASH PAYMENT', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w700),
                          ),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h,),
                  MSCashHorizontalImageList(),
                  SizedBox(height: 16.h,),
                  Row(
                    children: [
                      SizedBox(width: 14.5.w,),
                      MSText(text: 'Choose withdraw amount', size: 15, color: '#000000'.color(), weight: FontWeight.w700)
                    ],
                  ),
                  SizedBox(height: 12.h,),
                  SizedBox(width: 0.width(context), height: 480.h,child: MSCashVerticalList())
                ],
              )
            ],
          )
      ),
    );
  }

}
class MSCashHorizontalImageList extends StatefulWidget {
  MSCashHorizontalImageList({super.key});
  @override
  State<MSCashHorizontalImageList> createState() => MSCashHorizontalImageListState();
}

class MSCashHorizontalImageListState extends State<MSCashHorizontalImageList> {
  // 定义 7 个 Item 的尺寸（宽×高）
  final List<List<double>> itemSizes = [
    [124,33.5],
    [124,33.5],
    [124,33.5],
    [124,33.5],
  ];
  final List<List<double>> itemSeletcdSizes = [
    [105.5,26.5],
    [105.5,26.5],
    [105.5,26.5],
    [105.5,26.5],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // 容器高度稍大于Item高度，避免裁剪
      height: 33.5,
      padding: const EdgeInsets.symmetric(horizontal: 12.5),
      child: ListView.builder(
        // 横向滑动
        scrollDirection: Axis.horizontal,
        // 取消滚动到边缘的水波纹效果
        physics: const BouncingScrollPhysics(),
        // 7个Item
        itemCount: 4,
        // 每个Item之间的间距
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 6.0), // 右侧间距
            child: _buildImageItem(index),
          );
        },
      ),
    );
  }

  // 构建单个图片Item
  Widget _buildImageItem(int index) {
    final size = MSLocalProvider.instance.ms_account_seled_index == index ? itemSizes[index] : itemSeletcdSizes[index];
    return SizedBox(
      width: size.first,
      height: size.last,
      child: InkWell(
          onTap: () async {
            await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_account_seled_indexName, index);
            setState(() {});
          },
          child: Stack(
            children: [
              Positioned(bottom: 0,child: MSImg(name: 'ms_act_${MSLocalProvider.instance.ms_account_seled_index == index ? 's' : 'n'}_$index', width: size.first, height: size.last))
            ],
          )),
    );
  }
}

List<int> tx_num_list = [1000, 2000, 3000];

class MSCashVerticalList extends StatefulWidget {
  MSCashVerticalList({super.key});
  @override
  State<MSCashVerticalList> createState() => MSCashVerticalListState();
}

class MSCashVerticalListState extends State<MSCashVerticalList> {
  // 定义 7 个 Item 的尺寸（宽×高）
  final List<List<double>> itemSizes = [
    [346,91],
    [346,91],
    [346,91],
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      // 容器高度稍大于Item高度，避免裁剪
      height: 91,
      padding: const EdgeInsets.all(0),
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        // 横向滑动
        scrollDirection: Axis.vertical,
        // 取消滚动到边缘的水波纹效果
        physics: const BouncingScrollPhysics(),
        // 7个Item
        itemCount: 3,
        // 每个Item之间的间距
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.8), // 右侧间距
            child: _buildImageItem(index),
          );
        },
      ),
    );
  }

  // 构建单个图片Item
  Widget _buildImageItem(int index) {
    final size = itemSizes[index];
    return Container(
      width: 0.width(context) - 28,
      height: size.last,
      decoration: BoxDecoration(
          color: '#FFFFFF'.color(),
          borderRadius: BorderRadius.circular(11)
      ),
      child: _getTxListWidget(index),
    );
  }

  Widget _getTxListWidget(int index){
    return _getOneTypeList(index);
  }

  Widget _getOneTypeList(int index){
    return SizedBox(
      width: 0.width(context) - 28,
      height: 91,
      child: Column(
        children: [
          SizedBox(height: 12.5,),
          Row(
            children: [
              SizedBox(width: 13.7,),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: '#000000'.color(),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '\$',
                    ),
                    TextSpan(
                      text: '${tx_num_list[index]}',
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: 130,
                height: 31,
                decoration: BoxDecoration(
                  color: '#3256CD'.color(),
                  borderRadius: BorderRadius.circular(16)
                ),
                child: InkWell(
                  onTap: () async {
                  },
                  child: Center(
                    child: MSText(text: 'Earn Now!', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(width: 11.3,)
            ],
          ),
          SizedBox(height: 8.0,),
          SizedBox(
            width: 321,
            height: 15,
            child: Stack(
              children: [
                Positioned(left: 0, top: 8.0, width: 294, height: 10,child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: MSLocalProvider.instance.ms_dolas_number / tx_num_list[index],
                    minHeight: 15.0,
                    backgroundColor: '#474747'.color(),
                    valueColor:
                    AlwaysStoppedAnimation<Color>('#58DEFF'.color()),
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget _getThreeTypeList(int index){
    return SizedBox(
      width: 329,
      height: 96,
      child: Column(
        children: [
          SizedBox(height: 12.5,),
          Row(
            children: [
              SizedBox(width: 13.7,),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'RocknRollOne',
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '\$',
                      style: TextStyle(color: index % 2 != 0 ? '#E36346'.color() : '#8137D2'.color(),fontSize: 20.0,),
                    ),
                    TextSpan(
                      text: '${tx_num_list[index]}',
                      style: TextStyle(color: index % 2 != 0 ? '#E36346'.color() : '#8137D2'.color()),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: 130,
                height: 31,
                decoration: BoxDecoration(
                    color: '#3256CD'.color(),
                    borderRadius: BorderRadius.circular(16)
                ),
                child: InkWell(
                  onTap: () async {
                  },
                  child: Center(
                    child: MSText(text: 'Success', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(width: 11.3,)
            ],
          ),
          SizedBox(height: 8.0,),
          SizedBox(
            width: 321,
            height: 15,
            child: Stack(
              children: [
                Positioned(left: 0, top: 8.0, width: 294, height: 10,child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: 1.0,
                    minHeight: 15.0,
                    backgroundColor: '#474747'.color(),
                    valueColor:
                    AlwaysStoppedAnimation<Color>('#58DEFF'.color()),
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}



