import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery/data/repositories/delivery_repository.dart';
import 'package:santapocket/modules/delivery/domain/enums/package_category.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class RentPocketUsecase extends Usecase {
  final DeliveryRepository _deliveryRepository;

  const RentPocketUsecase(this._deliveryRepository);

  Future<Delivery> run({
    required int cabinetId,
    required int sizeId,
    required String senderPhoneNumber,
    PackageCategory? packageCategory,
    String? note,
  }) =>
      _deliveryRepository.rentPocket(
        cabinetId: cabinetId,
        sizeId: sizeId,
        senderPhoneNumber: senderPhoneNumber,
        packageCategory: packageCategory,
        note: note,
      );
}
