import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_axelor_sdk/flutter_axelor_sdk.dart';

import 'fixture_reader.dart';

void initAxelor(
  String path, {
  ValueChanged<RequestOptions>? requestChecker,
  ValueChanged<RequestOptions>? requestChecker2,
  int? pageSize,
  String? path2,
}) {
  Axelor.initialize(
    builder: AxelorBuilder(
      domain: 'testDomain',
      logger: (ex, st) {},
      // logger: (ex, st) => print('exceptio: $ex, st: $st'),
      pageSize: pageSize ?? 3,
      client: Dio()
        ..interceptors.addAll(
          [
            MockInterceptor(
              path,
              requestChecker,
              requestChecker2,
              path2,
            )
          ],
        ),
    ),
  );
}

class MockInterceptor extends Interceptor {
  MockInterceptor(
    this.path1, [
    this.requestChecker,
    this.requestChecker2,
    this.path2,
  ]);

  final String path1;
  final String? path2;
  final ValueChanged<RequestOptions>? requestChecker;
  final ValueChanged<RequestOptions>? requestChecker2;

  int requestNumber = 0;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    requestNumber++;
    late final String data;
    if (requestNumber == 1) {
      requestChecker?.call(options);
      data = FixtureReader.read(path1);
    } else if (requestNumber == 2) {
      requestChecker2?.call(options);
      data = FixtureReader.read(path2 ?? path1);
    }

    handler.resolve(Response(
      requestOptions: options,
      data: data,
      statusCode: 200,
    ));
  }
}
