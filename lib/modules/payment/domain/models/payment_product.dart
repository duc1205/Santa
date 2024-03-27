import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_product.g.dart';

@JsonSerializable()
class PaymentProduct extends Equatable {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "value")
  final int value;
  @JsonKey(name: "price")
  final int price;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;

  const PaymentProduct({
    required this.id,
    required this.value,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id];

  factory PaymentProduct.fromJson(Map<String, dynamic> json) => _$PaymentProductFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentProductToJson(this);

  int get bonus => value - price;
}
