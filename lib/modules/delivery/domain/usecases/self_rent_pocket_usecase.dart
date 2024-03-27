import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery/data/repositories/delivery_repository.dart';
import 'package:santapocket/modules/delivery/domain/enums/package_category.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class SelfRentPocketUsecase extends Usecase {
  final DeliveryRepository _deliveryRepository;

  const SelfRentPocketUsecase(this._deliveryRepository);

  Future<Delivery> run({
    required int cabinetId,
    required int sizeId,
    PackageCategory? packageCategory,
    String? note,
  }) =>
      _deliveryRepository.selfRentPocket(
        cabinetId: cabinetId,
        sizeId: sizeId,
        packageCategory: packageCategory,
        note: note,
      );
}
