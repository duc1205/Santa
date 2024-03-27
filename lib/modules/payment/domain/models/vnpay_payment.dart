import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vnpay_payment.g.dart';

@JsonSerializable()
class VnPayPayment extends Equatable {
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "status")
  final String status;
  @JsonKey(name: "orderId")
  final String orderId;
  @JsonKey(name: "payUrl")
  final String? payUrl;
  @JsonKey(name: "redirectUrl")
  final String? redirectUrl;

  const VnPayPayment({
    required this.id,
    required this.orderId,
    required this.status,
    this.payUrl,
    this.redirectUrl,
  });

  @override
  List<Object?> get props => [id];

  factory VnPayPayment.fromJson(Map<String, dynamic> json) => _$VnPayPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$VnPayPaymentToJson(this);
}
