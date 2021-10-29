// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'axelor_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AxelorListModel<T> _$AxelorListModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) {
  return AxelorListModel<T>(
    json['status'] as int?,
    json['offset'] as int?,
    json['total'] as int?,
    json['errors'] as Map<String, dynamic>?,
    (json['data'] as List<dynamic>?)?.map(fromJsonT).toList(),
  );
}

Map<String, dynamic> _$AxelorListModelToJson<T>(
  AxelorListModel<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'status': instance.status,
      'offset': instance.offset,
      'total': instance.total,
      'errors': instance.errors,
      'data': instance.data?.map(toJsonT).toList(),
    };
