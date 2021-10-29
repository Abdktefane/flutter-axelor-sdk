part of '../flutter_axelor_sdk.dart';

class AxelorBuilder extends Equatable {
  const AxelorBuilder({
    required this.domain,
    required this.logger,
    this.client,
    this.clientOptions,
    this.pageSize = 25,
  }) : assert(client != null || clientOptions != null, 'you must provide one of client, clientOptions');

  final Dio? client;
  final BaseOptions? clientOptions;
  final String domain;
  final ErrorLogger? logger;
  final int pageSize;

  AxelorBuilder copyWith({
    Dio? client,
    BaseOptions? clientOptions,
    String? domain,
    ErrorLogger? logger,
  }) {
    return AxelorBuilder(
      client: client ?? this.client,
      clientOptions: clientOptions ?? this.clientOptions,
      domain: domain ?? this.domain,
      logger: logger ?? this.logger,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        logger,
        domain,
      ];
}
