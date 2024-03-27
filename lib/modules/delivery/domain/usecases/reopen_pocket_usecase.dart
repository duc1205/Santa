import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery/data/repositories/delivery_repository.dart';
import 'package:santapocket/modules/delivery/domain/models/reopen_request.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class ReopenPocketUsecase extends Usecase {
  final DeliveryRepository _deliveryRepository;

  const ReopenPocketUsecase(this._deliveryRepository);

  Future<ReopenRequest> run({required int deliveryId, required int cabinetId}) =>
      _deliveryRepository.reopenPocket(deliveryId: deliveryId, cabinetId: cabinetId);
}
