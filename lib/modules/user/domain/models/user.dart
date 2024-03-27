import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "phone_number")
  final String phoneNumber;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "balance")
  final int balance;
  @JsonKey(name: 'free_usage')
  final int freeUsage;
  @JsonKey(name: "locale")
  final String? locale;
  @JsonKey(name: "tutorial_completed_at")
  final DateTime? tutorialCompletedAt;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "coin")
  final int coin;
  @JsonKey(name: "tos_agreed_at")
  final DateTime? tosAgreedAt;
  @JsonKey(name: "referral_code")
  final String? referralCode;
  @JsonKey(name: "gem")
  final int gem;
  @JsonKey(name: "cone")
  final int cone;
  @JsonKey(name: "charity_deliveries_count")
  final int? charityDeliveriesCount;

  const User({
    required this.id,
    required this.phoneNumber,
    this.name,
    required this.balance,
    required this.freeUsage,
    this.locale,
    this.tutorialCompletedAt,
    this.type,
    required this.coin,
    this.tosAgreedAt,
    required this.referralCode,
    required this.gem,
    required this.cone,
    this.charityDeliveriesCount,
  });

  @override
  List<Object> get props => [id, phoneNumber, balance, freeUsage, coin, cone];

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get displayName => name ?? phoneNumber;

  bool get shouldWizardName => (name?.isEmpty ?? true);
  bool get shouldWizardType => (type?.isEmpty ?? true);

  String get wrapName => name != null ? "($name)" : "";

  String get displayPhoneNumberAndName => "$phoneNumber $wrapName";

  bool get isCompletedTutorial => tutorialCompletedAt != null;
}
