import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payroll_log.g.dart';

@JsonSerializable()
class PayrollLog extends Equatable {
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "amount")
  final int amount;
  @JsonKey(name: "created_at")
  final DateTime createdAt;

  const PayrollLog({
    required this.id,
    required this.amount,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id];

  factory PayrollLog.fromJson(Map<String, dynamic> json) => _$PayrollLogFromJson(json);

  Map<String, dynamic> toJson() => _$PayrollLogToJson(this);
}
