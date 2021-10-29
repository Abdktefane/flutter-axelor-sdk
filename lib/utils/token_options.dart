import 'package:dio/dio.dart';

class TokenOption {
  static bool needToken(RequestOptions request) => request.extra[_tokenKey] != null;
  static Map<String, dynamic> toExtra() => <String, dynamic>{_tokenKey: true};
  static Options toOptions() => Options(extra: TokenOption.toExtra());
  static const String _tokenKey = 'token_request';
}
