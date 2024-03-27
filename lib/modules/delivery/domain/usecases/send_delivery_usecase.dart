import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery/data/repositories/delivery_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class SendDeliveryUsecase extends Usecase {
  final DeliveryRepository _deliveryRepository;

  const SendDeliveryUsecase(this._deliveryRepository);

  Future run({required int id}) => _deliveryRepository.sendDelivery(id: id);
}
