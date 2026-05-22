import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:megascratch/MSHome/MSTbabar.dart';
import 'package:megascratch/MSTool/ms_TBAInfoTool.dart';
import 'package:megascratch/MSTool/ms_ad_manger.dart';
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
      showzhongduanDialog();
    });
    MSScratchCashUpdateotificationService.stream.listen((value) async {
      setState(() {});
    });
    ms_event_fire('cash_page', {});
  }
  // 提现审核中断
  void showzhongduanDialog() {
    if (MSLocalProvider.instance.ms_today_tx_toast_show == true) {
      return;
    }
    if (MSLocalProvider.instance.ms_txing_status) {
      if (MSLocalProvider.instance.ms_tx_zhongduan_status){
        context.tipShow(MSTXNextDayFourToastDialog());
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
                  SizedBox(height: 39.h,),
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
                  SizedBox(height: 18.h,),
                  Row(
                    children: [
                      SizedBox(width: 14.5.w,),
                      MSText(text: 'Choose withdraw amount', size: 15, color: '#000000'.color(), weight: FontWeight.w700),
                      Spacer(),
                      if (_getNameTopStats() == true)
                        MSImg(name: 'ms_an_icon', width: 32.3, height: 36.3),
                      if (_getNameTopStats() == true)
                        SizedBox(width: 12),
                      if (_getNameTopStats() == true)
                        MSText(text: '${(MSLocalProvider.instance.ms_tx_task_day_index + 1) * 10}%', size: 20, color: '#000000'.color(), weight: FontWeight.w700),
                      if (_getNameTopStats() == true)
                        SizedBox(width: 32.w),
                    ],
                  ),
                  SizedBox(height: 0.h,),
                  SizedBox(width: 0.width(context), height: 480.h,child: MSCashVerticalList())
                ],
              ),
              Positioned(top:_getNameTopStats() == true ? (0.height(context) * 0.54) : (0.height(context) * 0.44) ,width: 0.width(context),child: MSText(text: '${MSLocalProvider.instance.ms_tx_num_index} cashouts today!  Join them, withdraw now!', size: 15, color: '#A7A7A7'.color(), weight: FontWeight.w700, align: TextAlign.center,))
            ],
          )
      ),
    );
  }

  bool _getNameTopStats(){
    if (MSLocalProvider.instance.txEntity.tx_info[MSLocalProvider.instance.ms_account_seled_index].tx_list[0].status == 1){
      return true;
    } else if (MSLocalProvider.instance.txEntity.tx_info[MSLocalProvider.instance.ms_account_seled_index].tx_list[1].status == 1){
      return true;
    } else if (MSLocalProvider.instance.txEntity.tx_info[MSLocalProvider.instance.ms_account_seled_index].tx_list[2].status == 1){
      return true;
    } else {
      return false;
    }
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
            MSScratchCashUpdateotificationService.sendToDomandNumberNotification(index);
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

  // 定义 3 个 Item 的尺寸（宽×高）
  late List<List<double>> itemSizes = [
    [346.w,MSLocalProvider.instance.txEntity.tx_info[MSLocalProvider.instance.ms_account_seled_index].tx_list[0].status == 1 ? 152.5.h : 91.h],
    [346.w,MSLocalProvider.instance.txEntity.tx_info[MSLocalProvider.instance.ms_account_seled_index].tx_list[1].status == 1 ? 152.5.h : 91.h],
    [346.w,MSLocalProvider.instance.txEntity.tx_info[MSLocalProvider.instance.ms_account_seled_index].tx_list[2].status == 1 ? 152.5.h : 91.h],
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 150),(){
      scrollindex();
    });
    MSScratchCashUpdateotificationService.stream.listen((value) async {
      itemSizes = [
        [346.w,MSLocalProvider.instance.txEntity.tx_info[MSLocalProvider.instance.ms_account_seled_index].tx_list[0].status == 1 ? 152.5.h : 91.h],
        [346.w,MSLocalProvider.instance.txEntity.tx_info[MSLocalProvider.instance.ms_account_seled_index].tx_list[1].status == 1 ? 152.5.h : 91.h],
        [346.w,MSLocalProvider.instance.txEntity.tx_info[MSLocalProvider.instance.ms_account_seled_index].tx_list[2].status == 1 ? 152.5.h : 91.h],
      ];
      if (mounted){
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> scrollindex() async {
    if (MSLocalProvider.instance.ms_txing_status == true && MSLocalProvider.instance.ms_rank_index > 10) {
      setState(() {});
      _scrollToIndex(MSLocalProvider.instance.ms_rank_index);
      if (!mounted) return;
      MSDialogTool.toastRanking(context, MSLocalProvider.instance.ms_rank_index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // 容器高度稍大于Item高度，避免裁剪
      height: 420.h,
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
    if (MSLocalProvider.instance.txEntity.tx_info[MSLocalProvider.instance.ms_account_seled_index].tx_list[index].status == 1){
      return _getTwoTypeList(index);
    } else if (MSLocalProvider.instance.txEntity.tx_info[MSLocalProvider.instance.ms_account_seled_index].tx_list[index].status == 2){
      return _getThreeTypeList(index);
    }
    return _getOneTypeList(index);
  }

  Widget _getOneTypeList(int index){
    return SizedBox(
      width: 0.width(context) - 30,
      height: MSLocalProvider.instance.txEntity.tx_info[MSLocalProvider.instance.ms_account_seled_index].tx_list[index].status == 1 ? 152.5.h : 91.h,
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
                    ms_event_fire('cash_earn_now_c', {'money' : tx_num_list[index]});
                    if (MSLocalProvider.instance.ms_dolas_number >= tx_num_list[index]){
                      context.tipShow(MSTXSubmitDialog(tx_account_index: MSLocalProvider.instance.ms_account_seled_index, tx_number_index: index));
                    } else {
                      MSDialogTool.toast(context, 'Insufficient balance');
                      MSNavigationService().changeTab(0);
                    }
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
      height: itemSizes[index].last,
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
                    if  (MSLocalProvider.instance.ms_rank_index > 10){
                      context.tipShow(MSPopRankingDialog(index: index));
                    } else if (MSLocalProvider.instance.ms_tx_wait_status == true && MSLocalProvider.instance.ms_rank_index <= 10) {
                      int code = await context.tipShow(MSTXThreeToastDialog());
                       if (code == 1){
                          setState(() {});
                       }
                    } else {
                      context.tipShow(MSTXThreeToastDialog());
                    }
                    // if (MSLocalProvider.instance.ms_tx_wait_status == true){
                    //   ms_event_fire('cash_speed_up_c', {'money' : tx_num_list[index]});
                    //   await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_wait_statusName, false);
                    //   context.tipShow(MSTXFourToastDialog());
                    // } else if (MSLocalProvider.instance.ms_tx_task_day_index >= 4){
                    //   ms_event_fire('queue_speed_up_c', {'money' : tx_num_list[index]});
                    //   MSMegaAds().ms_showAd(context, 'pppuz_withdraw_queue_rv', onCacheResponse: (onCacheResponse){
                    //
                    //   }, adDidClosed: (adDidClosed){
                    //     tapRankAdSucess();
                    //   });
                    // } else if (MSLocalProvider.instance.ms_tx_task_day_index < 4){
                    //   ms_event_fire('cash_cash_out_c', {'money' : tx_num_list[index]});
                    //   MSNavigationService().changeTab(0);
                    // } else {
                    //   ms_event_fire('queue_speed_up_c', {'money' : tx_num_list[index]});
                    //   MSMegaAds().ms_showAd(context, 'pppuz_withdraw_queue_rv', onCacheResponse: (onCacheResponse){}, adDidClosed: (adDidClosed){
                    //     tapRankAdSucess();
                    //   });
                    // }
                  },
                  child: _getTextBtn(index),
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

  Widget _getTextBtn(int index){
    // if (MSLocalProvider.instance.ms_tx_wait_status == true){
    //   ms_event_fire('cash_cash_out_c', {'money' : tx_num_list[index]});
    //   return Center(
    //     child: MSText(text: 'Speed up！', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700),
    //   );
    // } else
      if (MSLocalProvider.instance.ms_rank_index > 10){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MSImg(name: 'ms_ad_icon',width: 17.5, height: 17.5,),
          SizedBox(width: 6),
          MSText(text: 'Speed up！', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700)
        ],
      );
      } else if (MSLocalProvider.instance.ms_tx_wait_status == true && MSLocalProvider.instance.ms_rank_index <= 10) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MSText(text: 'Speed up！', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700)
          ],
        );
      } else {
      return Center(
        child: MSText(text: 'Cash Out', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700),
      );
    }
    //   else {
    //   return Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       MSImg(name: 'ms_ad_icon',width: 17.5, height: 17.5,),
    //       SizedBox(width: 6),
    //       MSText(text: 'Speed up！', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w700)
    //     ],
    //   );
    // }
  }

  Widget _showTXTaskWidget(){
    if (MSLocalProvider.instance.ms_txing_status == true) {
      if (MSLocalProvider.instance.ms_rank_index > 10) {
        return _showTXRanktaskWidget();
      } else if (MSLocalProvider.instance.ms_tx_wait_status == true && MSLocalProvider.instance.ms_rank_index <= 10){
        return _showTXTimetaskWidget();
      } else {
        return _showTXCardtaskWidget();
      }
    }
    return _showTXRanktaskWidget();
    // if (MSLocalProvider.instance.ms_tx_wait_status == true){
    //   return _showTXTimetaskWidget();
    // } else if (MSLocalProvider.instance.ms_tx_task_day_index >= 4){
    //   return _showTXRanktaskWidget();
    // } else if (MSLocalProvider.instance.ms_tx_task_day_index < 4){
    //   return _showTXCardtaskWidget();
    // } else {
    //   return _showTXRanktaskWidget();
    // }
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
            children: [
              SizedBox(width: 14.w),
              MSImg(name: 'ms_tx_card_icon', width: 28, height: 30),
              SizedBox(width: 32.w),
              MSText(text: 'Scratch 100 Cards', size: 15, color: '#000000'.color(), weight: FontWeight.w700),
              Spacer(),
              MSText(text: '${MSLocalProvider.instance.ms_tx_card_index}/100', size: 15, color: '#000000'.color(), weight: FontWeight.w700),
              SizedBox(width: 14.w),
            ],
          ),
          Row(
            mainAxisAlignment: .spaceAround,
            children: [
              MSImg(name: 'ms_tx_rili_icon', width: 24, height: 26),
              MSText(text: 'Play 20 the grand prize pool！', size: 15, color: '#000000'.color(), weight: FontWeight.w700),
              MSText(text: '${MSLocalProvider.instance.ms_pool_tx_index}/20', size: 15, color: '#000000'.color(), weight: FontWeight.w700),
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
              MSText(text: 'Reviewing Security\nWait 7 Days', size: 15, color: '#000000'.color(), weight: FontWeight.w700, maxLines: 2),
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
                itemCount: provider.ms_rank_index,
                separatorBuilder: (context, index) => const SizedBox(width: 0),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 319.w,
                    height: 25.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 24),
                        MSText(text: _ms_generateToList()[index], size: 18, color:provider.ms_rank_index == index+1 ? '#000000'.color() : '#000000'.color(opacity: 0.35), weight: FontWeight.w700),
                        Spacer(),
                        MSImg(name: provider.ms_rank_index == index+1 ? 'ms_user_s' : 'ms_user_n', width: 24.4, height: 24.4),
                        SizedBox(width: 12),
                        MSText(text: '${index + 1}', size: 18, color: provider.ms_rank_index == index+1 ? '#000000'.color() : '#000000'.color(opacity: 0.35), weight: FontWeight.w700),
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
    // if (MSLocalProvider.instance.ms_current_ranking == 100){
    //   await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_current_rankingName, 3);
    //   setState(() {});
    //   _scrollToIndex(MSLocalProvider.instance.ms_current_ranking);
    // } else {
    //   await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_current_rankingName, 100);
    //   setState(() {});
    //   _scrollToIndex(MSLocalProvider.instance.ms_current_ranking);
    // }
    if (MSLocalProvider.instance.ms_rank_index > 80){
      int row = Random().nextInt(3) + 3;
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_rank_indexName, MSLocalProvider.instance.ms_rank_index - row);
      setState(() {});
      _scrollToIndex(MSLocalProvider.instance.ms_current_ranking);
      if (!mounted) return;
      MSDialogTool.toastRanking(context, MSLocalProvider.instance.ms_rank_index);
      showtxNext();
    } else {
      int row = Random().nextInt(2) + 2;
      await MSLocalProvider.instance.updateint(MSLocalProvider.instance.ms_rank_indexName, MSLocalProvider.instance.ms_rank_index - row);
      setState(() {});
      _scrollToIndex(MSLocalProvider.instance.ms_current_ranking);
      if (!mounted) return;
      MSDialogTool.toastRanking(context, MSLocalProvider.instance.ms_rank_index);
      showtxNext();
    }
  }

  void showtxNext(){
    if (MSLocalProvider.instance.ms_rank_index <= 10) {
      if (!mounted) return;
      context.tipShow(MSTXTwoToastDialog());
    }
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
    if (index + 1 == MSLocalProvider.instance.ms_rank_index){
      return MSLocalProvider.instance.ms_current_user_ranking;
    } else if (index == MSLocalProvider.instance.ms_rank_index) {
      return MSLocalProvider.instance.ms_current_user_ranking + 1;
    } else if (index + 2 == MSLocalProvider.instance.ms_rank_index) {
      return MSLocalProvider.instance.ms_current_user_ranking - 1;
    } else {
      return MSLocalProvider.instance.ms_current_user_ranking - index;
    }
  }

  List<String> _ms_generateToList() {
    final random = Random(); // 创建一个随机数生成器
    List<String> list = List.generate(MSLocalProvider.instance.ms_rank_index, (index) {
      if (index == MSLocalProvider.instance.ms_rank_index - 1) { // 第90个位置（索引为89）
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
class MSScratchCashUpdateotificationService {
  static final StreamController<int> _streamController = StreamController<int>.broadcast();

  static Stream<int> get stream => _streamController.stream;

  static void sendToDomandNumberNotification(int value) {
    _streamController.sink.add(value);
  }

  static void close() {
    _streamController.close();
  }
}

