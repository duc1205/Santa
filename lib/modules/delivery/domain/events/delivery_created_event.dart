import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:suga_core/suga_core.dart';

class DeliveryCreatedEvent extends Event {
  final Delivery delivery;

  const DeliveryCreatedEvent({required this.delivery});
}
