import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message, [this.properties = const <dynamic>[]]);
  final List properties;
  final String? message;

  @override
  List<Object> get props => properties as List<Object>;
}

// General failures
class UnknownFailure extends Failure {
  const UnknownFailure(String message) : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure(String? message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure(String message) : super(message);
}
