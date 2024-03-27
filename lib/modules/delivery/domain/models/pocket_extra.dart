import 'package:json_annotation/json_annotation.dart';
import 'package:suga_core/suga_core.dart';

part 'pocket_extra.g.dart';

@JsonSerializable()
class PocketExtra extends Model {
  @JsonKey(name: "local_id")
  final int? localId;

  const PocketExtra({this.localId});

  factory PocketExtra.fromJson(Map<String, dynamic> json) => _$PocketExtraFromJson(json);

  Map<String, dynamic> toJson() => _$PocketExtraToJson(this);

  @override
  List<Object?> get props => throw UnimplementedError();
}
