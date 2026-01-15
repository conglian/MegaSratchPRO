import 'package:json_annotation/json_annotation.dart';

part 'MSFkModel.g.dart';

@JsonSerializable()
class MSFkModel {
  late MSUIModel ui = MSUIModel();
  late MSbehaviorModel behavior = MSbehaviorModel();
  late List<String> device = [];
  MSFkModel();

  // 工厂构造函数，用于反序列化
  factory MSFkModel.fromJson(Map<String, dynamic> json) => _$MSFkModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$MSFkModelToJson(this);
}

@JsonSerializable()
class MSUIModel {
  late int number = 0;
  late int behavior = 0;
  late int device = 0;
  MSUIModel();

  // 工厂构造函数，用于反序列化
  factory MSUIModel.fromJson(Map<String, dynamic> json) => _$MSUIModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$MSUIModelToJson(this);
}

@JsonSerializable()
class MSbehaviorModel {
  late MSad_shortModel ad_short_show = MSad_shortModel();
  late MSad_shortModel ad_short_close = MSad_shortModel();
  late int wrong_deem_ad_less = 0;
  late int wrong_deem_ad_more = 0;
  late int no_install = 0;
  late int ad_daily_show = 0;
  MSbehaviorModel();

  // 工厂构造函数，用于反序列化
  factory MSbehaviorModel.fromJson(Map<String, dynamic> json) => _$MSbehaviorModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$MSbehaviorModelToJson(this);
}

@JsonSerializable()
class MSad_shortModel {
  late int duration = 0;
  late int value = 0;

  MSad_shortModel();

  // 工厂构造函数，用于反序列化
  factory MSad_shortModel.fromJson(Map<String, dynamic> json) => _$MSad_shortModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$MSad_shortModelToJson(this);
}