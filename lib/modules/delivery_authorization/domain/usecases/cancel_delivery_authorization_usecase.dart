import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery_authorization/data/repositories/delivery_authorization_repositories.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class CancelDeliveryAuthorizationUsecase extends Usecase {
  final DeliveryAuthorizationRepositories _deliveryAuthorizationRepositories;

  const CancelDeliveryAuthorizationUsecase(this._deliveryAuthorizationRepositories);

  Future<bool> run({required int deliveryId}) => _deliveryAuthorizationRepositories.cancelDeliveryAuthorization(deliveryId);
}
