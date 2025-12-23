import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'ms_mp3_player.dart';

class MSLocalProvider extends ChangeNotifier {
  // 1. 私有构造函数（禁止外部直接创建实例）
  MSLocalProvider._();

  // 2. 静态单例实例
  static final MSLocalProvider _instance = MSLocalProvider._();

  // 3. 提供全局访问点
  static MSLocalProvider get instance => _instance;

  // MSTXModel txEntity = MSTXModel();

  String ms_Scratch_timeKey_0 = '';
  String ms_Scratch_timeKey_1 = '';
  String ms_Scratch_timeKey_2 = '';
  String ms_Scratch_timeKey_3 = '';
  String ms_Scratch_timeKey_4 = '';
  String ms_Scratch_timeKey_5 = '';
  String ms_Scratch_timeKey_6= '';
  String ms_account_id = '';
  String ms_tx_list = "";
  String ms_ratio_str = "90";


  bool ms_bg_music = true; // 存储的本地值
  bool ms_sound_music = true; // 存储的本地值
  bool ms_login_status = false; // 存储的本地值
  bool ms_scratch_status_0 = true;
  bool ms_scratch_status_1 = true;
  bool ms_scratch_status_2 = false;
  bool ms_scratch_status_3 = false;
  bool ms_scratch_status_4 = false;
  bool ms_scratch_status_5 = false;
  bool ms_scratch_status_6 = false;
  bool ms_scratch_status_7 = false;
  bool ms_scratch_status_8 = false;
  bool ms_scratch_guide = true;
  bool ms_old_guide = true;
  bool ms_new_guide = false;
  bool is_end_Scratch = true;
  bool ms_show_dolas_ani = false;
  bool ms_show_bubble = false;
  bool ms_show_box_guide = false;
  bool ms_cloak_status = false;
  bool ms_fk_number_status = false;
  bool ms_fk_decvice_status = false;
  bool ms_fk_ip_status = false;
  bool ms_fk_ad_short_show = false;
  bool ms_fk_ad_short_close = false;
  bool ms_dolas_800 = false;
  bool ms_dolas_1000 = false;
  bool ms_yunying_3 = false;
  bool ms_yunying_1 = false;
  bool ms_100_timer_star = false;
  bool ms_txing_status = false;
  bool ms_tx_first_status = false;
  bool ms_tx_last_status = false;
  bool ms_show_box_tips = false;
  bool ms_first_box_tips = false;
  bool ms_first_show_cash = false;
  bool ms_open_tx = false;
  bool ms_tx_task2_tips = false;
  bool ms_last_tx_end = false;
  bool ms_show_box = false;
  bool ms_scractch_auto = false;
  bool ms_login_award_0 = false;
  bool ms_login_award_1 = false;
  bool ms_login_award_2 = false;
  bool ms_login_award_3 = false;
  bool ms_login_award_4 = false;
  bool ms_login_award_5 = false;
  bool ms_login_award_6 = false;

  int ms_scrach_unlock_index_0 = 0; // 存储的本地值
  int ms_scrach_unlock_index_1 = 0; // 存储的本地值
  int ms_ad_all_number = 0;
  double ms_dolas_number = 0.0;
  int ms_dolas_old_number = 0;
  int ms_ad_reawrd_all_number = 0;
  int ms_ad_short_show_number = 0;
  int ms_ad_short_close_number = 0;
  int ms_ad_show_index = 0;
  int ms_ad_show_number = 0;
  int ms_key_number = 0;
  int ms_account_seled_index = 0;
  int ms_tx_ing_account = 0;
  int ms_tx_ing_number = 0;
  int ms_tx_task_index = 0;
  int ms_current_ranking = 99;
  int ms_all_ranking = 388;
  int ms_rank_ad_count = 0;
  int ms_tx_card_index = 0;
  int ms_tx_wheel_index = 0;
  int ms_tx_bubble_index = 0;
  int ms_tx_box_index = 0;
  int ms_wheel_number = 0;
  int ms_wheel_index = 0;
  int ms_box_index = 0;
  int ms_card_number = 0;
  int ms_Level_number = 0; // 存储的本地值
  int ms_Level_inedx = 0; // 存储的本地值
  int ms_dice_number = 0;
  int ms_scrach_end_number_0 = 0; // 存储的本地值
  int ms_scrach_end_number_1 = 0; // 存储的本地值
  int ms_scrach_end_number_2 = 0; // 存储的本地值
  int ms_scrach_end_number_3 = 0; // 存储的本地值
  int ms_scrach_end_number_4 = 0; // 存储的本地值
  int ms_scrach_end_number_5 = 0; // 存储的本地值
  int ms_scrach_end_number_6 = 0; // 存储的本地值
  int ms_currentNumberIndex = 0;
  int ms_domand_number = 0;
  int ms_tx_card_first = 0;
  int ms_tx_dice_index = 0;
  int ms_login_index = 1;
  int ms_tx_probability_index = 0;
  int ms_scratch_not_award_number = 0;

