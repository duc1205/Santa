import 'package:json_annotation/json_annotation.dart';

enum DeliveryAuthorizationStatus {
  unknown,
  @JsonValue('created')
  created,
  @JsonValue('received')
  received,
  @JsonValue('canceled')
  canceled
}
