import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/cabinet/domain/enums/pocket_status.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket_size.dart';

part 'pocket.g.dart';

@JsonSerializable()
class Pocket extends Equatable {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "status", unknownEnumValue: PocketStatus.unknown)
  final PocketStatus status;
  @JsonKey(name: "local_id")
  final int? localId;
  @JsonKey(name: "cabinet_id")
  final int? cabinetId;
  @JsonKey(name: "size_id")
  final int sizeId;

  ///
  /// Relations
  ///

  @JsonKey(name: "cabinet_list")
  final Cabinet? cabinet;

  @JsonKey(name: "size")
  final PocketSize? size;

  const Pocket({
    required this.id,
    required this.name,
    required this.status,
    this.localId,
    required this.cabinetId,
    required this.sizeId,
    this.size,
    this.cabinet,
  });

  @override
  List<Object> get props => [id];

  factory Pocket.fromJson(Map<String, dynamic> json) => _$PocketFromJson(json);

  Map<String, dynamic> toJson() => _$PocketToJson(this);
}
