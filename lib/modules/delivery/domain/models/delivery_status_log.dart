import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_status.dart';

part 'delivery_status_log.g.dart';

@JsonSerializable()
class DeliveryStatusLog extends Equatable {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "status", unknownEnumValue: DeliveryStatus.unknown)
  final DeliveryStatus status;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;

  const DeliveryStatusLog({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [id];

  factory DeliveryStatusLog.fromJson(Map<String, dynamic> json) => _$DeliveryStatusLogFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryStatusLogToJson(this);
}
