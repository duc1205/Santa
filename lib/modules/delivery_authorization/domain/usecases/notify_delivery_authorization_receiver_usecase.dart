import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery_authorization/data/repositories/delivery_authorization_repositories.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class NotifyDeliveryAuthorizationReceiverUsecase extends Usecase {
  final DeliveryAuthorizationRepositories _deliveryAuthorizationRepositories;

  const NotifyDeliveryAuthorizationReceiverUsecase(this._deliveryAuthorizationRepositories);

  Future<Unit> run(int id) => _deliveryAuthorizationRepositories.notifyDeliveryAuthorizationReceiver(id);
}
