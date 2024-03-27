import 'package:json_annotation/json_annotation.dart';

enum PaymentStatus {
  unknown,
  @JsonValue("created")
  create,
  @JsonValue("failed")
  fail,
  @JsonValue("captured")
  success,
}
