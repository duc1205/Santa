import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_device.g.dart';

@JsonSerializable()
class UserDevice extends Equatable {
  @JsonKey(name: "app_version")
  final String appVersion;
  @JsonKey(name: "os")
  final String os;
  @JsonKey(name: "os_version")
  final String? osVersion;
  @JsonKey(name: 'device_model')
  final String? deviceModel;
  @JsonKey(name: "notification_permission")
  final bool notificationPermission;

  const UserDevice({
    required this.appVersion,
    required this.os,
    required this.osVersion,
    required this.deviceModel,
    required this.notificationPermission,
  });

  factory UserDevice.fromJson(Map<String, dynamic> json) => _$UserDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$UserDeviceToJson(this);

  @override
  List<Object?> get props => throw UnimplementedError();
}
