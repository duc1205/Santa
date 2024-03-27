import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/delivery_authorization/data/repositories/delivery_authorization_repositories.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';

@lazySingleton
class GetReceivableDeliveryAuthorizationsUsecase {
  final DeliveryAuthorizationRepositories _deliveryAuthorizationRepositories;

  GetReceivableDeliveryAuthorizationsUsecase(this._deliveryAuthorizationRepositories);

  Future<List<DeliveryAuthorization>> run({
    SortParams? sortParams,
    int? cabinetId,
  }) =>
      _deliveryAuthorizationRepositories.getReceivableDeliveryAuthorizations(
        sortParams: sortParams,
        cabinetId: cabinetId,
      );
}
