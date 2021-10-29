import 'package:dio/dio.dart';
import 'package:flutter_axelor_sdk/flutter_axelor_sdk.dart';
import 'package:flutter_axelor_sdk/models/axelor_list_model.dart';
import 'package:flutter_axelor_sdk/models/axelor_model.dart';
import 'package:flutter_axelor_sdk/models/axelor_version_model.dart';
import 'package:flutter_axelor_sdk/utils/axelor_body.dart';
import 'package:flutter_axelor_sdk/utils/axelor_result.dart';

extension UpdateExt on AxelorImpl {
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
  Future<AxelorResult<T>> update<T extends AxelorModel>({
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
  }) async {
    final Options options = buildHeaders(headers: headers, withAuth: withAuth);

    final String _endPoint =
        endPoint ?? buildAxelorEndPoint(baseDomain: baseDomain, id: id, model: model, action: null);

    final int? _version = version ??
        (await Axelor.fetch(
          baseDomain: baseDomain,
          model: model,
          id: id,
          mapper: AxelorVersionModel.fromJson,
          body: AxelorBody(fields: AxelorVersionModel.fields),
        ))
            .getOrNull()
            ?.version;

    final Response response = await client.post(
      _endPoint,
      queryParameters: params,
      options: options,
      data: body.copyWith(version: _version, id: id).toJson(),
    );

    return handleResponse<T>(response, AxelorListModel.fromJsonAsSingle<T>(mapper));
  }
}
