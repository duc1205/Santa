import 'package:json_annotation/json_annotation.dart';

part 'payment_product_promo.g.dart';

@JsonSerializable()
class PaymentProductPromo {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "value")
  final int value;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;

  const PaymentProductPromo({
    required this.id,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentProductPromo.fromJson(Map<String, dynamic> json) => _$PaymentProductPromoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentProductPromoToJson(this);
}
