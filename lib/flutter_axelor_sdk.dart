library flutter_axelor_sdk;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_axelor_sdk/models/axelor_criteria.dart';
import 'package:flutter_axelor_sdk/models/axelor_model.dart';
import 'package:flutter_axelor_sdk/models/axelor_operators.dart';
import 'package:flutter_axelor_sdk/models/exceptions.dart';
import 'package:flutter_axelor_sdk/models/failures.dart';
import 'package:flutter_axelor_sdk/rest/create_ext.dart';
import 'package:flutter_axelor_sdk/rest/delete_all_ext.dart';
import 'package:flutter_axelor_sdk/rest/delete_ext.dart';
import 'package:flutter_axelor_sdk/rest/fetch_ext.dart';
import 'package:flutter_axelor_sdk/rest/search_ext.dart';
import 'package:flutter_axelor_sdk/rest/update_ext.dart';
import 'package:flutter_axelor_sdk/utils/axelor_body.dart';
import 'package:flutter_axelor_sdk/utils/axelor_result.dart';
import 'package:flutter_axelor_sdk/utils/error_logger.dart';
import 'package:flutter_axelor_sdk/utils/token_options.dart';

import 'models/axelor_list_model.dart';
import 'models/axelor_version_model.dart';

part 'axelor_impl.dart';
part 'utils/axelor_builder.dart';
part 'utils/axelor_criteria_ext.dart';

const String WEB_SERVICE = '/ws';
const REST_SERVICE = '$WEB_SERVICE/rest';
const String BASE_MODEL_DOMAIN = 'com.axelor.';
enum AxelorApiAction { search, remove, fetch, upload, removeAll }

extension AxelorApiActionExt on AxelorApiAction {
  String get row => describeEnum(this);
}

typedef AxelorMapper<T> = T Function(Object?);
// typedef AxelorMapper<T> = BaseResponseModel<T> Function(Map<String, dynamic>?);

typedef AxelorListMapper<T> = AxelorListModel<T> Function(Object);

// TODO(abd): we should add global try and catch for no internet connection
abstract class Axelor {
  static AxelorImpl? _instance;

  static int get pageSize => _getInstance().pageSize;

  static bool canLoadMore({
    int? pageSize,
    required int? total,
    required int? page,
  }) {
    if (page == null || total == null) {
      return true;
    }
    final int _pageSize = pageSize ?? Axelor.pageSize;
    return (page * _pageSize) > total;
  }

  static Axelor initialize({required AxelorBuilder builder}) {
    assert(_instance == null, 'Axelor already initialized');
    _instance = AxelorImpl._(builder);
    return _instance!;
  }

  static AxelorImpl _getInstance() {
    _checkInitialize();
    return _instance!;
  }

  static void _checkInitialize() {
    assert(_instance != null, 'Axelor not initialize yet, please use Axelor.initialize() first');
  }

  static void close() {
    _checkInitialize();
    _instance?.client.close(force: true);
    _instance = null;
  }

  // Rest API'S

  /// fetch [model] from axelor backend
  ///
  /// params:
  /// [baseDomain]: boolean flag to detrmine prefix of model if [true] will generate [/com.axelor. + model]
  /// if [false] will generate [AxelorBuilder.domain + model]
  /// [model]: model name in axelor backend
  /// [id]: model id in axelor backend
  /// [endPoint]: if no sufficient method provide to create end point, you can provide end point directly
  /// [withAuth]: if [true] add token in header
  /// [params]: query params
  /// [headers]: http headers
  /// [mapper]: Callback to transform json response into [AxelorModel]
  /// [body]: if we need advance fetch we can use [AxelorBody] to construct complex query
  static Future<AxelorResult<T>> fetch<T extends AxelorModel>({
    required bool baseDomain,
    required String model,
    required int id,
    required AxelorMapper<T> mapper,
    String? endPoint,
    bool withAuth = true,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    AxelorBody? body,
  }) {
    _checkInitialize();
    return _getInstance().fetch<T>(
      baseDomain: baseDomain,
      model: model,
      id: id,
      endPoint: endPoint,
      params: params,
      headers: headers,
      mapper: mapper,
      withAuth: withAuth,
      body: body,
    );
  }

  /// search [model] from axelor backend
  ///
  /// params:
  /// [baseDomain]: boolean flag to detrmine prefix of model if [true] will generate [/com.axelor. + model]
  /// if [false] will generate [AxelorBuilder.domain + model]
  /// [model]: model name in axelor backend
  /// [id]: model id in axelor backend
  /// [endPoint]: if no sufficient method provide to create end point, you can provide end point directly
  /// [withAuth]: if [true] add token in header
  /// [params]: query params
  /// [headers]: http headers
  /// [mapper]: Callback to transform json response into [AxelorModel]
  /// [body]: if we need advance fetch we can use [AxelorBody] to construct complex query
  /// [offset]: pagination offset
  /// [limit]: pagination limit, if [null] will take default value from [AxelorBuilder.pageSize]
  /// [page]: use page strategy for pagination
  static Future<AxelorResult<AxelorListModel<T>>> search<T extends AxelorModel>({
    int? page,
    int? offset,
    int? limit,
    required bool baseDomain,
    required String model,
    required AxelorMapper<T> mapper,
    String? endPoint,
    bool withAuth = true,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    AxelorBody? body,
  }) {
    _checkInitialize();
    return _getInstance().search<T>(
      baseDomain: baseDomain,
      model: model,
      endPoint: endPoint,
      params: params,
      headers: headers,
      mapper: mapper,
      withAuth: withAuth,
      body: body,
      limit: limit,
      offset: offset,
      page: page,
    );
  }