  String get ms_currentNumberIndexName => 'ms_currentNumberIndex';
  String get ms_dice_numberName => 'ms_dice_number';
  String get ms_domand_numberName => 'ms_domand_number';
  String get ms_scrach_end_number_0Name => 'ms_scrach_end_number_0';
  String get ms_scrach_end_number_1Name => 'ms_scrach_end_number_1';
  String get ms_scrach_end_number_2Name => 'ms_scrach_end_number_2';
  String get ms_scrach_end_number_3Name => 'ms_scrach_end_number_3';
  String get ms_scrach_end_number_4Name => 'ms_scrach_end_number_4';
  String get ms_scrach_end_number_5Name => 'ms_scrach_end_number_5';
  String get ms_scrach_end_number_6Name => 'ms_scrach_end_number_6';
  String get ms_sound_musicName => 'ms_sound_music';
  String get ms_bg_musicName => 'ms_bg_music';
  String get ms_Scratch_timeKey_0Name => 'ms_Scratch_timeKey_0';
  String get ms_Scratch_timeKey_1Name => 'ms_Scratch_timeKey_1';
  String get ms_Scratch_timeKey_2Name => 'ms_Scratch_timeKey_2';
  String get ms_Scratch_timeKey_3Name => 'ms_Scratch_timeKey_3';
  String get ms_Scratch_timeKey_4Name => 'ms_Scratch_timeKey_4';
  String get ms_Scratch_timeKey_5Name => 'ms_Scratch_timeKey_5';
  String get ms_Scratch_timeKey_6Name => 'ms_Scratch_timeKey_6';
  String get ms_Level_numberName => 'ms_Level_number';
  String get ms_Level_inedxName => 'ms_Level_inedx';
  String get ms_fk_number_statusName => 'ms_fk_number_status';
  String get ms_fk_ip_statusName => 'ms_fk_ip_status';
  String get ms_fk_decvice_statusName => 'ms_fk_decvice_status';
  String get ms_ad_show_numberName => 'ms_ad_show_number';
  String get ms_ad_all_numberName => 'ms_ad_all_number';
  String get ms_ad_show_indexName => 'ms_ad_show_index';
  String get ms_ad_reawrd_all_numberName => 'ms_ad_reawrd_all_number';
  String get ms_ad_short_show_numberName => 'ms_ad_short_show_number';
  String get ms_fk_ad_short_showName => 'ms_fk_ad_short_show';
  String get ms_ad_short_close_numberName => 'ms_ad_short_close_number';
  String get ms_fk_ad_short_closeName => 'ms_fk_ad_short_close';
  String get ms_new_guideName => 'ms_new_guide';
  String get ms_ratio_strName => 'ms_ratio_str';
  String get ms_dolas_1000Name => 'ms_dolas_1000';
  String get ms_dolas_800Name => 'ms_dolas_800';
  String get ms_100_timer_starName => 'ms_100_timer_star';
  String get ms_dolas_numberName => 'ms_dolas_number';
  String get ms_card_numberName => 'ms_card_number';
  String get ms_show_dolas_aniName => 'ms_show_dolas_ani';
  String get ms_box_indexName => 'ms_box_index';
  String get ms_txing_statusName => 'ms_txing_status';
  String get ms_tx_ing_numberName => 'ms_tx_ing_number';
  String get ms_account_seled_indexName => 'ms_account_seled_index';
  String get ms_tx_ing_accountName => 'ms_tx_ing_account';
  String get ms_tx_bubble_indexName => 'ms_tx_bubble_index';
  String get ms_tx_card_indexName => 'ms_tx_card_index';
  String get ms_tx_wheel_indexName => 'ms_tx_wheel_index';
  String get ms_tx_box_indexName => 'ms_tx_box_index';
  String get ms_tx_task_indexName => 'ms_tx_task_index';
  String get ms_tx_card_firstName => 'ms_tx_card_first';
  String get ms_account_idName => 'ms_account_id';
  String get ms_tx_dice_indexName => 'ms_tx_dice_index';
  String get ms_login_indexName => 'ms_login_index';
  String get ms_tx_probability_indexName => 'ms_tx_probability_index';
  String get ms_tx_first_statusName => 'ms_tx_first_status';
  String get ms_tx_last_statusName => 'ms_tx_last_status';
  String get ms_current_rankingName => 'ms_current_ranking';
  String get ms_all_rankingName => 'ms_all_ranking';
  String get ms_old_guideName => 'ms_old_guide';
  String get ms_scratch_not_award_numberName => 'ms_scratch_not_award_number';
  String get ms_cloak_statusName => 'ms_cloak_status';
  String get ms_show_box_tipsName => 'ms_show_box_tips';
  String get ms_first_box_tipsName => 'ms_first_box_tips';
  String get ms_first_show_cashName => 'ms_first_show_cash';
  String get ms_scratch_guideName => 'ms_scratch_guide';
  String get ms_open_txName => 'ms_open_tx';
  String get ms_tx_task2_tipsName => 'ms_tx_task2_tips';
  String get ms_last_tx_endName => 'ms_last_tx_end';
  String get is_end_ScratchName => 'is_end_Scratch';
  String get ms_yunying_1Name => 'ms_yunying_1';
  String get ms_yunying_3Name => 'ms_yunying_3';
  String get ms_show_boxName => 'ms_show_box';
  String get ms_scractch_autoName => 'ms_scractch_auto';
  String get ms_scratch_status_2Name => 'ms_scratch_status_2';
  String get ms_scratch_status_3Name => 'ms_scratch_status_3';
  String get ms_scratch_status_4Name => 'ms_scratch_status_4';
  String get ms_scratch_status_5Name => 'ms_scratch_status_5';
  String get ms_scratch_status_6Name => 'ms_scratch_status_6';
  String get ms_wheel_numberName => 'ms_wheel_number';
  String get ms_wheel_indexName => 'ms_wheel_index';
  String get ms_login_award_0Name => 'ms_login_award_0';
  String get ms_login_award_1Name => 'ms_login_award_1';
  String get ms_login_award_2Name => 'ms_login_award_2';
  String get ms_login_award_3Name => 'ms_login_award_3';
  String get ms_login_award_4Name => 'ms_login_award_4';
  String get ms_login_award_5Name => 'ms_login_award_5';
  String get ms_login_award_6Name => 'ms_login_award_6';


