import 'package:json_annotation/json_annotation.dart';

part 'MSIntRatioModel.g.dart';


@JsonSerializable()
class MSResponseModel {
  @JsonKey(name: 'intad_point')
  final List<MSIntadPoint> MSIntadPoints = [];

  MSResponseModel();

  factory MSResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MSResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MSResponseModelToJson(this);
}

@JsonSerializable()
class MSIntadPoint {
  @JsonKey(name: 'first_number')
  final int MSFirstNumber = 0;

  @JsonKey(name: 'point')
  final int MSPoint = 0;

  @JsonKey(name: 'end_number')
  final int MSEndNumber = 0;

  MSIntadPoint();

  // 生成的工厂方法
  factory MSIntadPoint.fromJson(Map<String, dynamic> json) =>
      _$MSIntadPointFromJson(json);

  // 生成的toJson方法
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