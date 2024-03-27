import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:suga_core/suga_core.dart';

class DeliveryStatusChangedEvent extends Usecase {
  final Delivery delivery;

  const DeliveryStatusChangedEvent({required this.delivery});
}
