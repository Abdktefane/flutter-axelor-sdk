import 'package:flutter_axelor_sdk/models/failures.dart';

class CallException implements Exception {
  const CallException(this.cause);
  final Failure cause;
}

class ServerException implements Exception {
  ServerException(this.message);

  final String? message;
}

class NetworkException implements Exception {}

class CacheException implements Exception {}
