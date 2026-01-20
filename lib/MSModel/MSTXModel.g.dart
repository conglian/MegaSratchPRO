// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MSTXModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MSTXModel _$MSTXModelFromJson(Map<String, dynamic> json) => MSTXModel()
  ..tx_info = (json['tx_info'] as List<dynamic>)
      .map((e) => MSTXListModel.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$MSTXModelToJson(MSTXModel instance) => <String, dynamic>{
  'tx_info': instance.tx_info,
};

MSTXListModel _$MSTXListModelFromJson(Map<String, dynamic> json) =>
    MSTXListModel()
      ..tx_list = (json['tx_list'] as List<dynamic>)
          .map((e) => MSTXListDetailModel.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$MSTXListModelToJson(MSTXListModel instance) =>
    <String, dynamic>{'tx_list': instance.tx_list};

MSTXListDetailModel _$MSTXListDetailModelFromJson(Map<String, dynamic> json) =>
    MSTXListDetailModel()
      ..number = (json['number'] as num).toInt()
      ..status = (json['status'] as num).toInt();

Map<String, dynamic> _$MSTXListDetailModelToJson(
  MSTXListDetailModel instance,
) => <String, dynamic>{'number': instance.number, 'status': instance.status};
