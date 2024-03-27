import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket_size.dart';
import 'package:santapocket/modules/delivery/data/repositories/delivery_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class ChangePocketSizeUsecase extends Usecase {
  final DeliveryRepository _deliveryRepository;

  const ChangePocketSizeUsecase(this._deliveryRepository);

  Future<bool> run(int deliveryId, PocketSize pocketSize) async {
    await _deliveryRepository.changePocketSize(deliveryId, pocketSize);
    return true;
  }
}
