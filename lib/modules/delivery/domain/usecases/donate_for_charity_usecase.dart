import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery/data/repositories/delivery_repository.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class DonateForCharityUsecase extends Usecase {
  final DeliveryRepository _deliveryRepository;

  const DonateForCharityUsecase(this._deliveryRepository);

  Future<Delivery> run({required String id, String? note, required String packageCategory, required int cabinetId, required int pocketSizeId}) {
    return _deliveryRepository.donateForCharity(id, {
      "note": note ?? "",
      "package_category": packageCategory,
      "cabinet_id": cabinetId,
      "pocket_size_id": pocketSizeId,
    });
  }
}
