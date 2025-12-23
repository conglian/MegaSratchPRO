import 'package:json_annotation/json_annotation.dart';
part 'MSProbabilityModel.g.dart';

// 定义一个 MSReward 类，代表每个奖励项
@JsonSerializable()
class MSReward {
  late int Rule = 0;  // 允许 rule 为 null
  late double Probability = 0.0;  // 允许为 null
  late int Coins = 100;  // 允许为 null
  late int Multiplier = 0;  // 允许为 null

  MSReward();

  factory MSReward.fromJson(Map<String, dynamic> json) => _$MSRewardFromJson(json);
  Map<String, dynamic> toJson() => _$MSRewardToJson(this);
}


// 为整个 MSRewardData 类创建一个模型
@JsonSerializable()
class MSRewardData {
  late List<MSReward> luckyNumbers = [];
  late List<MSReward> luckyDiamond = [];
  late List<MSReward> fruitPartyPay = [];
  late List<MSReward> emojiFunReward = [];
  late List<MSReward> goldPotDig = [];
  late List<MSReward> huntAndEarn = [];
  late List<MSReward> coinCraze = [];

  MSRewardData();

  factory MSRewardData.fromJson(Map<String, dynamic> json) =>
      _$MSRewardDataFromJson(json);

  Map<String, dynamic> toJson() => _$MSRewardDataToJson(this);


}
