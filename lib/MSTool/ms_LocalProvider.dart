import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:megascratch/MSDialog/MSDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../MSHome/MSTbabar.dart';
import '../MSModel/MSTXModel.dart';
import '../main.dart';
import 'ms_NoticeTool.dart';
import 'ms_TBAInfoTool.dart';
import 'ms_extension_help.dart';
import 'ms_mp3_player.dart';

class MSLocalProvider extends ChangeNotifier {
  // 1. 私有构造函数（禁止外部直接创建实例）
  MSLocalProvider._();

  // 2. 静态单例实例
  static final MSLocalProvider _instance = MSLocalProvider._();

  // 3. 提供全局访问点
  static MSLocalProvider get instance => _instance;

  MSTXModel txEntity = MSTXModel();

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
  String ms_tx_date_str = "";

  bool ms_frist_unAward_status = true;
  bool ms_frist_singn_status = true;
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
  bool ms_tx_wait_status = false;
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
  bool ms_new_guide1 = false;
  bool ms_new_guide2 = true;
  bool ms_double_card = false;
  bool ms_fruit_card = false;
  bool ms_777_card = false;
  bool ms_first_pool = false; // 存储的本地值
  bool ms_pool_show = true;
  bool ms_wheel_pop_show = false;
  bool ms_tx_zhongduan_status = false;
  bool ms_today_sign_status = false;
  bool ms_today_sign_show = false;
  bool ms_show_notice_status = false;
  bool ms_today_tx_toast_show = false;
  bool ms_show_animation_2 = false;
  bool ms_show_animation_3 = false;
  bool ms_show_animation_4 = false;
  bool ms_show_animation_5 = false;
  bool ms_show_animation_6 = false;
  bool ms_show_animation_7 = false;
  bool ms_tx_show_today_status = false;
  bool ms_tx_showtask_today_status = false;
  bool ms_first_session = false;

  int ms_scrach_unlock_index_0 = 0; // 存储的本地值
  int ms_scrach_unlock_index_1 = 0; // 存储的本地值
  int ms_ad_all_number = 0;
  double ms_dolas_number = 0.00;
  int ms_dolas_old_number = 0;
  int ms_ad_reawrd_all_number = 0;
  int ms_ad_short_show_number = 0;
  int ms_ad_short_close_number = 0;
  int ms_ad_show_index = 0;
  int ms_ad_show_number = 0;
  int ms_key_number = 0;
  int ms_tx_task_day_index = 0;
  int ms_account_seled_index = 0;
  int ms_tx_ing_account = 0;
  int ms_tx_ing_number = 0;
  int ms_tx_task_index = 0;
  int ms_current_user_ranking = 18250;
  int ms_current_ranking = 50;
  int ms_all_ranking = 100;
  int ms_rank_ad_count = 0;
  int ms_tx_card_index = 0;
  int ms_tx_wheel_index = 0;
  int ms_tx_bubble_index = 0;
  int ms_tx_box_index = 0;
  int ms_wheel_number = 0;
  int ms_wheel_index = 0;
  int ms_pool_index = 0;
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
  int ms_sign_index = 0;
  int ms_card_award_index = 0;
  int ms_dao_time_index = 300;
  int ms_wheel_pop_index = 0;
  int ms_today_card_index = 0;
  int ms_tx_num_index = 520;
  int ms_show_wheel_index_row = 0;
  int ms_unaward_index = 0;
  int ms_key_index = 0;
  int ms_key_pro_index = 0;
  int ms_key_all_index = 0;
  int ms_key_list_index = 0;
  int ms_pool_card_index = 0;
  int ms_rank_index = 0;
  int ms_pool_tx_index = 0;

