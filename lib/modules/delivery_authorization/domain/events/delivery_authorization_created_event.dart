import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:suga_core/suga_core.dart';

class DeliveryAuthorizationCreatedEvent extends Event {
  final DeliveryAuthorization deliveryAuthorization;

  const DeliveryAuthorizationCreatedEvent(this.deliveryAuthorization);
}
