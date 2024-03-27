import 'package:json_annotation/json_annotation.dart';

enum CabinetStatus {
  unknown,
  @JsonValue("in_stock")
  inStock,
  @JsonValue("production")
  production,
  @JsonValue("maintenance")
  maintenance
}