  String get ms_currentNumberIndexName => 'ms_currentNumberIndex';
  String get ms_dice_numberName => 'ms_dice_number';
  String get ms_pool_card_indexName => 'ms_pool_card_index';
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
  String get ms_key_indexName => 'ms_key_index';
  String get ms_key_pro_indexName => 'ms_key_pro_index';
  String get ms_key_all_indexName => 'ms_key_all_index';
  String get ms_key_list_indexName => 'ms_key_list_index';
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
  String get ms_new_guide1Name => 'ms_new_guide1';
  String get ms_new_guide2Name => 'ms_new_guide2';
  String get ms_sign_indexName => 'ms_sign_index';
  String get ms_card_award_indexName => 'ms_card_award_index';
  String get ms_double_cardName => 'ms_double_card';
  String get ms_fruit_cardName => 'ms_fruit_card';
  String get ms_777_cardName => 'ms_777_card';
  String get ms_dao_time_indexName => 'ms_dao_time_index';
  String get ms_first_poolName => 'ms_first_pool';
  String get ms_pool_showName => 'ms_pool_show';
  String get ms_pool_indexName => 'ms_pool_index';
  String get ms_wheel_pop_indexName => 'ms_wheel_pop_index';
  String get ms_wheel_pop_showName => 'ms_wheel_pop_show';
  String get ms_today_card_indexName => 'ms_today_card_index';
  String get ms_tx_num_indexName => 'ms_tx_num_index';
  String get ms_current_user_rankingName => 'ms_current_user_ranking';
  String get ms_tx_date_strName => 'ms_tx_date_str';
  String get ms_tx_task_day_indexName => 'ms_tx_task_day_index';
  String get ms_tx_zhongduan_statusName => 'ms_tx_zhongduan_status';
  String get ms_today_sign_statusName => 'ms_today_sign_status';
  String get ms_today_sign_showName => 'ms_today_sign_show';
  String get ms_tx_wait_statusName => 'ms_tx_wait_status';
  String get ms_show_notice_statusName => 'ms_show_notice_status';
  String get ms_today_tx_toast_showName => 'ms_today_tx_toast_show';
  String get ms_frist_singn_statusName => 'ms_frist_singn_status';
  String get ms_frist_unAward_statusName => 'ms_frist_unAward_status';
  String get ms_show_wheel_index_rowName => 'ms_show_wheel_index_row';
  String get ms_unaward_indexName => 'ms_unaward_index';
  String get ms_show_animation_2Name => 'ms_show_animation_2';
  String get ms_show_animation_3Name => 'ms_show_animation_3';
  String get ms_show_animation_4Name => 'ms_show_animation_4';
  String get ms_show_animation_5Name => 'ms_show_animation_5';
  String get ms_show_animation_6Name => 'ms_show_animation_6';
  String get ms_show_animation_7Name => 'ms_show_animation_7';
  String get ms_tx_show_today_statusName => 'ms_tx_show_today_status';
  String get ms_tx_showtask_today_statusName => 'ms_tx_showtask_today_status';
  String get ms_rank_indexName => 'ms_rank_index';
  String get ms_pool_tx_indexName => 'ms_pool_tx_index';
  String get ms_first_sessionName => 'ms_first_session';


