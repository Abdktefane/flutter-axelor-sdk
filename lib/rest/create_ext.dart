import 'package:dio/dio.dart';
import 'package:flutter_axelor_sdk/flutter_axelor_sdk.dart';
import 'package:flutter_axelor_sdk/models/axelor_list_model.dart';
import 'package:flutter_axelor_sdk/models/axelor_model.dart';
import 'package:flutter_axelor_sdk/utils/axelor_body.dart';
import 'package:flutter_axelor_sdk/utils/axelor_result.dart';

extension CreateExt on AxelorImpl {
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
  Future<AxelorResult<T>> create<T extends AxelorModel>({
    required bool baseDomain,
    required String model,
    required AxelorMapper<T> mapper,
    required AxelorBody body,
    String? endPoint,
    bool withAuth = true,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    final Options options = buildHeaders(headers: headers, withAuth: withAuth);
    final String _endPoint =
        endPoint ?? buildAxelorEndPoint(baseDomain: baseDomain, model: model, id: null, action: null);

    final Response response = await client.post(
      _endPoint,
      queryParameters: params,
      options: options,
      data: body.toJson(),
    );

    return handleResponse<T>(response, AxelorListModel.fromJsonAsSingle<T>(mapper));
  }
}
