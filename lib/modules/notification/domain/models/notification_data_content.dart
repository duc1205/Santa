import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_data_content.g.dart';

@JsonSerializable()
class NotificationDataContent extends Equatable {
  @JsonKey(name: "title")
  final String title;
  @JsonKey(name: "body")
  final String body;

  const NotificationDataContent({
    required this.title,
    required this.body,
  });

  @override
  List<Object?> get props => [];

  factory NotificationDataContent.fromJson(Map<String, dynamic> json) => _$NotificationDataContentFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataContentToJson(this);
}
