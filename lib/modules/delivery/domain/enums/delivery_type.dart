import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

enum DeliveryType {
  unknown,
  @JsonValue("default")
  mDefault,
  @JsonValue("surprise")
  surprise,
  @JsonValue("charity")
  charity,
  @JsonValue("self_rent_pocket")
  selfRentPocket,
}

DeliveryType? deliveryTypeFromValue(String? value) {
  return DeliveryType.values.firstWhereOrNull((e) => e.toValue() == value);
}

extension DeliveryTypeExt on DeliveryType {
  String toValue() {
    switch (this) {
      case DeliveryType.mDefault:
        return 'default';
      case DeliveryType.surprise:
        return 'surprise';
      case DeliveryType.charity:
        return 'charity';
      case DeliveryType.selfRentPocket:
        return 'self_rent_pocket';
      default:
        return '';
    }
  }
}
