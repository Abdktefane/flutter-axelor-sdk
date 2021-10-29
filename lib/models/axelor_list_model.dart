import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_axelor_sdk/flutter_axelor_sdk.dart';
import 'package:flutter_axelor_sdk/utils/axelor_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'axelor_list_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class AxelorListModel<T> with EquatableMixin {
  const AxelorListModel(
    this.status,
    this.offset,
    this.total,
    this.errors,
    // String message,
    this.data,
  );

  ///  [status]
  ///  0 success
  /// -1 failure
  /// -4 validation error
  final int? status;
  final int? offset;
  final int? total;
  final Map<String, dynamic>? errors;
  final List<T>? data;

  bool get haveData => data != null && data!.isEmpty == false;
  bool get isEmpty => data == null || data!.isEmpty;
  // TODO(abd): page size is global "fixed", we need workaround to handle perRequest pagesize
  bool get canLoadMore => total == null || (data?.length ?? 0) < total!;
  // TODO(abd): page size is global "fixed", we need workaround to handle perRequest pagesize
  int get page => haveData && offset != null ? max((offset! / Axelor.pageSize).round(), 0) : 0;
  int get nextPage => page + 1;

  AxelorListModel<T> copyWith({
    int? status,
    int? offset,
    int? total,
    Map<String, dynamic>? errors,
    // String message,
    List<T>? data,
  }) {
    return AxelorListModel<T>(
      status ?? this.status,
      offset ?? this.offset,
      total ?? this.total,
      errors ?? this.errors,
      // message ?? this.message,
      data ?? this.data,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [status, offset, total, errors, data];

  static AxelorListModel<R> mock<R>({
    required int total,
    required List<R> data,
  }) =>
      AxelorListModel(1, 0, total, null, data);

  static AxelorResult<AxelorListModel<R>> successMock<R>({
    required int total,
    required List<R> data,
  }) =>
      Success(mock<R>(total: total, data: data));

  static AxelorListModel<R> Function(Object?) fromJson<R>(R Function(Object) fromJsonT) =>
      (Object? baseJson) => _$AxelorListModelFromJson(
            baseJson as Map<String, dynamic>,
            (contentJson) => fromJsonT(contentJson!),
          );

  static R Function(Object?) fromJsonAsSingle<R>(R Function(Object) fromJsonT) =>
      (Object? baseJson) => _$AxelorListModelFromJson(
            baseJson as Map<String, dynamic>,
            (contentJson) => fromJsonT(contentJson!),
          ).data!.first;

  static List<R> Function(Object?) dataTypeMapper<R>(R Function(Object?) fromJsonT) =>
      (Object? baseJson) => _$AxelorListModelFromJson(
            baseJson as Map<String, dynamic>,
            fromJsonT,
          ).data!;

  Map<String, dynamic> toJson(
    Object Function(T value) toJsonT,
  ) =>
      _$AxelorListModelToJson(this, toJsonT);

  AxelorListModel<T> merge(AxelorListModel<T> newObject) {
    return AxelorListModel<T>(
      newObject.status ?? status,
      newObject.offset ?? offset,
      newObject.total ?? total,
      newObject.errors ?? errors,
      data?..addAll(newObject.data!),
    );
  }

  static AxelorListModel<T> defaultParams<T>() {
    return AxelorListModel<T>(null, null, null, null, []);
  }
}
