import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/modules/delivery/data/repositories/delivery_repository.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetRecentReceiversUsecase extends Usecase {
  final DeliveryRepository _deliveryRepository;

  const GetRecentReceiversUsecase(this._deliveryRepository);

  Future<List<User>> run(ListParams listParams) => _deliveryRepository.getRecentReceivers(listParams);
}
