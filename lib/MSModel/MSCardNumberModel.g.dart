// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MSCardNumberModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MSPrize _$MSPrizeFromJson(Map<String, dynamic> json) => MSPrize()
  ..firstNumber = (json['first_number'] as num).toInt()
  ..prize = (json['prize'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList()
  ..endNumber = (json['end_number'] as num).toInt();

Map<String, dynamic> _$MSPrizeToJson(MSPrize instance) => <String, dynamic>{
  'first_number': instance.firstNumber,
  'prize': instance.prize,
  'end_number': instance.endNumber,
};

MSCard _$MSCardFromJson(Map<String, dynamic> json) => MSCard()
  ..point = (json['point'] as num).toDouble()
  ..prizes = (json['prizes'] as List<dynamic>)
      .map((e) => MSPrize.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$MSCardToJson(MSCard instance) => <String, dynamic>{
  'point': instance.point,
  'prizes': instance.prizes,
};

MSLuckyNumber _$MSLuckyNumberFromJson(Map<String, dynamic> json) =>
    MSLuckyNumber()
      ..winupNumber = (json['winup_number'] as num).toInt()
      ..point = (json['point'] as num).toDouble()
      ..prizes = (json['prizes'] as List<dynamic>)
          .map((e) => MSPrize.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$MSLuckyNumberToJson(MSLuckyNumber instance) =>
    <String, dynamic>{
      'winup_number': instance.winupNumber,
      'point': instance.point,
      'prizes': instance.prizes,
    };

MSCardDiamonds _$MSCardDiamondsFromJson(Map<String, dynamic> json) =>
    MSCardDiamonds()
      ..diamonds0 = (json['diamonds0'] as num).toDouble()
      ..diamonds3 = (json['diamonds3'] as num).toDouble()
      ..diamonds4 = (json['diamonds4'] as num).toDouble()
      ..diamonds5 = (json['diamonds5'] as num).toDouble()
      ..diamonds6 = (json['diamonds6'] as num).toDouble()
      ..diamonds7 = (json['diamonds7'] as num).toDouble()
      ..diamonds8 = (json['diamonds8'] as num).toDouble()
      ..prizes = (json['prizes'] as List<dynamic>)
          .map((e) => MSPrize.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$MSCardDiamondsToJson(MSCardDiamonds instance) =>
    <String, dynamic>{
      'diamonds0': instance.diamonds0,
      'diamonds3': instance.diamonds3,
      'diamonds4': instance.diamonds4,
      'diamonds5': instance.diamonds5,
      'diamonds6': instance.diamonds6,
      'diamonds7': instance.diamonds7,
      'diamonds8': instance.diamonds8,
      'prizes': instance.prizes,
    };

MSCardFruit _$MSCardFruitFromJson(Map<String, dynamic> json) => MSCardFruit()
  ..pointFace = (json['point_face'] as num).toDouble()
  ..prizes = (json['prizes'] as List<dynamic>)
      .map((e) => MSPrize.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$MSCardFruitToJson(MSCardFruit instance) =>
    <String, dynamic>{
      'point_face': instance.pointFace,
      'prizes': instance.prizes,
    };

MSCardEmoji _$MSCardEmojiFromJson(Map<String, dynamic> json) => MSCardEmoji()
  ..winupNumber = (json['winup_number'] as num).toInt()
  ..point = (json['point'] as num).toDouble()
  ..prizes = (json['prizes'] as List<dynamic>)
      .map((e) => MSPrize.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$MSCardEmojiToJson(MSCardEmoji instance) =>
    <String, dynamic>{
      'winup_number': instance.winupNumber,
      'point': instance.point,
      'prizes': instance.prizes,
    };

MSCardGoldPot _$MSCardGoldPotFromJson(Map<String, dynamic> json) =>
    MSCardGoldPot()
      ..winupNumber = (json['winup_number'] as num).toInt()
      ..point = (json['point'] as num).toDouble()
      ..prizes = (json['prizes'] as List<dynamic>)
          .map((e) => MSPrize.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$MSCardGoldPotToJson(MSCardGoldPot instance) =>
    <String, dynamic>{
      'winup_number': instance.winupNumber,
      'point': instance.point,
      'prizes': instance.prizes,
    };

MSCard77earn _$MSCard77earnFromJson(Map<String, dynamic> json) => MSCard77earn()
  ..pointNowin = (json['point_nowin'] as num).toDouble()
  ..point7 = (json['point_7'] as num).toDouble()
  ..point77 = (json['point_77'] as num).toDouble()
  ..point777 = (json['point_777'] as num).toDouble()
  ..prizes = (json['prizes'] as List<dynamic>)
      .map((e) => MSPrize.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$MSCard77earnToJson(MSCard77earn instance) =>
    <String, dynamic>{
      'point_nowin': instance.pointNowin,
      'point_7': instance.point7,
      'point_77': instance.point77,
      'point_777': instance.point777,
      'prizes': instance.prizes,
    };

MSLuckyCash _$MSLuckyCashFromJson(Map<String, dynamic> json) => MSLuckyCash()
  ..winupNumber = (json['winup_number'] as num).toInt()
  ..point = (json['point'] as num).toDouble()
  ..prizes = (json['prizes'] as List<dynamic>)
      .map((e) => MSPrize.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$MSLuckyCashToJson(MSLuckyCash instance) =>
    <String, dynamic>{
      'winup_number': instance.winupNumber,
      'point': instance.point,
      'prizes': instance.prizes,
    };

MSCardNumberModel _$MSCardNumberModelFromJson(
  Map<String, dynamic> json,
) => MSCardNumberModel()
  ..luckyNumber = MSLuckyNumber.fromJson(
    json['lucky_number'] as Map<String, dynamic>,
  )
  ..cardDiamonds = MSCardDiamonds.fromJson(
    json['card_diamonds'] as Map<String, dynamic>,
  )
  ..cardFruit = MSCardFruit.fromJson(json['card_fruit'] as Map<String, dynamic>)
  ..cardEmoji = MSCardEmoji.fromJson(json['card_emoji'] as Map<String, dynamic>)
  ..cardGoldPot = MSCardGoldPot.fromJson(
    json['card_gold_pot'] as Map<String, dynamic>,
  )
  ..card77earn = MSCard77earn.fromJson(
    json['card_77earn'] as Map<String, dynamic>,
  )
  ..luckyCash = MSLuckyCash.fromJson(
    json['lucky_cash'] as Map<String, dynamic>,
  );

Map<String, dynamic> _$MSCardNumberModelToJson(MSCardNumberModel instance) =>
    <String, dynamic>{
      'lucky_number': instance.luckyNumber,
      'card_diamonds': instance.cardDiamonds,
      'card_fruit': instance.cardFruit,
      'card_emoji': instance.cardEmoji,
      'card_gold_pot': instance.cardGoldPot,
      'card_77earn': instance.card77earn,
      'lucky_cash': instance.luckyCash,
    };
