import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'qr_data.g.dart';

@JsonSerializable()
class QrData extends Equatable {
  @JsonKey(name: "product")
  final String product;
  @JsonKey(name: "version")
  final int version;
  @JsonKey(name: "type")
  final String type;
  @JsonKey(name: "data")
  final Map<String, dynamic>? data;
  @JsonKey(name: "otp")
  final String? otp;

  const QrData({
    required this.product,
    required this.version,
    required this.type,
    this.data,
    this.otp,
  });

  @override
  List<Object> get props => [];

  factory QrData.fromJson(Map<String, dynamic> json) => _$QrDataFromJson(json);

  Map<String, dynamic> toJson() => _$QrDataToJson(this);
}
