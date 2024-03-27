import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/notification/domain/models/notification_data_content.dart';
import 'package:santapocket/modules/notification/domain/models/notification_data_data.dart';

part 'notification_data.g.dart';

@JsonSerializable()
class NotificationData extends Equatable {
  @JsonKey(name: "content")
  final NotificationDataContent content;
  @JsonKey(name: "data")
  final NotificationDataData? data;

  const NotificationData({
    required this.content,
    this.data,
  });

  @override
  List<Object?> get props => [];

  factory NotificationData.fromJson(Map<String, dynamic> json) => _$NotificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}
