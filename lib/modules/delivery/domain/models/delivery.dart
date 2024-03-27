import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket.dart';
import 'package:santapocket/modules/charity/domain/models/charity.dart';
import 'package:santapocket/modules/charity/domain/models/charity_campaign.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_status.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_type.dart';
import 'package:santapocket/modules/delivery/domain/enums/package_category.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery_extra.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery_status_log.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';

part 'delivery.g.dart';

@JsonSerializable()
@CopyWith()
class Delivery extends Equatable {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "pocket_id")
  final int pocketId;
  @JsonKey(name: "sender_id")
  final int senderId;
  @JsonKey(name: "receiver_id")
  final int receiverId;
  @JsonKey(name: "charity_campaign_id")
  final String? charityCampaingId;
  @JsonKey(name: "status", unknownEnumValue: DeliveryStatus.unknown)
  final DeliveryStatus status;
  @JsonKey(name: "updated_status_at")
  final DateTime updatedStatusAt;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;
  @JsonKey(name: "note")
  final String? note;
  @JsonKey(name: "sending_price")
  final int? sendingPrice;
  @JsonKey(name: "receiving_price")
  final int? receivingPrice;
  @JsonKey(name: "charged_amount")
  final int? chargedAmount;
  @JsonKey(name: "refunded_amount")
  final int? refundedAmount;
  @JsonKey(name: "coin_amount")
  final int? coinAmount;
  @JsonKey(name: "extra")
  final DeliveryExtra? extra;
  @JsonKey(name: "package_category", unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final PackageCategory? packageCategory;
  final String? charityId;
  @JsonKey(name: "type", unknownEnumValue: DeliveryType.unknown)
  final DeliveryType type;

  /// Aggregations

  @JsonKey(name: "estimated_receiving_price")
  final int? estimatedReceivingPrice;

  /// Relations

  @JsonKey(name: "sender")
  final User? sender;
  @JsonKey(name: "receiver")
  final User? receiver;
  @JsonKey(name: "pocket")
  final Pocket? pocket;
  @JsonKey(name: "status_logs")
  final List<DeliveryStatusLog>? statusLogs;
  @JsonKey(name: "authorization")
  final DeliveryAuthorization? authorization;
  @JsonKey(name: "cabinet")
  final Cabinet? cabinet;
  @JsonKey(name: "charity")
  final Charity? charity;
  @JsonKey(name: "charity_campaign")
  final CharityCampaign? charityCampaign;

  const Delivery({
    required this.id,
    required this.pocketId,
    required this.senderId,
    required this.receiverId,
    required this.charityCampaingId,
    required this.status,
    required this.updatedStatusAt,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    this.note,
    this.sendingPrice,
    this.receivingPrice,
    this.chargedAmount,
    this.refundedAmount,
    this.coinAmount,
    this.extra,
    this.packageCategory,
    this.estimatedReceivingPrice,
    this.sender,
    this.receiver,
    this.pocket,
    this.statusLogs,
    this.authorization,
    this.cabinet,
    this.charityId,
    this.charity,
    this.charityCampaign,
  });

  @override
  List<Object> get props => [id];

  factory Delivery.fromJson(Map<String, dynamic> json) => _$DeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryToJson(this);

  int get totalFee => (receivingPrice ?? 0) + (chargedAmount ?? 0) - (refundedAmount ?? 0);
}
