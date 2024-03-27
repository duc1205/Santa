import 'package:json_annotation/json_annotation.dart';
import 'package:santapocket/modules/delivery/domain/models/pocket_extra.dart';
import 'package:suga_core/suga_core.dart';

part 'delivery_extra.g.dart';

@JsonSerializable()
class DeliveryExtra extends Model {
  @JsonKey(name: "pocket")
  final PocketExtra? pocketExtra;

  const DeliveryExtra({this.pocketExtra});

  factory DeliveryExtra.fromJson(Map<String, dynamic> json) => _$DeliveryExtraFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryExtraToJson(this);

  @override
  List<Object?> get props => throw UnimplementedError();
}
