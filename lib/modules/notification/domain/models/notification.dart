import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/notification/domain/models/notification_data.dart';
import 'package:santapocket/retrofit/converters/string_converter.dart';

part 'notification.g.dart';

@JsonSerializable()
@CopyWith()
class Notification extends Equatable {
  @JsonKey(name: "id")
  @StringConverter()
  final String id;
  @JsonKey(name: "notifiable_id")
  final String notifiableId;
  @JsonKey(name: "data")
  final NotificationData data;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;
  @JsonKey(name: "read_at")
  final DateTime? readAt;

  const Notification({
    required this.id,
    required this.notifiableId,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
    this.readAt,
  });

  @override
  List<Object> get props => [id];

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  bool get isRead => readAt != null;
}
