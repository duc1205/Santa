import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/user/domain/enums/user_balance_changing_type.dart';

part 'balance_log.g.dart';

@JsonSerializable()
class BalanceLog extends Equatable {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "user_id")
  final int userId;
  @JsonKey(name: "old_balance")
  final int oldBalance;
  @JsonKey(name: "balance")
  final int balance;
  @JsonKey(name: "type", unknownEnumValue: UserBalanceChangingType.unknown)
  final UserBalanceChangingType type;
  @JsonKey(name: "extra")
  final Map<String, dynamic>? extra;
  @JsonKey(name: "created_at")
  final DateTime createdAt;

  const BalanceLog({
    required this.id,
    required this.userId,
    required this.oldBalance,
    required this.balance,
    required this.type,
    required this.extra,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id];

  factory BalanceLog.fromJson(Map<String, dynamic> json) => _$BalanceLogFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceLogToJson(this);
}
