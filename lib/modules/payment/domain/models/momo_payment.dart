import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'momo_payment.g.dart';

@JsonSerializable()
class MomoPayment extends Equatable {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "status")
  final String status;
  @JsonKey(name: "orderId")
  final String orderId;
  @JsonKey(name: "payUrl")
  final String? payUrl;
  @JsonKey(name: "deepLink")
  final String? deepLink;
  @JsonKey(name: "qrCodeUrl")
  final String? qrCodeUrl;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "redirectUrl")
  final String? redirectUrl;

  const MomoPayment({
    required this.id,
    required this.orderId,
    required this.status,
    this.deepLink,
    this.payUrl,
    this.type,
    this.qrCodeUrl,
    this.redirectUrl,
  });

  @override
  List<Object?> get props => [id];

  factory MomoPayment.fromJson(Map<String, dynamic> json) => _$MomoPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$MomoPaymentToJson(this);
}
