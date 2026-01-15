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
                  SizedBox(height: 0.h,),
                  SizedBox(width: 0.width(context), height: 480.h,child: MSCashVerticalList())
                ],
              ),
              Positioned(top:MSLocalProvider.instance.ms_txing_status == true ? 424.h : 360.h,width: 0.width(context),child: MSText(text: '${MSLocalProvider.instance.ms_tx_num_index} cashouts today!  Join them, withdraw now!', size: 15, color: '#A7A7A7'.color(), weight: FontWeight.w700, align: TextAlign.center,))
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

  final ScrollController _scrollController = ScrollController();

  // 定义 7 个 Item 的尺寸（宽×高）
  final List<List<double>> itemSizes = [
    [346.w,MSLocalProvider.instance.ms_txing_status == true ? 152.5.h : 91.h],
    [346.w,91.h],
    [346.w,91.h],
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 150),(){
      scrollindex();
    });
  }

  Future<void> scrollindex() async {
    if (MSLocalProvider.instance.ms_current_ranking == 100){
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_current_rankingName, 3);
      setState(() {});
      _scrollToIndex(0);
    } else {
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_current_rankingName, 100);
      setState(() {});
      _scrollToIndex(97);
    }
    if (!context.mounted) return;
    MSDialogTool.toastRanking(context, MSLocalProvider.instance.ms_current_user_ranking);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // 容器高度稍大于Item高度，避免裁剪
      height: MSLocalProvider.instance.ms_txing_status == true ? 152.5.h : 91.h,
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
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: index == 1 ? 59.6 : 16, left: 15, right: 15), // 右侧间距
                child: _buildImageItem(index),
              ),
            ],
          );
        },
      ),
    );
  }

  void _scrollToIndex(int index) {
    // 每个 item 的高度固定为 38（根据你的例子）
    double itemHeight = 91.h / 3;

    // 计算目标位置
    final double offset = (index + 1) * itemHeight;

    // 平滑滚动动画
    if (_scrollController.positions.isEmpty) return;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  // 构建单个图片Item
  Widget _buildImageItem(int index) {
    final size = itemSizes[index];
    return Container(
      width: 0.width(context) - 30,
      height: size.last,
      decoration: BoxDecoration(
          color: '#FFFFFF'.color(),
          borderRadius: BorderRadius.circular(11)
      ),
      child: _getTxListWidget(index),
    );
  }

  Widget _getTxListWidget(int index){
    if (index == 0){
      return _getTwoTypeList(index);
    }
    return _getOneTypeList(index);
  }

  Widget _getOneTypeList(int index){
    return SizedBox(
      width: 0.width(context) - 30,
      height: MSLocalProvider.instance.ms_txing_status == true ? 152.5.h : 91.h,
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
          SizedBox(height: 16.0,),
          SizedBox(
            width: 321.w,
            height: 15,
            child: Stack(
              children: [
                Positioned(left: 0, bottom: 0.0, width: 294.w, height: 13,child: ClipRRect(
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

  Widget _getTwoTypeList(int index){
    return SizedBox(
      width: 0.width(context) - 30,
      height: MSLocalProvider.instance.ms_txing_status == true ? 152.5.h : 91.h,
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
                    tapRankAdSucess();
                  },
                  child: Center(
                    child: MSText(text: 'Cash Out', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(width: 11.3,)
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: 0.width(context) - 51,
            height: 89.5,
            decoration: BoxDecoration(
              color: '#F0F0F0'.color(),
              borderRadius: BorderRadius.circular(8)
            ),
            child: _showTXTaskWidget(),
          )
        ],
      ),
    );
  }

  Widget _showTXTaskWidget(){
    return _showTXRanktaskWidget();
    return _showTXTimetaskWidget();
    return _showTXCardtaskWidget();
  }

  // 刮卡任务
  Widget _showTXCardtaskWidget(){
    return SizedBox(
      width: 0.width(context) - 51,
      height: 89.5,
      child: Column(
        mainAxisAlignment: .spaceAround,
        children: [
          Row(
            mainAxisAlignment: .spaceAround,
            children: [
              MSImg(name: 'ms_tx_card_icon', width: 28, height: 30),
              MSText(text: 'Scratch 10 Cards', size: 15, color: '#000000'.color(), weight: FontWeight.w700),
              MSText(text: '${MSLocalProvider.instance.ms_tx_card_index}/10', size: 15, color: '#000000'.color(), weight: FontWeight.w700),
            ],
          ),
          Row(
            mainAxisAlignment: .spaceAround,
            children: [
              MSImg(name: 'ms_tx_rili_icon', width: 24, height: 26),
              MSText(text: 'Play Daily for 2 Days', size: 15, color: '#000000'.color(), weight: FontWeight.w700),
              MSText(text: '1/2', size: 15, color: '#000000'.color(), weight: FontWeight.w700),
            ],
          ),
        ],
      ),
    );
  }

  // 任务
  Widget _showTXTimetaskWidget(){
    return SizedBox(
      width: 0.width(context) - 51,
      height: 89.5,
      child: Column(
        mainAxisAlignment: .spaceAround,
        children: [
          Row(
            children: [
              SizedBox(width: 12.w),
              MSImg(name: 'ms_time_icon', width: 75, height: 75),
              SizedBox(width: 5),
              MSText(text: 'Reviewing Security\nWait 3 Days', size: 15, color: '#000000'.color(), weight: FontWeight.w700, maxLines: 2),
            ],
          ),
        ],
      ),
    );
  }

  // 任务
  Widget _showTXRanktaskWidget(){
    return SizedBox(
      width: 0.width(context) - 51,
      height: 89.5,
      child: Column(
        children: [
         Consumer<MSLocalProvider>(
           builder: (context, provider, child) {
            return SizedBox(
              width: 0.width(context) - 51,
              height: 89.5,
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(), // 禁用滚动
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(vertical: 0),
                itemCount: provider.ms_all_ranking,
                separatorBuilder: (context, index) => const SizedBox(width: 0),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 319.w,
                    height: 25.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 24),
                        MSText(text: _ms_generateToList()[index], size: 18, color:provider.ms_current_ranking == index+1 ? '#000000'.color() : '#000000'.color(opacity: 0.35), weight: FontWeight.w700),
                        Spacer(),
                        MSImg(name: provider.ms_current_ranking == index+1 ? 'ms_user_s' : 'ms_user_n', width: 24.4, height: 24.4),
                        SizedBox(width: 12),
                        MSText(text: '${_returnCurrtentindex(index)}', size: 18, color: provider.ms_current_ranking == index+1 ? '#000000'.color() : '#000000'.color(opacity: 0.35), weight: FontWeight.w700),
                        SizedBox(width: 24),
                      ],
                    ),
                  );
                },
              ),
            );
         }),
        ],
      ),
    );
  }

  Future<void> tapRankAdSucess() async {
    await getUserCurrent_index();
    if (MSLocalProvider.instance.ms_current_ranking == 100){
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_current_rankingName, 3);
      setState(() {});
      _scrollToIndex(0);
    } else {
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_current_rankingName, 100);
      setState(() {});
      _scrollToIndex(97);
    }
    if (!context.mounted) return;
    MSDialogTool.toastRanking(context, MSLocalProvider.instance.ms_current_user_ranking);
  }

  Future<void> getUserCurrent_index() async {
    int index = MSLocalProvider.instance.ms_current_user_ranking;
    if (index > 10000){
      index -= 10000;
    } else if (index > 100 && index <= 10000) {
      index -= 10;
    } else if (index <= 100) {
      index -= 1;
    }
    await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_current_user_rankingName, index);
  }

  int _returnCurrtentindex(int index){
    if (index + 1 == MSLocalProvider.instance.ms_current_ranking){
      return MSLocalProvider.instance.ms_current_user_ranking;
    } else if (index == MSLocalProvider.instance.ms_current_ranking) {
      return MSLocalProvider.instance.ms_current_user_ranking + 1;
    } else if (index + 2 == MSLocalProvider.instance.ms_current_ranking) {
      return MSLocalProvider.instance.ms_current_user_ranking - 1;
    } else {
      return MSLocalProvider.instance.ms_current_user_ranking - index;
    }
  }

  List<String> _ms_generateToList() {
    final random = Random(); // 创建一个随机数生成器
    List<String> list = List.generate(MSLocalProvider.instance.ms_all_ranking, (index) {
      if (index == MSLocalProvider.instance.ms_current_ranking - 1) { // 第90个位置（索引为89）
        return MSLocalProvider.instance.ms_account_id;
      } else {
        // 生成随机的三位数字
        String randomPart = random.nextInt(1000).toString().padLeft(4, '0');
        return "1****$randomPart";
      }
    });
    return list;
  }


  Widget _getThreeTypeList(int index){
    return SizedBox(
      width: 0.width(context) - 30,
      height: 91.h,
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
                    MSDialogTool.toast(context, 'The withdrawal was successful; please wait 1-7 business days for the funds to arrive in your account.');
                  },
                  child: Center(
                    child: MSText(text: 'Earn Now!', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(width: 11.3,)
            ],
          ),
          SizedBox(height: 16.0,),
          SizedBox(
            width: 321.w,
            height: 15,
            child: Stack(
              children: [
                Positioned(left: 0, bottom: 0.0, width: 294.w, height: 13,child: ClipRRect(
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


