import 'package:santapocket/modules/delivery/domain/models/reopen_request.dart';
import 'package:suga_core/suga_core.dart';

class DeliveryReopenRequestEvent extends Event {
  final ReopenRequest reopenRequest;

  const DeliveryReopenRequestEvent({required this.reopenRequest});
}