  /// create [model] in axelor backend
  ///
  /// params:
  /// [baseDomain]: boolean flag to detrmine prefix of model if [true] will generate [/com.axelor. + model]
  /// if [false] will generate [AxelorBuilder.domain + model]
  /// [model]: model name in axelor backend
  /// [endPoint]: if no sufficient method provide to create end point, you can provide end point directly
  /// [withAuth]: if [true] add token in header
  /// [params]: query params
  /// [headers]: http headers
  /// [mapper]: Callback to transform json response into [AxelorModel]
  /// [body]: [AxelorBody] new record object
  /// 
  /// ```dart
  /// Axelor.create(
  ///   baseDomain: true,
  ///   model: UserModel.modelName,
  ///   mapper: UserModel.fromJson,
  ///   body: const AxelorBody(
  ///     fields: ['name', 'lastName'],
  ///     data: {
  ///       'firstName': 'John',
  ///       'lastName': 'Smith',
  ///       'email': 'j.smith@gmail.com',
  ///     },
  ///   ),
  /// );
  /// ```
  static Future<AxelorResult<T>> create<T extends AxelorModel>({
    required bool baseDomain,
    required String model,
    required AxelorMapper<T> mapper,
    required AxelorBody body,
    String? endPoint,
    bool withAuth = true,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) {
    _checkInitialize();
    return _getInstance().create<T>(
      baseDomain: baseDomain,
      model: model,
      mapper: mapper,
      body: body,
      endPoint: endPoint,
      headers: headers,
      params: params,
      withAuth: withAuth,
    );
  }

  /// update [model] in axelor backend
  ///
  /// params:
  /// [baseDomain]: boolean flag to detrmine prefix of model if [true] will generate [/com.axelor. + model]
  /// if [false] will generate [AxelorBuilder.domain + model]
  /// [model]: model name in axelor backend
  /// [id]: model id in axelor backend
  /// [endPoint]: if no sufficient method provide to create end point, you can provide end point directly
  /// [withAuth]: if [true] add token in header
  /// [params]: query params
  /// [headers]: http headers
  /// [mapper]: Callback to transform json response into [AxelorModel]
  /// [body]: [AxelorBody] new record object
  /// [version]: Version number is used in order to ensure non-conflicting modifications of the record,
  ///  and thus must be specified if [version] is null and [body.version] is null, auto version fetch will apply.
  static Future<AxelorResult<T>> update<T extends AxelorModel>({
    required bool baseDomain,
    required String model,
    required int id,
    required AxelorMapper<T> mapper,
    required AxelorBody body,
    int? version,
    String? endPoint,
    bool withAuth = true,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) {
    _checkInitialize();
    return _getInstance().update(
      baseDomain: baseDomain,
      model: model,
      id: id,
      mapper: mapper,
      body: body,
      endPoint: endPoint,
      headers: headers,
      params: params,
      version: version,
      withAuth: withAuth,
    );
  }

  /// delete [model] from axelor backend
  ///
  /// params:
  /// [baseDomain]: boolean flag to detrmine prefix of model if [true] will generate [/com.axelor. + model]
  /// if [false] will generate [AxelorBuilder.domain + model]
  /// [model]: model name in axelor backend
  /// [id]: model id in axelor backend
  /// [endPoint]: if no sufficient method provide to create end point, you can provide end point directly
  /// [withAuth]: if [true] add token in header
  /// [params]: query params
  /// [headers]: http headers
  /// [return] [AxelorVersionModel] which contain [id] and [version] of deleted record as only element.
  static Future<AxelorResult<AxelorVersionModel>> delete({
    required bool baseDomain,
    required String model,
    required int id,
    String? endPoint,
    bool withAuth = true,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) {
    _checkInitialize();
    return _getInstance().delete(
      baseDomain: baseDomain,
      model: model,
      id: id,
      endPoint: endPoint,
      headers: headers,
      params: params,
      withAuth: withAuth,
    );
  }
  // static Future<AxelorResult<List<int>>> delete({
  //   required bool baseDomain,
  //   required String model,
  //   required int id,
  //   String? endPoint,
  //   bool withAuth = true,
  //   Map<String, dynamic>? params,
  //   Map<String, dynamic>? headers,
  // }) {
  //   _checkInitialize();
  //   return _getInstance().delete(
  //     baseDomain: baseDomain,
  //     model: model,
  //     id: id,
  //     endPoint: endPoint,
  //     headers: headers,
  //     params: params,
  //     withAuth: withAuth,
  //   );
  // }

  /// delete all [models] in axelor backend
  /// This is a specialized delete service besides the standard REST service to delete records in bulk.
  ///
  /// params:
  /// [baseDomain]: boolean flag to detrmine prefix of model if [true] will generate [/com.axelor. + model]
  /// if [false] will generate [AxelorBuilder.domain + model]
  /// [model]: model name in axelor backend
  /// [endPoint]: if no sufficient method provide to create end point, you can provide end point directly
  /// [withAuth]: if [true] add token in header
  /// [params]: query params
  /// [headers]: http headers
  /// [records]: list of [AxelorVersionModel] new record object
  static Future<AxelorResult<AxelorListModel<AxelorVersionModel>>> deleteAll({
    required bool baseDomain,
    required String model,
    required List<AxelorVersionModel> records,
    String? endPoint,
    bool withAuth = true,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) {
    _checkInitialize();
    return _getInstance().deleteAll(
      baseDomain: baseDomain,
      model: model,
      endPoint: endPoint,
      headers: headers,
      params: params,
      withAuth: withAuth,
      records: records,
    );
  }
}
