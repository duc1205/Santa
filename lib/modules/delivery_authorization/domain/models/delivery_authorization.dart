import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery_authorization/domain/enums/delivery_authorization_status.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';

part 'delivery_authorization.g.dart';

@JsonSerializable()
class DeliveryAuthorization extends Equatable {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'delivery_id')
  final int deliveryId;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'is_received')
  final bool isReceived;
  @JsonKey(name: 'status', unknownEnumValue: DeliveryAuthorizationStatus.unknown)
  final DeliveryAuthorizationStatus status;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// Relations

  @JsonKey(name: "user")
  final User? user;
  @JsonKey(name: "delivery")
  final Delivery? delivery;

  const DeliveryAuthorization({
    required this.id,
    required this.deliveryId,
    required this.isReceived,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
    required this.status,
    this.user,
    this.delivery,
  });

  factory DeliveryAuthorization.fromJson(Map<String, dynamic> json) => _$DeliveryAuthorizationFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryAuthorizationToJson(this);

  @override
  List<Object?> get props => [id];
}
