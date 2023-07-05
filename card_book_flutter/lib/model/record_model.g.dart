// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordModel _$RecordModelFromJson(Map<String, dynamic> json) => RecordModel(
      json['id'] as String,
      json['position'] as String,
      json['count'] as int,
      json['title'] as String,
      json['type'] as String,
      (json['childList'] as List<dynamic>).map((e) => e as String).toList(),
      (json['colors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$RecordModelToJson(RecordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': instance.position,
      'count': instance.count,
      'title': instance.title,
      'type': instance.type,
      'colors': instance.colors,
      'childList': instance.childList,
    };
