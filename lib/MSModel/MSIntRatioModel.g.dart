// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MSIntRatioModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MSResponseModel _$MSResponseModelFromJson(Map<String, dynamic> json) =>
    MSResponseModel(
      intad_point: (json['intad_point'] as List<dynamic>)
          .map((e) => MSIntadPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MSResponseModelToJson(MSResponseModel instance) =>
    <String, dynamic>{'intad_point': instance.intad_point};

MSIntadPoint _$MSIntadPointFromJson(Map<String, dynamic> json) => MSIntadPoint(
  first_number: (json['first_number'] as num).toInt(),
  point: (json['point'] as num).toInt(),
  end_number: (json['end_number'] as num).toInt(),
);

Map<String, dynamic> _$MSIntadPointToJson(MSIntadPoint instance) =>
    <String, dynamic>{
      'first_number': instance.first_number,
      'point': instance.point,
      'end_number': instance.end_number,
    };

GameRule _$GameRuleFromJson(Map<String, dynamic> json) => GameRule();

Map<String, dynamic> _$GameRuleToJson(GameRule instance) => <String, dynamic>{};

GameModel _$GameModelFromJson(Map<String, dynamic> json) => GameModel();

Map<String, dynamic> _$GameModelToJson(GameModel instance) =>
    <String, dynamic>{};
