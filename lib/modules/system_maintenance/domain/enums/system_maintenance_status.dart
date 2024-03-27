import 'package:json_annotation/json_annotation.dart';

enum SystemMaintenanceStatus {
  unknown,
  @JsonValue("created")
  created,
  @JsonValue("soft_maintaining")
  softMaintaining,
  @JsonValue("maintaining")
  maintaining,
  @JsonValue("finished")
  finished,
}
