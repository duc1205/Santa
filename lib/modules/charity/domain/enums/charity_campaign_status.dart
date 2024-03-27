import 'package:json_annotation/json_annotation.dart';

enum CharityCampaignStatus {
  unknown,
  @JsonValue("ready")
  ready,
  @JsonValue("finished")
  finished,
}
