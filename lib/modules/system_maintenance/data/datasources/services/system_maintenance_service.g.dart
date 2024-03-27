// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_maintenance_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _SystemMaintenanceService implements SystemMaintenanceService {
  _SystemMaintenanceService(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'http://dev.sugamobile.com:26134/api/client/v1/system/maintenances';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<SystemMaintenance?> getActiveSystemMaintenance() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>?>(_setStreamType<SystemMaintenance>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/active',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data == null ? null : SystemMaintenance.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic && !(requestOptions.responseType == ResponseType.bytes || requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
