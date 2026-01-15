// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MSIntRatioModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MSResponseModel _$MSResponseModelFromJson(Map<String, dynamic> json) =>
    MSResponseModel(
      MSIntadPoints: (json['intad_point'] as List<dynamic>)
          .map((e) => MSIntadPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MSResponseModelToJson(MSResponseModel instance) =>
    <String, dynamic>{'intad_point': instance.MSIntadPoints};

MSIntadPoint _$MSIntadPointFromJson(Map<String, dynamic> json) => MSIntadPoint(
  MSFirstNumber: (json['first_number'] as num).toInt(),
  MSPoint: (json['point'] as num).toInt(),
  MSEndNumber: (json['end_number'] as num).toInt(),
);

Map<String, dynamic> _$MSIntadPointToJson(MSIntadPoint instance) =>
    <String, dynamic>{
      'first_number': instance.MSFirstNumber,
      'point': instance.MSPoint,
      'end_number': instance.MSEndNumber,
    };

GameRule _$GameRuleFromJson(Map<String, dynamic> json) => GameRule();

Map<String, dynamic> _$GameRuleToJson(GameRule instance) => <String, dynamic>{};

GameModel _$GameModelFromJson(Map<String, dynamic> json) => GameModel();

Map<String, dynamic> _$GameModelToJson(GameModel instance) =>
    <String, dynamic>{};
