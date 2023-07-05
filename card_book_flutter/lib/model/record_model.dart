
import 'package:json_annotation/json_annotation.dart';

part 'record_model.g.dart';

@JsonSerializable()
class RecordModel {
  String id;
  String position;
  int count;
  String title;
  String type;
  List<String> colors;
  List<String> childList;

  RecordModel(this.id, this.position, this.count, this.title, this.type,
      this.childList, this.colors);

  // 這個facotry是必須要有的，為了從map創建一個新的User實例
  // 把整個map傳遞`_$UserFromJson()`
  factory RecordModel.fromJson(Map<String, dynamic> json) => _$RecordModelFromJson(json);

  // `toJson`是用來限制即將進行序列化到JSON
  Map<String, dynamic> toJson() => _$RecordModelToJson(this);
}