import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:suga_core/suga_core.dart';

class DeliveryCancelEvent extends Event {
  final Delivery delivery;

  const DeliveryCancelEvent({required this.delivery});
}
