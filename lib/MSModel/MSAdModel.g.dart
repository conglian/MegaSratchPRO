// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MSAdModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MSAdModel _$MSAdModelFromJson(Map<String, dynamic> json) => MSAdModel()
  ..qtgokgqc = (json['qtgokgqc'] as num).toInt()
  ..kzsqaqju = (json['kzsqaqju'] as num).toInt()
  ..pppuz_switch = json['pppuz_switch'] as bool
  ..pppuz_int = (json['pppuz_int'] as List<dynamic>)
      .map((e) => MSAdModellist.fromJson(e as Map<String, dynamic>))
      .toList()
  ..pppuz_rv = (json['pppuz_rv'] as List<dynamic>)
      .map((e) => MSAdModellist.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$MSAdModelToJson(MSAdModel instance) => <String, dynamic>{
  'qtgokgqc': instance.qtgokgqc,
  'kzsqaqju': instance.kzsqaqju,
  'pppuz_switch': instance.pppuz_switch,
  'pppuz_int': instance.pppuz_int,
  'pppuz_rv': instance.pppuz_rv,
};

MSAdModellist _$MSAdModellistFromJson(Map<String, dynamic> json) =>
    MSAdModellist()
      ..myoljzuw = json['myoljzuw'] as String
      ..evdmqqij = json['evdmqqij'] as String
      ..pcesfddy = json['pcesfddy'] as String
      ..kgznnxwq = (json['kgznnxwq'] as num).toInt()
      ..ecpm = (json['ecpm'] as num?)?.toDouble();

Map<String, dynamic> _$MSAdModellistToJson(MSAdModellist instance) =>
    <String, dynamic>{
      'myoljzuw': instance.myoljzuw,
      'evdmqqij': instance.evdmqqij,
      'pcesfddy': instance.pcesfddy,
      'kgznnxwq': instance.kgznnxwq,
      'ecpm': instance.ecpm,
    };
