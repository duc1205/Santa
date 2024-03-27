import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/delivery_authorization/data/datasources/delivery_authorization_datasource.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class DeliveryAuthorizationRepositories extends Repository {
  final DeliveryAuthorizationDatasource _deliveryAuthorizationDatasource;

  const DeliveryAuthorizationRepositories(this._deliveryAuthorizationDatasource);

  Future<List<DeliveryAuthorization>> getDeliveryAuthorizations() => _deliveryAuthorizationDatasource.getDeliveryAuthorizations();

  Future<DeliveryAuthorization> createDeliveryAuthorization({required int deliveryId, required String phoneNumber}) =>
      _deliveryAuthorizationDatasource.createDeliveryAuthorization(deliveryId: deliveryId, phoneNumber: phoneNumber);

  Future<DeliveryAuthorization> getDeliveryAuthorization(int id) => _deliveryAuthorizationDatasource.getDeliveryAuthorization(id);

  Future<DeliveryAuthorization> receiveDeliveryAuthorization(int id) => _deliveryAuthorizationDatasource.receiveDeliveryAuthorization(id);

  Future<List<DeliveryAuthorization>> getReceivableDeliveryAuthorizations({
    SortParams? sortParams,
    int? cabinetId,
  }) =>
      _deliveryAuthorizationDatasource.getReceivableDeliveryAuthorizations(
        sortParams: sortParams,
        cabinetId: cabinetId,
      );

  Future<Unit> notifyDeliveryAuthorizationReceiver(int id) => _deliveryAuthorizationDatasource.notifyDeliveryAuthorizationReceiver(id);

  Future<bool> cancelDeliveryAuthorization(int id) => _deliveryAuthorizationDatasource.cancelDeliveryAuthorization(id);
}
