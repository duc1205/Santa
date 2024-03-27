import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/delivery_authorization/data/repositories/delivery_authorization_repositories.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';

@lazySingleton
class GetDeliveryAuthorizationsUsecase {
  final DeliveryAuthorizationRepositories _deliveryAuthorizationRepositories;

  GetDeliveryAuthorizationsUsecase(this._deliveryAuthorizationRepositories);

  Future<List<DeliveryAuthorization>> run() => _deliveryAuthorizationRepositories.getDeliveryAuthorizations();
}
