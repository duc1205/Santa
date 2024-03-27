import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery/data/repositories/delivery_repository.dart';
import 'package:santapocket/modules/delivery/domain/models/reopen_request.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetDeliveryReopenRequestUsecase extends Usecase {
  final DeliveryRepository _deliveryRepository;

  const GetDeliveryReopenRequestUsecase(this._deliveryRepository);

  Future<ReopenRequest> run(int reopenRequestId) => _deliveryRepository.getDeliveryReopenRequest(reopenRequestId: reopenRequestId);
}