  // 3. 初始化：从本地存储加载数据（组件初始化时调用）
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    // 从本地读取值（key自定义，需与存储时一致）
    ms_dao_time_index = prefs.getInt('ms_dao_time_index') ?? 300;
    ms_card_award_index = prefs.getInt('ms_card_award_index') ?? 0;
    ms_show_wheel_index_row = prefs.getInt('ms_show_wheel_index_row') ?? 0;
    ms_today_card_index = prefs.getInt('ms_today_card_index') ?? 0;
    ms_wheel_index = prefs.getInt('ms_wheel_index') ?? 0;
    ms_pool_index = prefs.getInt('ms_pool_index') ?? 0;
    ms_tx_task_day_index = prefs.getInt('ms_tx_task_day_index') ?? 0;
    ms_wheel_pop_index = prefs.getInt('ms_wheel_pop_index') ?? 0;
    ms_tx_probability_index = prefs.getInt('ms_tx_probability_index') ?? 0;
    ms_login_index = prefs.getInt('ms_login_index') ?? 1;
    ms_tx_num_index = prefs.getInt('ms_tx_num_index') ?? 520;
    ms_tx_dice_index = prefs.getInt('ms_tx_dice_index') ?? 0;
    ms_tx_card_first = prefs.getInt('ms_tx_card_first') ?? 0;
    ms_domand_number = prefs.getInt('ms_domand_number') ?? 0;
    ms_dice_number = prefs.getInt('ms_dice_number') ?? 0;
    ms_card_number = prefs.getInt('ms_card_number') ?? 0;
    ms_rank_index = prefs.getInt('ms_rank_index') ?? 0;
    ms_pool_tx_index = prefs.getInt('ms_pool_tx_index') ?? 0;
    ms_current_user_ranking = prefs.getInt('ms_current_user_ranking') ?? 18250;
    ms_box_index = prefs.getInt('ms_box_index') ?? 0;
    ms_pool_card_index = prefs.getInt('ms_pool_card_index') ?? 0;
    ms_unaward_index =  prefs.getInt('ms_unaward_index') ?? 0;
    ms_tx_box_index = prefs.getInt('ms_tx_box_index') ?? 0;
    ms_wheel_number = prefs.getInt('ms_wheel_number') ?? 0;
    ms_tx_card_index = prefs.getInt('ms_tx_card_index') ?? 0;
    ms_tx_wheel_index = prefs.getInt('ms_tx_wheel_index') ?? 0;
    ms_tx_bubble_index = prefs.getInt('ms_tx_bubble_index') ?? 0;
    ms_current_ranking = prefs.getInt('ms_current_ranking') ?? 50;
    ms_all_ranking = prefs.getInt('ms_all_ranking') ?? 100;
    ms_rank_ad_count = prefs.getInt('ms_rank_ad_count') ?? 0;
    ms_tx_task_index = prefs.getInt('ms_tx_task_index') ?? 0;
    ms_tx_ing_account = prefs.getInt('ms_tx_ing_account') ?? 0;
    ms_tx_ing_number = prefs.getInt('ms_tx_ing_number') ?? 0;
    ms_key_index = prefs.getInt('ms_key_index') ?? 0;
    ms_key_pro_index = prefs.getInt('ms_key_pro_index') ?? 0;
    ms_key_all_index = prefs.getInt('ms_key_all_index') ?? 0;
    ms_key_list_index = prefs.getInt('ms_key_list_index') ?? 0;
    ms_scratch_not_award_number = prefs.getInt('ms_scratch_not_award_number') ?? 0;
    ms_account_seled_index = prefs.getInt('ms_account_seled_index') ?? 0;
    ms_scrach_unlock_index_0 = prefs.getInt('ms_scrach_unlock_index_0') ?? 0;
    ms_scrach_unlock_index_1 = prefs.getInt('ms_scrach_unlock_index_1') ?? 0;
    ms_ad_short_show_number = prefs.getInt('ms_ad_short_show_number') ?? 0;
    ms_ad_short_close_number = prefs.getInt('ms_ad_short_close_number') ?? 0;
    ms_ad_show_number = prefs.getInt('ms_ad_show_number') ?? 0;
    ms_key_number = prefs.getInt('ms_key_number') ?? 0;
    ms_bg_music = prefs.getBool('ms_bg_music') ?? true;
    ms_frist_unAward_status = prefs.getBool('ms_frist_unAward_status') ?? true;
    ms_sound_music = prefs.getBool('ms_sound_music') ?? true;
    ms_txing_status = prefs.getBool('ms_txing_status') ?? false;
    ms_login_status = prefs.getBool('ms_login_status') ?? false;
    ms_today_sign_show = prefs.getBool('ms_today_sign_show') ?? false;
    ms_double_card = prefs.getBool('ms_double_card') ?? false;
    ms_fruit_card = prefs.getBool('ms_fruit_card') ?? false;
    ms_tx_wait_status = prefs.getBool('ms_tx_wait_status') ?? false;
    ms_wheel_pop_show = prefs.getBool('ms_wheel_pop_show') ?? false;
    ms_777_card = prefs.getBool('ms_777_card') ?? false;
    ms_first_session = prefs.getBool('ms_first_session') ?? false;
    ms_today_tx_toast_show = prefs.getBool('ms_today_tx_toast_show') ?? false;
    ms_show_notice_status = prefs.getBool('ms_show_notice_status') ?? false;
    ms_today_sign_status = prefs.getBool('ms_today_sign_status') ?? false;
    ms_tx_zhongduan_status = prefs.getBool('ms_tx_zhongduan_status') ?? false;
    ms_open_tx = prefs.getBool('ms_open_tx') ?? false;
    ms_tx_show_today_status = prefs.getBool('ms_tx_show_today_status') ?? false;
    ms_tx_showtask_today_status = prefs.getBool('ms_tx_showtask_today_status') ?? false;
    ms_show_box = prefs.getBool('ms_show_box') ?? false;
    ms_pool_show = prefs.getBool('ms_pool_show') ?? true;
    ms_first_pool = prefs.getBool('ms_first_pool') ?? false;
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
    ms_new_guide1 = prefs.getBool('ms_new_guide1') ?? false;
    ms_new_guide2 = prefs.getBool('ms_new_guide2') ?? true;
    ms_frist_singn_status = prefs.getBool('ms_frist_singn_status') ?? true;
    ms_ad_reawrd_all_number = prefs.getInt('ms_ad_reawrd_all_number') ?? 0;
    ms_ad_all_number = prefs.getInt('ms_ad_all_number') ?? 0;
    ms_dolas_number = prefs.getDouble('ms_dolas_number') ?? 0.00;
    ms_dolas_old_number = prefs.getInt('ms_dolas_old_number') ?? 0;
    ms_ad_show_index = prefs.getInt('ms_ad_show_index') ?? 0;
    ms_Level_number = prefs.getInt('ms_Level_number') ?? 0;
    ms_Level_inedx = prefs.getInt('ms_Level_inedx') ?? 0;
    ms_sign_index = prefs.getInt('ms_sign_index') ?? 0;
    ms_show_animation_2 = prefs.getBool('ms_show_animation_2') ?? false;
    ms_show_animation_3 = prefs.getBool('ms_show_animation_3') ?? false;
    ms_show_animation_4 = prefs.getBool('ms_show_animation_4') ?? false;
    ms_show_animation_5 = prefs.getBool('ms_show_animation_5') ?? false;
    ms_show_animation_6 = prefs.getBool('ms_show_animation_6') ?? false;
    ms_show_animation_7 = prefs.getBool('ms_show_animation_7') ?? false;
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
    ms_tx_date_str = prefs.getString('ms_tx_date_str') ?? '';
    ms_ratio_str = prefs.getString('ms_ratio_str') ?? '90';
    ms_account_id = prefs.getString('ms_account_id') ?? '';
    ms_tx_list = prefs.getString("ms_tx_list") ?? "";
    // init tx
    if (ms_tx_list.isEmpty) {
      String jsonTXString = await rootBundle.loadString("ms_tx_list".jsons());
      Map<String, dynamic> json_tx = jsonDecode(jsonTXString);
      prefs.setString('ms_tx_list',jsonTXString);
      txEntity = MSTXModel.fromJson(json_tx);
    } else {
      String jsonTXString = prefs.getString('ms_tx_list') ?? "";
      Map<String, dynamic> json_tx = jsonDecode(jsonTXString);
      txEntity = MSTXModel.fromJson(json_tx);
    }
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
    // if (key == ms_key_indexName){
    //   if (value >= 5){
    //     value = 0;
    //     ms_wheel_number += 1;
    //     await prefs.setInt(ms_key_indexName, 0);
    //     await prefs.setInt(ms_wheel_numberName, ms_wheel_number);
    //   }
    // }
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
    if (MSLocalProvider.instance.ms_sound_music){
      await MSAudioUtils().playDolasAudio();
      Future.delayed(Duration(milliseconds: 1000), () async {
        await MSAudioUtils().stopAllTempAudio();
      });
    }
  }

  // 通用double
  Future<void> updatedouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    if (key == MSLocalProvider.instance.ms_dolas_numberName && ms_dolas_number <= 0){
      await updateBool(ms_first_show_cashName, true);
    }
    if (key == ms_dolas_numberName && value > ms_dolas_number) {
      playbgMUsic();
      await updateBool(ms_show_dolas_aniName, true);
      if (value >= 1000){
         showTxDialog();
      }
    }
    await prefs.setDouble(key, value);
    MSNoticeHelp().startForegroundService();
    if (key == MSLocalProvider.instance.ms_dolas_numberName && value > 0){
      trigger.check(MSLocalProvider.instance.ms_dolas_number.toInt(), onTrigger: (level) {
        print("触发 → 达到 $level");
        ms_event_fire('cash_money_detail', {'money' : level});
      });
    }
    init();
    notifyListeners();
  }

  Future<void> showTxDialog() async {
    if (MSLocalProvider.instance.ms_tx_first_status == false) {
      await MSLocalProvider.instance.updateBool(MSLocalProvider.instance.ms_tx_first_statusName, true);
      root_navigatorKey.currentState?.context.tipShow(MSTXSubmitDialog(tx_number_index: 0, tx_account_index: 0));
    }
  }

  // 通用String
  Future<void> updateString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    init();
    notifyListeners();
  }


  Future<void> updateTXInStatus(int status) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    txEntity.tx_info[ms_tx_ing_account].tx_list[ms_tx_ing_number].status = status;
    sharedPreferences.setString('ms_tx_list', jsonEncode(txEntity.toJson()));
    String jsonTXString = sharedPreferences.getString('ms_tx_list') ?? "";
    Map<String, dynamic> json_tx = jsonDecode(jsonTXString);
    txEntity = MSTXModel.fromJson(json_tx);
  }

}