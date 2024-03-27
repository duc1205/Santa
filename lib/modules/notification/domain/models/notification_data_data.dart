import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/notification/domain/enums/notification_data_type.dart';

part 'notification_data_data.g.dart';

@JsonSerializable()
class NotificationDataData extends Equatable {
  @JsonKey(name: "type", unknownEnumValue: NotificationDataType.unknown)
  final NotificationDataType type;
  @JsonKey(name: "data")
  final Map<String, dynamic>? data;

  const NotificationDataData({
    required this.type,
    this.data,
  });

  @override
  List<Object?> get props => [];

  factory NotificationDataData.fromJson(Map<String, dynamic> json) => _$NotificationDataDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataDataToJson(this);
}
