import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_reopen_request_status.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';

part 'reopen_request.g.dart';

@JsonSerializable()
@CopyWith()
class ReopenRequest extends Equatable {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "delivery_id")
  final int deliveryId;
  @JsonKey(name: "status", unknownEnumValue: DeliveryReopenRequestStatus.unknown)
  final DeliveryReopenRequestStatus status;
  @JsonKey(name: "delivery")
  final Delivery? delivery;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;

  const ReopenRequest({
    required this.id,
    required this.deliveryId,
    this.delivery,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [id];

  factory ReopenRequest.fromJson(Map<String, dynamic> json) => _$ReopenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReopenRequestToJson(this);
}