  // 3. 初始化：从本地存储加载数据（组件初始化时调用）
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    // 从本地读取值（key自定义，需与存储时一致）
    ms_wheel_number = prefs.getInt('ms_wheel_number') ?? 0;
    ms_wheel_index = prefs.getInt('ms_wheel_index') ?? 0;
    ms_tx_probability_index = prefs.getInt('ms_tx_probability_index') ?? 0;
    ms_login_index = prefs.getInt('ms_login_index') ?? 1;
    ms_tx_dice_index = prefs.getInt('ms_tx_dice_index') ?? 0;
    ms_tx_card_first = prefs.getInt('ms_tx_card_first') ?? 0;
    ms_domand_number = prefs.getInt('ms_domand_number') ?? 0;
    ms_dice_number = prefs.getInt('ms_dice_number') ?? 0;
    ms_card_number = prefs.getInt('ms_card_number') ?? 0;
    ms_box_index = prefs.getInt('ms_box_index') ?? 0;
    ms_tx_box_index = prefs.getInt('ms_tx_box_index') ?? 0;
    ms_wheel_number = prefs.getInt('ms_wheel_number') ?? 0;
    ms_tx_card_index = prefs.getInt('ms_tx_card_index') ?? 0;
    ms_tx_wheel_index = prefs.getInt('ms_tx_wheel_index') ?? 0;
    ms_tx_bubble_index = prefs.getInt('ms_tx_bubble_index') ?? 0;
    ms_current_ranking = prefs.getInt('ms_current_ranking') ?? 99;
    ms_all_ranking = prefs.getInt('ms_all_ranking') ?? 388;
    ms_rank_ad_count = prefs.getInt('ms_rank_ad_count') ?? 388;
    ms_tx_task_index = prefs.getInt('ms_tx_task_index') ?? 0;
    ms_tx_ing_account = prefs.getInt('ms_tx_ing_account') ?? 0;
    ms_tx_ing_number = prefs.getInt('ms_tx_ing_number') ?? 0;
    ms_scratch_not_award_number = prefs.getInt('ms_scratch_not_award_number') ?? 0;
    ms_account_seled_index = prefs.getInt('ms_account_seled_index') ?? 0;
    ms_scrach_unlock_index_0 = prefs.getInt('ms_scrach_unlock_index_0') ?? 0;
    ms_scrach_unlock_index_1 = prefs.getInt('ms_scrach_unlock_index_1') ?? 0;
    ms_ad_short_show_number = prefs.getInt('ms_ad_short_show_number') ?? 0;
    ms_ad_short_close_number = prefs.getInt('ms_ad_short_close_number') ?? 0;
    ms_ad_show_number = prefs.getInt('ms_ad_show_number') ?? 0;
    ms_key_number = prefs.getInt('ms_key_number') ?? 0;
    ms_bg_music = prefs.getBool('ms_bg_music') ?? true;
    ms_sound_music = prefs.getBool('ms_sound_music') ?? true;
    ms_txing_status = prefs.getBool('ms_txing_status') ?? false;
    ms_login_status = prefs.getBool('ms_login_status') ?? false;
    ms_open_tx = prefs.getBool('ms_open_tx') ?? false;
    ms_show_box = prefs.getBool('ms_show_box') ?? false;
    ms_scractch_auto = prefs.getBool('ms_scractch_auto') ?? false;
    is_end_Scratch = prefs.getBool('is_end_Scratch') ?? true;
    ms_cloak_status = prefs.getBool('ms_cloak_status') ?? false;
    ms_show_box_tips = prefs.getBool('ms_show_box_tips') ?? false;
    ms_first_box_tips = prefs.getBool('ms_first_box_tips') ?? false;
    ms_fk_number_status = prefs.getBool('ms_fk_number_status') ?? false;
    ms_fk_decvice_status = prefs.getBool('ms_fk_decvice_status') ?? false;
    ms_fk_ad_short_show = prefs.getBool('ms_fk_ad_short_show') ?? false;
    ms_fk_ad_short_close = prefs.getBool('ms_fk_ad_short_close') ?? false;
    ms_fk_ip_status = prefs.getBool('ms_fk_ip_status') ?? false;
    ms_scratch_guide = prefs.getBool('ms_scratch_guide') ?? true;
    ms_old_guide = prefs.getBool('ms_old_guide') ?? true;
    ms_new_guide = prefs.getBool('ms_new_guide') ?? false;
    ms_show_bubble = prefs.getBool('ms_show_bubble') ?? false;
    ms_show_dolas_ani = prefs.getBool('ms_show_dolas_ani') ?? false;
    ms_show_box_guide = prefs.getBool('ms_show_box_guide') ?? false;
    ms_dolas_800 = prefs.getBool('ms_dolas_800') ?? false;
    ms_dolas_1000 = prefs.getBool('ms_dolas_1000') ?? false;
    ms_100_timer_star = prefs.getBool('ms_100_timer_star') ?? false;
    ms_tx_first_status = prefs.getBool('ms_tx_first_status') ?? false;
    ms_tx_last_status = prefs.getBool('ms_tx_last_status') ?? false;
    ms_first_show_cash = prefs.getBool('ms_first_show_cash') ?? false;
    ms_tx_task2_tips = prefs.getBool('ms_tx_task2_tips') ?? false;
    ms_last_tx_end = prefs.getBool('ms_last_tx_end') ?? false;
    ms_yunying_3 = prefs.getBool('ms_yunying_3') ?? false;
    ms_login_award_0 = prefs.getBool('ms_login_award_0') ?? false;
    ms_login_award_1 = prefs.getBool('ms_login_award_1') ?? false;
    ms_login_award_2 = prefs.getBool('ms_login_award_2') ?? false;
    ms_login_award_3 = prefs.getBool('ms_login_award_3') ?? false;
    ms_login_award_4 = prefs.getBool('ms_login_award_4') ?? false;
    ms_login_award_5 = prefs.getBool('ms_login_award_5') ?? false;
    ms_login_award_6 = prefs.getBool('ms_login_award_6') ?? false;
    ms_ad_reawrd_all_number = prefs.getInt('ms_ad_reawrd_all_number') ?? 0;
    ms_ad_all_number = prefs.getInt('ms_ad_all_number') ?? 0;
    ms_dolas_number = prefs.getDouble('ms_dolas_number') ?? 0.0;
    ms_dolas_old_number = prefs.getInt('ms_dolas_old_number') ?? 0;
    ms_ad_show_index = prefs.getInt('ms_ad_show_index') ?? 0;
    ms_Level_number = prefs.getInt('ms_Level_number') ?? 0;
    ms_Level_inedx = prefs.getInt('ms_Level_inedx') ?? 0;
    ms_scrach_end_number_0 = prefs.getInt('ms_scrach_end_number_0') ?? 0;
    ms_scrach_end_number_1 = prefs.getInt('ms_scrach_end_number_1') ?? 0;
    ms_scrach_end_number_2 = prefs.getInt('ms_scrach_end_number_2') ?? 0;
    ms_scrach_end_number_3 = prefs.getInt('ms_scrach_end_number_3') ?? 0;
    ms_scrach_end_number_4 = prefs.getInt('ms_scrach_end_number_4') ?? 0;
    ms_scrach_end_number_5 = prefs.getInt('ms_scrach_end_number_5') ?? 0;
    ms_scrach_end_number_6 = prefs.getInt('ms_scrach_end_number_6') ?? 0;
    ms_currentNumberIndex = prefs.getInt('ms_currentNumberIndex') ?? 0;
    ms_scratch_status_0 = prefs.getBool('ms_scratch_status_0') ?? true;
    ms_scratch_status_1 = prefs.getBool('ms_scratch_status_1') ?? true;
    ms_scratch_status_2 = prefs.getBool('ms_scratch_status_2') ?? false;
    ms_scratch_status_3 = prefs.getBool('ms_scratch_status_3') ?? false;
    ms_scratch_status_4 = prefs.getBool('ms_scratch_status_4') ?? false;
    ms_scratch_status_5 = prefs.getBool('ms_scratch_status_5') ?? false;
    ms_scratch_status_6 = prefs.getBool('ms_scratch_status_6') ?? false;
    ms_scratch_status_7 = prefs.getBool('ms_scratch_status_7') ?? false;
    ms_scratch_status_8 = prefs.getBool('ms_scratch_status_8') ?? false;
    ms_Scratch_timeKey_0 = prefs.getString('ms_Scratch_timeKey_0') ?? '';
    ms_Scratch_timeKey_1 = prefs.getString('ms_Scratch_timeKey_1') ?? '';
    ms_Scratch_timeKey_2 = prefs.getString('ms_Scratch_timeKey_2') ?? '';
    ms_Scratch_timeKey_3 = prefs.getString('ms_Scratch_timeKey_3') ?? '';
    ms_Scratch_timeKey_4 = prefs.getString('ms_Scratch_timeKey_4') ?? '';
    ms_Scratch_timeKey_5 = prefs.getString('ms_Scratch_timeKey_5') ?? '';
    ms_Scratch_timeKey_6 = prefs.getString('ms_Scratch_timeKey_6') ?? '';
    ms_ratio_str = prefs.getString('ms_ratio_str') ?? '90';
    ms_account_id = prefs.getString('ms_account_id') ?? '';
    ms_tx_list = prefs.getString("ms_tx_list") ?? "";
    // init tx
    // if (ms_tx_list.isEmpty) {
    //   String jsonTXString = await rootBundle.loadString("ms_tx_list".jsons());
    //   Map<String, dynamic> json_tx = jsonDecode(jsonTXString);
    //   prefs.setString('ms_tx_list',jsonTXString);
    //   txEntity = SJTXModel.fromJson(json_tx);
    // } else {
    //   String jsonTXString = prefs.getString('ms_tx_list') ?? "";
    //   Map<String, dynamic> json_tx = jsonDecode(jsonTXString);
    //   txEntity = SJTXModel.fromJson(json_tx);
    // }
    notifyListeners(); // 加载完成后通知UI更新
  }

  // 通用bool
  Future<void> updateBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    init();
    notifyListeners();
  }

  // 通用int
  Future<void> updateint(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    if (key == ms_Level_inedxName){
      if (value >= 5){
        value = 0;
        ms_Level_number += 1;
        await prefs.setInt(ms_Level_numberName, ms_Level_number);
        if (ms_Level_number >= 3){
          await prefs.setBool(ms_scratch_status_2Name, true);
        }
        if (ms_Level_number >= 4){
          await prefs.setBool(ms_scratch_status_3Name, true);
        }
        if (ms_Level_number >= 5){
          await prefs.setBool(ms_scratch_status_4Name, true);
        }
        if (ms_Level_number >= 6){
          await prefs.setBool(ms_scratch_status_5Name, true);
        }
        if (ms_Level_number >= 7){
          await prefs.setBool(ms_scratch_status_6Name, true);
        }
      }
    }
    if (key == ms_wheel_indexName){
      if (value >= 5){
        value = 0;
        ms_wheel_number += 1;
        await prefs.setInt(ms_wheel_numberName, ms_wheel_number);
      }
    }
    if (key == ms_wheel_numberName){
      if (value <= 0){
        value = 0;
      }
    }
    if (key == ms_domand_numberName && value > ms_domand_number) {
      playbgMUsic();
    }
    await prefs.setInt(key, value);
    init();
    notifyListeners();
  }



  Future<void> playbgMUsic() async {
    if (MSLocalProvider.instance.ms_bg_music) {
      await MSMP3Player().pauseBackground();
    }
    if (MSLocalProvider.instance.ms_sound_music){
      await MSMP3Player().playEffect5();
      Future.delayed(Duration(milliseconds: 1000), () async {
        await MSMP3Player().pauseEffect5();
        if (MSLocalProvider.instance.ms_bg_music){
          await MSMP3Player().playBackground();
        }
      });
    }
  }

  // 通用double
  Future<void> updatedouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    if (key == MSLocalProvider.instance.ms_dolas_numberName && ms_dolas_number <= 0){
      await updateBool(ms_first_show_cashName, true);
    }
    await prefs.setDouble(key, value);
    if (key == MSLocalProvider.instance.ms_dolas_numberName && value > 0){
      // trigger.check(MSLocalProvider.instance.ms_dolas_number.toInt(), onTrigger: (level) {
      //   print("触发 → 达到 $level");
      //   ms_event_fire('cash_dall', {'money' : level});
      // });
      await updateBool(ms_show_dolas_aniName, true);
    }
    init();
    notifyListeners();
  }

  // 通用String
  Future<void> updateString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    init();
    notifyListeners();
  }


  Future<void> updateTXInStatus(int status) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // txEntity.tx_info[ms_tx_ing_account].tx_list[ms_tx_ing_number].status = status;
    // sharedPreferences.setString('ms_tx_list', jsonEncode(txEntity.toJson()));
    // String jsonTXString = sharedPreferences.getString('ms_tx_list') ?? "";
    // Map<String, dynamic> json_tx = jsonDecode(jsonTXString);
    // txEntity = SJTXModel.fromJson(json_tx);
  }

}