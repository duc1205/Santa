import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cabinet_photo.g.dart';

@JsonSerializable()
class CabinetPhoto extends Equatable {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'cabinet_id')
  final int cabinetId;
  @JsonKey(name: 'path')
  final String path;
  @JsonKey(name: 'url')
  final String url;
  @JsonKey(name: 'position')
  final int position;

  const CabinetPhoto({
    required this.id,
    required this.cabinetId,
    required this.path,
    required this.url,
    required this.position,
  });

  @override
  List<Object> get props => [id];

  factory CabinetPhoto.fromJson(Map<String, dynamic> json) => _$CabinetPhotoFromJson(json);

  Map<String, dynamic> toJson() => _$CabinetPhotoToJson(this);
}
