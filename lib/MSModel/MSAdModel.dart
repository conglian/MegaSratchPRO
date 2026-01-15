import 'package:json_annotation/json_annotation.dart';

part 'MSAdModel.g.dart';

@JsonSerializable()
class MSAdModel {
  late int qtgokgqc = 0;
  late int kzsqaqju = 0;
  late bool pppuz_switch = false;
  late List<MSAdModellist> pppuz_int = [];
  late List<MSAdModellist> pppuz_rv = [];
  MSAdModel();

  // 工厂构造函数，用于反序列化
  factory MSAdModel.fromJson(Map<String, dynamic> json) => _$MSAdModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$MSAdModelToJson(this);
}

@JsonSerializable()
class MSAdModellist {
  // id
  late String myoljzuw = "";
  // type
  late String evdmqqij = "";
  // interstitial
  late String pcesfddy = "";
  //
  late int kgznnxwq = 0;
  //
  late double? ecpm = 0;

  MSAdModellist();

  // 工厂构造函数，用于反序列化
  factory MSAdModellist.fromJson(Map<String, dynamic> json) => _$MSAdModellistFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$MSAdModellistToJson(this);
}