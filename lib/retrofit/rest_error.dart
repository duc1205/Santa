import 'package:dio/dio.dart';
import 'package:santapocket/config/config.dart';

class RestError extends DioError {
  static String defaultErrorMessage = " Have a error, please try again later";
  List<String>? _errors;
  Headers? _headers;

  RestError(this._errors, this._headers) : super(requestOptions: RequestOptions(path: Config.baseUrl));

  factory RestError.fromJson(dynamic map, Headers? headers) {
    final List<String> allMessages = [];

    if (map is String) {
      allMessages.add(map);
      return RestError(allMessages, headers);
    }

    if ((map as Map<String, dynamic>).containsKey("message")) {
      allMessages.add(map["message"].toString());
      return RestError(allMessages, headers);
    }

    final allValues = map.values.toList();
    for (final value in allValues) {
      for (final message in value as List<dynamic>) {
        allMessages.add(message.toString());
      }
    }

    return RestError(allMessages, headers);
  }

  factory RestError.fromErrorString(String? error, Headers? headers) {
    return RestError([error ?? defaultErrorMessage], headers);
  }

  List<String> getErrors() {
    return _errors != null ? _errors! : [];
  }

  String getAllErrorWithString() {
    return getErrors().join(", ");
  }

  String getError() {
    return getErrors().first;
  }

  String? getHeader(String key) => _headers?.value(key);
}
