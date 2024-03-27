import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

enum DeliveryReopenRequestStatus {
  unknown,
  @JsonValue("created")
  created,
  @JsonValue("opening")
  opening,
  @JsonValue("opened")
  opened,
  @JsonValue("completed")
  completed,
  @JsonValue("failed")
  failed,
}

DeliveryReopenRequestStatus? deliveryStatusFromValue(String? value) {
  return DeliveryReopenRequestStatus.values.firstWhereOrNull((e) => e.toValue() == value);
}

extension DeliveryStatusExt on DeliveryReopenRequestStatus {
  String toValue() {
    switch (this) {
      case DeliveryReopenRequestStatus.created:
        return 'created';
      case DeliveryReopenRequestStatus.opening:
        return 'sending';
      case DeliveryReopenRequestStatus.opened:
        return 'sent';
      case DeliveryReopenRequestStatus.completed:
        return 'completed';
      case DeliveryReopenRequestStatus.failed:
        return 'failed';
      default:
        return '';
    }
  }
}
