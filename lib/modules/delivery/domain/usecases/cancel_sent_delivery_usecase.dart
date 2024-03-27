import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery/data/repositories/delivery_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class CancelSentDeliveryUsecase extends Usecase {
  final DeliveryRepository _deliveryRepository;

  const CancelSentDeliveryUsecase(this._deliveryRepository);

  Future<Unit> run({
    required int deliveryId,
    required int cabinetId,
  }) =>
      _deliveryRepository.cancelSentDelivery(
        deliveryId: deliveryId,
        cabinetId: cabinetId,
      );
}
