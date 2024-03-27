import 'package:json_annotation/json_annotation.dart';

part 'payment_product_data.g.dart';

@JsonSerializable()
class PaymentProductData {
  @JsonKey(name: "price")
  final int price;
  @JsonKey(name: "value")
  final int value;

  const PaymentProductData({
    required this.price,
    required this.value,
  });

  factory PaymentProductData.fromJson(Map<String, dynamic> json) => _$PaymentProductDataFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentProductDataToJson(this);
}
