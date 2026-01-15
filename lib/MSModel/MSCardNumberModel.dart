import 'package:json_annotation/json_annotation.dart';

part 'MSCardNumberModel.g.dart';  // 生成代码的文件名

@JsonSerializable()
class MSPrize {
  @JsonKey(name: 'first_number') // 映射 JSON 中的 key
  late int firstNumber = 0;

  @JsonKey(name: 'prize') // 映射 JSON 中的 key
  late List<int> prize = [];

  @JsonKey(name: 'end_number') // 映射 JSON 中的 key
  late int endNumber = 0;

  MSPrize();

  factory MSPrize.fromJson(Map<String, dynamic> json) => _$MSPrizeFromJson(json);
  Map<String, dynamic> toJson() => _$MSPrizeToJson(this);
}

@JsonSerializable()
class MSCard {
  late double point = 0;
  late List<MSPrize> prizes = [];

  MSCard();

  factory MSCard.fromJson(Map<String, dynamic> json) => _$MSCardFromJson(json);
  Map<String, dynamic> toJson() => _$MSCardToJson(this);
}

@JsonSerializable()
class MSLuckyNumber {
  @JsonKey(name: 'winup_number') // 映射 JSON 中的 key
  late int winupNumber = 0;

  @JsonKey(name: 'point') // 映射 JSON 中的 key
  late double point = 0;

  late List<MSPrize> prizes = [];

  MSLuckyNumber();

  factory MSLuckyNumber.fromJson(Map<String, dynamic> json) => _$MSLuckyNumberFromJson(json);
  Map<String, dynamic> toJson() => _$MSLuckyNumberToJson(this);
}

@JsonSerializable()
class MSCardDiamonds {
  @JsonKey(name: 'diamonds0') // 映射 JSON 中的 key
  late double diamonds0 = 0;

  @JsonKey(name: 'diamonds3') // 映射 JSON 中的 key
  late double diamonds3 = 0;

  @JsonKey(name: 'diamonds4') // 映射 JSON 中的 key
  late double diamonds4 = 0;

  @JsonKey(name: 'diamonds5') // 映射 JSON 中的 key
  late double diamonds5 = 0;

  @JsonKey(name: 'diamonds6') // 映射 JSON 中的 key
  late double diamonds6 = 0;

  @JsonKey(name: 'diamonds7') // 映射 JSON 中的 key
  late double diamonds7 = 0;

  @JsonKey(name: 'diamonds8') // 映射 JSON 中的 key
  late double diamonds8 = 0;

  late List<MSPrize> prizes = [];

  MSCardDiamonds();

  factory MSCardDiamonds.fromJson(Map<String, dynamic> json) => _$MSCardDiamondsFromJson(json);
  Map<String, dynamic> toJson() => _$MSCardDiamondsToJson(this);
}

@JsonSerializable()
class MSCardFruit {
  @JsonKey(name: 'point_face') // 映射 JSON 中的 key
  late double pointFace = 0.0;

  late List<MSPrize> prizes = [];

  MSCardFruit();

  factory MSCardFruit.fromJson(Map<String, dynamic> json) => _$MSCardFruitFromJson(json);
  Map<String, dynamic> toJson() => _$MSCardFruitToJson(this);
}

@JsonSerializable()
class MSCardEmoji {
  @JsonKey(name: 'winup_number') // 映射 JSON 中的 key
  late int winupNumber = 0;

  @JsonKey(name: 'point') // 映射 JSON 中的 key
  late double point = 0.0;

  late List<MSPrize> prizes = [];

  MSCardEmoji();

  factory MSCardEmoji.fromJson(Map<String, dynamic> json) => _$MSCardEmojiFromJson(json);
  Map<String, dynamic> toJson() => _$MSCardEmojiToJson(this);
}

@JsonSerializable()
class MSCardGoldPot {
  @JsonKey(name: 'winup_number') // 映射 JSON 中的 key
  late int winupNumber = 0;

  @JsonKey(name: 'point') // 映射 JSON 中的 key
  late double point = 0.0;

  late List<MSPrize> prizes = [];

  MSCardGoldPot();

  factory MSCardGoldPot.fromJson(Map<String, dynamic> json) => _$MSCardGoldPotFromJson(json);
  Map<String, dynamic> toJson() => _$MSCardGoldPotToJson(this);
}

@JsonSerializable()
class MSCard77earn {
  @JsonKey(name: 'point_nowin') // 映射 JSON 中的 key
  late double pointNowin = 0.0;

  @JsonKey(name: 'point_7') // 映射 JSON 中的 key
  late double point7 = 0.0;

  @JsonKey(name: 'point_77') // 映射 JSON 中的 key
  late double point77 = 0.0;

  @JsonKey(name: 'point_777') // 映射 JSON 中的 key
  late double point777 = 0.0;

  late List<MSPrize> prizes = [];

  MSCard77earn();

  factory MSCard77earn.fromJson(Map<String, dynamic> json) => _$MSCard77earnFromJson(json);
  Map<String, dynamic> toJson() => _$MSCard77earnToJson(this);
}

@JsonSerializable()
class MSLuckyCash {
  @JsonKey(name: 'winup_number') // 映射 JSON 中的 key
  late int winupNumber = 0;

  @JsonKey(name: 'point') // 映射 JSON 中的 key
  late double point = 0;

  late List<MSPrize> prizes = [];

  MSLuckyCash();

  factory MSLuckyCash.fromJson(Map<String, dynamic> json) => _$MSLuckyCashFromJson(json);
  Map<String, dynamic> toJson() => _$MSLuckyCashToJson(this);
}

@JsonSerializable()
class MSCardNumberModel {
  @JsonKey(name: 'lucky_number') // 映射 JSON 中的 key
  late MSLuckyNumber luckyNumber = MSLuckyNumber();

  @JsonKey(name: 'card_diamonds') // 映射 JSON 中的 key
  late MSCardDiamonds cardDiamonds = MSCardDiamonds();

  @JsonKey(name: 'card_fruit') // 映射 JSON 中的 key
  late MSCardFruit cardFruit = MSCardFruit();

  @JsonKey(name: 'card_emoji') // 映射 JSON 中的 key
  late MSCardEmoji cardEmoji = MSCardEmoji();

  @JsonKey(name: 'card_gold_pot') // 映射 JSON 中的 key
  late MSCardGoldPot cardGoldPot = MSCardGoldPot();

  @JsonKey(name: 'card_77earn') // 映射 JSON 中的 key
  late MSCard77earn card77earn = MSCard77earn();

  @JsonKey(name: 'lucky_cash') // 映射 JSON 中的 key
  late MSLuckyCash luckyCash = MSLuckyCash();

  MSCardNumberModel();

  factory MSCardNumberModel.fromJson(Map<String, dynamic> json) => _$MSCardNumberModelFromJson(json);
  Map<String, dynamic> toJson() => _$MSCardNumberModelToJson(this);
}
