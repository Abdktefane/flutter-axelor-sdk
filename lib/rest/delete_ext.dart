import 'package:dio/dio.dart';
import 'package:flutter_axelor_sdk/flutter_axelor_sdk.dart';
import 'package:flutter_axelor_sdk/models/axelor_list_model.dart';
import 'package:flutter_axelor_sdk/models/axelor_version_model.dart';
import 'package:flutter_axelor_sdk/utils/axelor_result.dart';

extension DeleteExt on AxelorImpl {
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
  /// [return] array with id of deleted record as only element.
  Future<AxelorResult<AxelorListModel<AxelorVersionModel>>> delete({
    required bool baseDomain,
    required String model,
    required int id,
    String? endPoint,
    bool withAuth = true,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    final Options options = buildHeaders(headers: headers, withAuth: withAuth);
    final String _endPoint = endPoint ??
        buildAxelorEndPoint(
          baseDomain: baseDomain,
          id: id,
          model: model,
          action: null,
        );

    final Response response = await client.delete(
      _endPoint,
      queryParameters: params,
      options: options,
    );

    return handleResponse<AxelorListModel<AxelorVersionModel>>(
        response, AxelorListModel.fromJson(AxelorVersionModel.fromJson));
  }

  // Future<AxelorResult<List<int>>> delete({
  //   required bool baseDomain,
  //   required String model,
  //   required int id,
  //   String? endPoint,
  //   bool withAuth = true,
  //   Map<String, dynamic>? params,
  //   Map<String, dynamic>? headers,
  // }) async {
  //   final Options options = buildHeaders(headers: headers, withAuth: withAuth);
  //   final String _endPoint = endPoint ??
  //       buildAxelorEndPoint(
  //         baseDomain: baseDomain,
  //         id: id,
  //         model: model,
  //         action: null,
  //       );

  //   final Response response = await client.delete(
  //     _endPoint,
  //     queryParameters: params,
  //     options: options,
  //   );

  //   return handleResponse<List<int>>(response, AxelorListModel.dataTypeMapper((res) => res as int));
  // }
}
