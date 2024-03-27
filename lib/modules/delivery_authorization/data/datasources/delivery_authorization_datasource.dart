import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/delivery_authorization/data/datasources/services/delivery_authorization_service.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:suga_core/suga_core.dart';

abstract class DeliveryAuthorizationDatasource {
  Future<List<DeliveryAuthorization>> getDeliveryAuthorizations();

  Future<DeliveryAuthorization> createDeliveryAuthorization({required int deliveryId, required String phoneNumber});

  Future<DeliveryAuthorization> getDeliveryAuthorization(int id);

  Future<DeliveryAuthorization> receiveDeliveryAuthorization(int id);

  Future<List<DeliveryAuthorization>> getReceivableDeliveryAuthorizations({
    SortParams? sortParams,
    int? cabinetId,
  });

  Future<Unit> notifyDeliveryAuthorizationReceiver(int id);

  Future<bool> cancelDeliveryAuthorization(int id);
}

@LazySingleton(as: DeliveryAuthorizationDatasource)
class DeliveryAuthorizationDatasourceImpl extends DeliveryAuthorizationDatasource {
  final DeliveryAuthorizationService _deliveryAuthorizationService;

  DeliveryAuthorizationDatasourceImpl(this._deliveryAuthorizationService);

  @override
  Future<DeliveryAuthorization> createDeliveryAuthorization({
    required int deliveryId,
    required String phoneNumber,
  }) =>
      _deliveryAuthorizationService.createDeliveryAuthorization({
        "delivery_id": deliveryId,
        "phone_number": phoneNumber,
      });

  @override
  Future<DeliveryAuthorization> getDeliveryAuthorization(int id) => _deliveryAuthorizationService.getDeliveryAuthorization(id);

  @override
  Future<List<DeliveryAuthorization>> getDeliveryAuthorizations() => _deliveryAuthorizationService.getDeliveryAuthorizations();

  @override
  Future<DeliveryAuthorization> receiveDeliveryAuthorization(int id) => _deliveryAuthorizationService.receiveDeliveryAuthorization(id);

  @override
  Future<List<DeliveryAuthorization>> getReceivableDeliveryAuthorizations({
    SortParams? sortParams,
    int? cabinetId,
  }) =>
      _deliveryAuthorizationService.getReceivableDeliveryAuthorizations(
        sortParams?.attribute,
        sortParams?.direction,
        cabinetId,
      );

  @override
  Future<Unit> notifyDeliveryAuthorizationReceiver(int id) async {
    await _deliveryAuthorizationService.notifyDeliveryAuthorizationReceiver(id);
    return unit;
  }

  @override
  Future<bool> cancelDeliveryAuthorization(int id) {
    return _deliveryAuthorizationService.cancelDeliveryAuthorization(id);
  }
}
