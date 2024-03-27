import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery_authorization/data/repositories/delivery_authorization_repositories.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class ReceiveDeliveryAuthorizationUsecase extends Usecase {
  final DeliveryAuthorizationRepositories _deliveryAuthorizationRepositories;

  const ReceiveDeliveryAuthorizationUsecase(this._deliveryAuthorizationRepositories);

  Future<DeliveryAuthorization> run(int id) => _deliveryAuthorizationRepositories.receiveDeliveryAuthorization(id);
}
