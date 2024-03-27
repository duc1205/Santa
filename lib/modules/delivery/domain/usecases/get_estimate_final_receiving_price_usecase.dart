import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery/data/repositories/delivery_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetEstimateFinalReceivingPriceUsecase extends Usecase {
  final DeliveryRepository _deliveryRepository;

  const GetEstimateFinalReceivingPriceUsecase(this._deliveryRepository);

  Future<int> run(int deliveryId) => _deliveryRepository.getEstimateFinalReceivingPrice(deliveryId);
}
