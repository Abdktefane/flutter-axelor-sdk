import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_axelor_sdk/flutter_axelor_sdk.dart';

import 'fixture_reader.dart';

void initAxelor(
  String path, {
  ValueChanged<RequestOptions>? requestChecker,
  int? pageSize,
}) {
  Axelor.initialize(
    builder: AxelorBuilder(
      domain: 'testDomain',
      logger: (ex, st) {},
      // logger: (ex, st) => print('exceptio: $ex, st: $st'),
      pageSize: pageSize ?? 3,
      client: Dio()..interceptors.addAll([MockInterceptor(path, requestChecker)]),
    ),
  );
}

class MockInterceptor extends Interceptor {
  MockInterceptor(this.path, [this.requestChecker]);

  final String path;
  final ValueChanged<RequestOptions>? requestChecker;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    requestChecker?.call(options);
    handler.resolve(Response(
      requestOptions: options,
      data: FixtureReader.read(path),
      statusCode: 200,
    ));
  }
}
