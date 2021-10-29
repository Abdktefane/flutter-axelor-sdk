part of 'flutter_axelor_sdk.dart';

class AxelorImpl extends Axelor {
  AxelorImpl._(AxelorBuilder builder)
      : client = builder.client ?? Dio(builder.clientOptions!),
        domain = builder.domain,
        logger = builder.logger,
        pageSize = builder.pageSize;

  final Dio client;
  final String? domain;
  final ErrorLogger? logger;
  final int pageSize;

  AxelorResult<T> handleResponse<T>(Response response, AxelorMapper<T>? mapper) {
    try {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.data);
      if ((jsonResponse['status'] as int?) != 0) {
        throw ServerException(_getErrorMessage(jsonResponse));
      }
      return Success<T>(mapper!(jsonResponse));
    } catch (ex, st) {
      logger?.call(ex, st);
      return ex is ServerException
          ? NetworkError(ServerFailure(ex.message))
          : NetworkError(const ServerFailure('msg_something_wrong'));
    }
  }

  Options buildHeaders({required bool withAuth, required Map<String, dynamic>? headers}) {
    return withAuth ? TokenOption.toOptions().copyWith(headers: headers) : Options(headers: headers);
  }

  String buildAxelorEndPoint({
    required bool baseDomain,
    required String model,
    required int? id,
    required AxelorApiAction? action,
  }) {
    return REST_SERVICE +
        '/${baseDomain ? BASE_MODEL_DOMAIN : domain}$model' +
        (id != null ? '/$id' : '') +
        (action != null ? '/${action.row}' : '');
  }

  String? _getErrorMessage(Map<String, dynamic> response) {
    try {
      return (response['status'] as int == -1) ? response['data']['message'] : response['errors']['error'];
    } catch (ex) {
      return 'msg_something_wrong';
    }
  }
}
