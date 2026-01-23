import 'package:json_annotation/json_annotation.dart';

part 'MSIntRatioModel.g.dart';



@JsonSerializable()
class MSResponseModel {
  final List<MSIntadPoint> intad_point;

  MSResponseModel({required this.intad_point});

  factory MSResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MSResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MSResponseModelToJson(this);
}

@JsonSerializable()
class MSIntadPoint {
  final int first_number;
  final int point;
  final int end_number;

  MSIntadPoint({
    required this.first_number,
    required this.point,
    required this.end_number,
  });

  factory MSIntadPoint.fromJson(Map<String, dynamic> json) =>
      _$MSIntadPointFromJson(json);

  Map<String, dynamic> toJson() => _$MSIntadPointToJson(this);
}

// 模型类表示一个规则
@JsonSerializable()
class GameRule {
  final String rule = '';
  final double probability = 0.0;
  final List<int> balance = [];
  final List<int> bonus = [];
  final int multiplier = 0;

  GameRule();

  factory GameRule.fromJson(Map<String, dynamic> json) => _$GameRuleFromJson(json);
  Map<String, dynamic> toJson() => _$GameRuleToJson(this);
}

// 每种游戏的模型类
@JsonSerializable()
class GameModel {
  final List<GameRule> luckyNumbersWin = [];
  final List<GameRule> luckyDiamondsCash = [];
  final List<GameRule> fruitPartyPay = [];
  final List<GameRule> emojiFunRewards = [];
  final List<GameRule> goldPotDig = [];
  final List<GameRule> huntAndEarn = [];
  final List<GameRule> cashCraze = [];

  GameModel();

  factory GameModel.fromJson(Map<String, dynamic> json) => _$GameModelFromJson(json);
  Map<String, dynamic> toJson() => _$GameModelToJson(this);
}