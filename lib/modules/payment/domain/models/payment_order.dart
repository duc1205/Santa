import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/payment/domain/enums/payment_status.dart';
import 'package:santapocket/modules/payment/domain/models/payment_product_data.dart';

part 'payment_order.g.dart';

@JsonSerializable()
class PaymentOrder {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "uuid")
  final String orderId;
  @JsonKey(name: "status", unknownEnumValue: PaymentStatus.unknown)
  final PaymentStatus status;
  @JsonKey(name: "amount")
  final int amount;
  @JsonKey(name: "user_id")
  final int userId;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;
  @JsonKey(name: "product_data")
  final PaymentProductData? productData;

  const PaymentOrder({
    required this.id,
    required this.orderId,
    required this.status,
    required this.amount,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.productData,
  });

  factory PaymentOrder.fromJson(Map<String, dynamic> json) => _$PaymentOrderFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentOrderToJson(this);
}
