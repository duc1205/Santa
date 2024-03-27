import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

enum DeliveryStatus {
  unknown,
  @JsonValue("created")
  created,
  @JsonValue("sending")
  sending,
  @JsonValue("sent")
  sent,
  @JsonValue("receiving")
  receiving,
  @JsonValue("received")
  received,
  @JsonValue("completed")
  completed,
  @JsonValue("failed")
  failed,
  @JsonValue("canceled")
  canceled,
}

DeliveryStatus? deliveryStatusFromValue(String? value) {
  return DeliveryStatus.values.firstWhereOrNull((e) => e.toValue() == value);
}

extension DeliveryStatusExt on DeliveryStatus {
  String toValue() {
    switch (this) {
      case DeliveryStatus.created:
        return 'created';
      case DeliveryStatus.sending:
        return 'sending';
      case DeliveryStatus.sent:
        return 'sent';
      case DeliveryStatus.receiving:
        return 'receiving';
      case DeliveryStatus.received:
        return 'received';
      case DeliveryStatus.completed:
        return 'completed';
      case DeliveryStatus.failed:
        return 'failed';
      case DeliveryStatus.canceled:
        return 'canceled';
      default:
        return '';
    }
  }
}
