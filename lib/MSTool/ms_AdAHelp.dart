import 'dart:developer';
import 'dart:math';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/cupertino.dart';
import '../MSDialog/MSDialog.dart';
import '../MSModel/MSIntRatioModel.dart';
import 'ms_LocalProvider.dart';
import 'ms_mp3_player.dart';
import 'ms_extension_help.dart';

class MSAdAHelper {
  static final MSAdAHelper _instance = MSAdAHelper._internal();

  factory MSAdAHelper() {
    return _instance;
  }

  MSAdAHelper._internal();

  String rewardOne = '8f23eb275cf29c63';

  String intOne = 'd41956184a82b910';

  String? placeId;

  void Function(bool)? finishIntAd;

  void resetBlock() {
    finishIntAd = null;
  }

  bool getIntShow(){
    if (MSLocalProvider.instance.ms_domand_number < 1000){
      return false;
    } else {
      bool result = getRandomBool(0.8);
      return result;
    }
  }

  bool getRandomBool(double probability) {
    // 创建一个随机数生成器
    final random = Random();

    // 生成一个0到1之间的随机数
    double randomValue = random.nextDouble();

    // 判断随机数是否小于等于给定的概率
    return randomValue <= probability;
  }

  void load() {
    if (rewardOne.length == 0) {
      "megascratchad Reward no data".log();
      return;
    }

    AppLovinMAX.setRewardedAdListener(
      RewardedAdListener(
        onAdLoadedCallback: (ad) {
          _saveCurrentAds(ad.adUnitId);
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          _reLoadad(adUnitId, error.message);
        },
        onAdDisplayedCallback: (ad) async {
          if (MSLocalProvider.instance.ms_bg_music) {
            MSAudioUtils().pauseBGM();
          }
          "megascratchad Reward did display ${ad.adUnitId}".log();
        },
        onAdDisplayFailedCallback: (ad, error) {
          "megascratchad Reward did faild to display ${error.message}".log();
          if (this.finishIntAd != null) {
            this.finishIntAd!(false);
          }
          load();
        },
        onAdClickedCallback: (ad) {
          "megascratchad Reward did click ${ad.adUnitId}".log();
        },
        onAdHiddenCallback: (ad) {
          if (MSLocalProvider.instance.ms_bg_music) {
            MSAudioUtils().playBGM();
          }
          "megascratchad Reward did hide - ${ad.adUnitId}".log();
          if (this.finishIntAd != null) {
            this.finishIntAd!(true);
          }
          load();
        },
        onAdRevenuePaidCallback: (ad) {
          "megascratchad Reward did pay ${ad.revenue} - ${ad.adUnitId}".log();
          "megascratchad Int did pay finally ${ad.revenue} - ${ad.adUnitId}".log();
        },
        onAdReceivedRewardCallback: (MaxAd ad, MaxReward reward) {},
      ),
    );
    
    AppLovinMAX.setInterstitialListener(
        InterstitialListener(
          onAdLoadedCallback: (ad) {
            // 请求成功
            "megascratchad ad Int Load Success ${ad.adUnitId} revenue=${ad.revenue}".log();
          },
          onAdLoadFailedCallback: (adUnitId, error) {
            "megascratchad ad Int Load Failed ${adUnitId} error=${error}".log();
            // 请求失败
            load();
          },
          onAdDisplayedCallback: (ad) async {
            if (MSLocalProvider.instance.ms_bg_music) {
              MSAudioUtils().pauseBGM();
            }
            "megascratchad ad int show Success ${ad.adUnitId} revenue=${ad.revenue}".log();
          },
          onAdDisplayFailedCallback: (ad, error) {
            // 显示失败
            "megascratchad ad int show faild to display ${error.message}".log();
            if (finishIntAd != null) {
              finishIntAd!(false);
            }
            load();
          },
          onAdClickedCallback: (ad) {
            // 点击
            "megascratchad ad Int did click ${ad.adUnitId}".log();
          },
          onAdHiddenCallback: (ad) {
            if (MSLocalProvider.instance.ms_bg_music) {
              MSAudioUtils().playBGM();
            }
            if (this.finishIntAd != null) {
              this.finishIntAd!(true);
            }
            // 消失
            "megascratchad ad Int Hidden ${ad.adUnitId}".log();
            // 补充广告
            load();

          },
          onAdRevenuePaidCallback: (ad) {
          },
        )
    );

    if (rewardOne.length != 0) {
      "megascratchad Reward Start Load Root ${rewardOne}"
          .log();
      AppLovinMAX.loadRewardedAd(rewardOne);
    }

    if (intOne.length != 0) {
      "megascratchad int Start Load Root ${intOne}"
          .log();
      AppLovinMAX.loadInterstitial(intOne);
    }
  }

  void _reLoadad(String identifer, String message) {
    load();
  }

  void _saveCurrentAds(String identifer) {

  }

  Future<void> show(BuildContext content, void Function(bool) hasCache,
      void Function(bool)? finished) async {
    if (finished != null) {
      finishIntAd = finished;
    }

    bool isReady = (await AppLovinMAX.isRewardedAdReady(rewardOne))!;


    if (isReady) {
      AppLovinMAX.showRewardedAd(rewardOne);
      "megascratchad Reward request to show pos_id: success root ${rewardOne}"
          .log();
      hasCache(true);
      return;
    }

    "megascratchad Reward request to show no cache!}".log();
    MSDialogTool.toast(content, 'Ad loading failed, please try again later~');
    load();
    hasCache(false);
  }

  Future<void> show_int(BuildContext content, void Function(bool) hasCache,
      void Function(bool)? finished) async {
    if (finished != null) {
      finishIntAd = finished;
    }

    bool isReady = (await AppLovinMAX.isInterstitialReady(intOne))!;


    if (isReady) {
      AppLovinMAX.showInterstitial(intOne);
      "megascratchad int request to show pos_id: success root ${intOne}"
          .log();
      hasCache(true);
      return;
    }

    "megascratchad int request to show no cache!}".log();
    MSDialogTool.toast(content, 'Ad loading failed, please try again later~');
    load();
    hasCache(false);
  }

}

extension AdRewardHelperExtension on MSAdAHelper {
  initRewardAdDatasource() {
    load();
  }
}