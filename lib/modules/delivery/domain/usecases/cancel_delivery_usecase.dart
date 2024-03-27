import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery/data/repositories/delivery_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class CancelDeliveryUsecase extends Usecase {
  final DeliveryRepository _deliveryRepository;

  const CancelDeliveryUsecase(this._deliveryRepository);

  Future<bool> run(int deliveryId) async {
    await _deliveryRepository.cancelDelivery(deliveryId);
    return true;
  }
}
