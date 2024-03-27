import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/delivery/data/repositories/delivery_repository.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetReceivableDeliveriesUsecase extends Usecase {
  final DeliveryRepository _deliveryRepository;

  const GetReceivableDeliveriesUsecase(this._deliveryRepository);

  Future<List<Delivery>> run({
    SortParams? sortParams,
    int? cabinetId,
  }) =>
      _deliveryRepository.getReceivableDeliveries(
        sortParams: sortParams,
        cabinetId: cabinetId,
      );
}
