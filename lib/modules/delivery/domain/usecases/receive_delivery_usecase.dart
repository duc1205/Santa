import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery/data/repositories/delivery_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class ReceiveDeliveryUsecase extends Usecase {
  final DeliveryRepository _deliveryRepository;

  const ReceiveDeliveryUsecase(this._deliveryRepository);

  Future<Unit> run(int deliveryId, bool isUseCoin) => _deliveryRepository.receiveDelivery(deliveryId, isUseCoin);
}
