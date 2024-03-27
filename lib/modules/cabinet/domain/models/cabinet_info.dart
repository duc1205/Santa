import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/cabinet/domain/enums/cabinet_status.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';

part 'cabinet_info.g.dart';

@JsonSerializable()
class CabinetInfo extends Equatable {
  @JsonKey(name: "cabinet_id")
  final int id;
  @JsonKey(name: "cabinet_name")
  final String name;
  @JsonKey(name: "cabinet_status", unknownEnumValue: CabinetStatus.unknown)
  final CabinetStatus status;
  @JsonKey(name: "cabinet_is_online")
  final bool isOnline;
  @JsonKey(name: "receivable_deliveries")
  final List<Delivery>? receivableDeliveries;
  @JsonKey(name: "receivable_delivery_authorizations")
  final List<DeliveryAuthorization>? receivableDeliveryAuthorizations;

  const CabinetInfo({
    required this.id,
    required this.name,
    required this.receivableDeliveries,
    required this.status,
    required this.isOnline,
    required this.receivableDeliveryAuthorizations,
  });

  @override
  List<Object> get props => [];

  factory CabinetInfo.fromJson(Map<String, dynamic> json) => _$CabinetInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CabinetInfoToJson(this);
}
