import 'package:dio/dio.dart';
import 'package:flutter_axelor_sdk/flutter_axelor_sdk.dart';
import 'package:flutter_axelor_sdk/models/axelor_list_model.dart';
import 'package:flutter_axelor_sdk/models/axelor_version_model.dart';
import 'package:flutter_axelor_sdk/utils/axelor_result.dart';

extension DeleteAllExt on AxelorImpl {
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
  Future<AxelorResult<AxelorListModel<AxelorVersionModel>>> deleteAll({
    required bool baseDomain,
    required String model,
    required List<AxelorVersionModel> records,
    String? endPoint,
    bool withAuth = true,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    final Options options = buildHeaders(headers: headers, withAuth: withAuth);

    final String _endPoint = endPoint ??
        buildAxelorEndPoint(
          baseDomain: baseDomain,
          model: model,
          action: AxelorApiAction.removeAll,
          id: null,
        );

    final Response response = await client.post(
      _endPoint,
      queryParameters: params,
      options: options,
      data: {
        'records': records.map((it) => it.toJson()),
      },
    );

    return handleResponse<AxelorListModel<AxelorVersionModel>>(
        response, AxelorListModel.fromJson(AxelorVersionModel.fromJson));
  }
}
