import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery_authorization/data/repositories/delivery_authorization_repositories.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class CreateDeliveryAuthorizationUsecase extends Usecase {
  final DeliveryAuthorizationRepositories _deliveryAuthorizationRepositories;

  const CreateDeliveryAuthorizationUsecase(this._deliveryAuthorizationRepositories);

  Future<DeliveryAuthorization> run({required int deliveryId, required String phoneNumber}) =>
      _deliveryAuthorizationRepositories.createDeliveryAuthorization(deliveryId: deliveryId, phoneNumber: phoneNumber);
}
