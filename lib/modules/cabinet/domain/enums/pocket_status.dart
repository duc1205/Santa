import 'package:json_annotation/json_annotation.dart';

enum PocketStatus {
  unknown,
  @JsonValue("opening")
  opening,
  @JsonValue("opened")
  opened,
  @JsonValue("closing")
  closing,
  @JsonValue("closed")
  closed,
}
