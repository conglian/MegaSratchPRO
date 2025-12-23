// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MSProbabilityModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MSReward _$MSRewardFromJson(Map<String, dynamic> json) => MSReward()
  ..Rule = (json['Rule'] as num).toInt()
  ..Probability = (json['Probability'] as num).toDouble()
  ..Coins = (json['Coins'] as num).toInt()
  ..Multiplier = (json['Multiplier'] as num).toInt();

Map<String, dynamic> _$MSRewardToJson(MSReward instance) => <String, dynamic>{
  'Rule': instance.Rule,
  'Probability': instance.Probability,
  'Coins': instance.Coins,
  'Multiplier': instance.Multiplier,
};

MSRewardData _$MSRewardDataFromJson(Map<String, dynamic> json) => MSRewardData()
  ..luckyNumbers = (json['luckyNumbers'] as List<dynamic>)
      .map((e) => MSReward.fromJson(e as Map<String, dynamic>))
      .toList()
  ..luckyDiamond = (json['luckyDiamond'] as List<dynamic>)
      .map((e) => MSReward.fromJson(e as Map<String, dynamic>))
      .toList()
  ..fruitPartyPay = (json['fruitPartyPay'] as List<dynamic>)
      .map((e) => MSReward.fromJson(e as Map<String, dynamic>))
      .toList()
  ..emojiFunReward = (json['emojiFunReward'] as List<dynamic>)
      .map((e) => MSReward.fromJson(e as Map<String, dynamic>))
      .toList()
  ..goldPotDig = (json['goldPotDig'] as List<dynamic>)
      .map((e) => MSReward.fromJson(e as Map<String, dynamic>))
      .toList()
  ..huntAndEarn = (json['huntAndEarn'] as List<dynamic>)
      .map((e) => MSReward.fromJson(e as Map<String, dynamic>))
      .toList()
  ..coinCraze = (json['coinCraze'] as List<dynamic>)
      .map((e) => MSReward.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$MSRewardDataToJson(MSRewardData instance) =>
    <String, dynamic>{
      'luckyNumbers': instance.luckyNumbers,
      'luckyDiamond': instance.luckyDiamond,
      'fruitPartyPay': instance.fruitPartyPay,
      'emojiFunReward': instance.emojiFunReward,
      'goldPotDig': instance.goldPotDig,
      'huntAndEarn': instance.huntAndEarn,
      'coinCraze': instance.coinCraze,
    };
