import 'package:json_annotation/json_annotation.dart';

enum PocketSizeUuid {
  unknown,
  @JsonValue("126x428")
  small,
  @JsonValue("244x428")
  medium,
  @JsonValue("492x428")
  large,
}
