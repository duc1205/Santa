import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery/data/repositories/delivery_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class CheckDeliveryReopenableUsecase extends Usecase {
  final DeliveryRepository _deliveryRepository;

  const CheckDeliveryReopenableUsecase(this._deliveryRepository);

  Future<bool> run(int deliveryId) => _deliveryRepository.checkDeliveryReopenable(deliveryId: deliveryId);
}
