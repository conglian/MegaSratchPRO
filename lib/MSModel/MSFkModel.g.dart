// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MSFkModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MSFkModel _$MSFkModelFromJson(Map<String, dynamic> json) => MSFkModel()
  ..ui = MSUIModel.fromJson(json['ui'] as Map<String, dynamic>)
  ..behavior = MSbehaviorModel.fromJson(
    json['behavior'] as Map<String, dynamic>,
  )
  ..device = (json['device'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$MSFkModelToJson(MSFkModel instance) => <String, dynamic>{
  'ui': instance.ui,
  'behavior': instance.behavior,
  'device': instance.device,
};

MSUIModel _$MSUIModelFromJson(Map<String, dynamic> json) => MSUIModel()
  ..number = (json['number'] as num).toInt()
  ..behavior = (json['behavior'] as num).toInt()
  ..device = (json['device'] as num).toInt();

Map<String, dynamic> _$MSUIModelToJson(MSUIModel instance) => <String, dynamic>{
  'number': instance.number,
  'behavior': instance.behavior,
  'device': instance.device,
};

MSbehaviorModel _$MSbehaviorModelFromJson(Map<String, dynamic> json) =>
    MSbehaviorModel()
      ..ad_short_show = MSad_shortModel.fromJson(
        json['ad_short_show'] as Map<String, dynamic>,
      )
      ..ad_short_close = MSad_shortModel.fromJson(
        json['ad_short_close'] as Map<String, dynamic>,
      )
      ..wrong_deem_ad_less = (json['wrong_deem_ad_less'] as num).toInt()
      ..wrong_deem_ad_more = (json['wrong_deem_ad_more'] as num).toInt()
      ..no_install = (json['no_install'] as num).toInt()
      ..ad_daily_show = (json['ad_daily_show'] as num).toInt();

Map<String, dynamic> _$MSbehaviorModelToJson(MSbehaviorModel instance) =>
    <String, dynamic>{
      'ad_short_show': instance.ad_short_show,
      'ad_short_close': instance.ad_short_close,
      'wrong_deem_ad_less': instance.wrong_deem_ad_less,
      'wrong_deem_ad_more': instance.wrong_deem_ad_more,
      'no_install': instance.no_install,
      'ad_daily_show': instance.ad_daily_show,
    };

MSad_shortModel _$MSad_shortModelFromJson(Map<String, dynamic> json) =>
    MSad_shortModel()
      ..duration = (json['duration'] as num).toInt()
      ..value = (json['value'] as num).toInt();

Map<String, dynamic> _$MSad_shortModelToJson(MSad_shortModel instance) =>
    <String, dynamic>{'duration': instance.duration, 'value': instance.value};
