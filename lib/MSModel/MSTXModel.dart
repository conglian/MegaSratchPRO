import 'package:json_annotation/json_annotation.dart';

part 'MSTXModel.g.dart';

@JsonSerializable()
class MSTXModel {
  late List<MSTXListModel> tx_info = [];
  MSTXModel();

  // 工厂构造函数，用于反序列化
  factory MSTXModel.fromJson(Map<String, dynamic> json) => _$MSTXModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$MSTXModelToJson(this);
}

@JsonSerializable()
class MSTXListModel {
  late List<MSTXListDetailModel> tx_list = [];
  MSTXListModel();

  // 工厂构造函数，用于反序列化
  factory MSTXListModel.fromJson(Map<String, dynamic> json) => _$MSTXListModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$MSTXListModelToJson(this);
}

@JsonSerializable()
class MSTXListDetailModel {
  late int number = 0;
  late int status = 0;
  MSTXListDetailModel();

  // 工厂构造函数，用于反序列化
  factory MSTXListDetailModel.fromJson(Map<String, dynamic> json) => _$MSTXListDetailModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$MSTXListDetailModelToJson(this);
}