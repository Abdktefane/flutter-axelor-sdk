import 'package:dio/dio.dart';
import 'package:flutter_axelor_sdk/flutter_axelor_sdk.dart';
import 'package:flutter_axelor_sdk/models/axelor_list_model.dart';
import 'package:flutter_axelor_sdk/models/axelor_model.dart';
import 'package:flutter_axelor_sdk/utils/axelor_body.dart';
import 'package:flutter_axelor_sdk/utils/axelor_result.dart';

extension FetchExt on AxelorImpl {
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
  Future<AxelorResult<T>> fetch<T extends AxelorModel>({
    required bool baseDomain,
    required String model,
    required int id,
    required AxelorMapper<T> mapper,
    String? endPoint,
    bool withAuth = true,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    AxelorBody? body,
  }) async {
    final bool isAdvanced = body != null;
    final AxelorApiAction? action = isAdvanced ? AxelorApiAction.fetch : null;

    final Options options = buildHeaders(headers: headers, withAuth: withAuth);
    final String _endPoint = endPoint ??
        buildAxelorEndPoint(
          baseDomain: baseDomain,
          id: id,
          model: model,
          action: action,
        );

    late final Response response;
    if (isAdvanced) {
      response = await client.post(
        _endPoint,
        queryParameters: params,
        options: options,
        data: body.toJson(),
      );
    } else {
      response = await client.get(
        _endPoint,
        queryParameters: params,
        options: options,
      );
    }

    return handleResponse<T>(response, AxelorListModel.fromJsonAsSingle<T>(mapper));
  }
}
