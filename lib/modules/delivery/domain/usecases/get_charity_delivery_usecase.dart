import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery/data/repositories/delivery_repository.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetCharityDeliveryUsecase extends Usecase {
  final DeliveryRepository _deliveryRepository;

  const GetCharityDeliveryUsecase(this._deliveryRepository);

  Future<Delivery> run(int deliveryId) => _deliveryRepository.getCharityDeliveryById(deliveryId);
}
