import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/system_maintenance/domain/enums/system_maintenance_status.dart';

part 'system_maintenance.g.dart';

@CopyWith()
@JsonSerializable()
class SystemMaintenance {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "content")
  final String content;
  @JsonKey(name: "started_at")
  final DateTime startedAt;
  @JsonKey(name: "ended_at")
  final DateTime endedAt;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;
  @JsonKey(name: "status", unknownEnumValue: SystemMaintenanceStatus.unknown)
  final SystemMaintenanceStatus status;

  const SystemMaintenance({
    required this.id,
    required this.name,
    required this.content,
    required this.startedAt,
    required this.endedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory SystemMaintenance.fromJson(Map<String, dynamic> json) => _$SystemMaintenanceFromJson(json);

  Map<String, dynamic> toJson() => _$SystemMaintenanceToJson(this);
}
