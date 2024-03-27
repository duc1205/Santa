import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_receivable_deliveries_usecase.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:santapocket/modules/delivery_authorization/domain/usecases/get_receivable_delivery_authorizations_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class ReceivePocketStateCompletePageViewModel extends AppViewModel {
  final GetReceivableDeliveriesUsecase _getReceivableDeliveriesUsecase;
  final GetReceivableDeliveryAuthorizationsUsecase _getReceivableDeliveryAuthorizationsUsecase;

  ReceivePocketStateCompletePageViewModel(
    this._getReceivableDeliveriesUsecase,
    this._getReceivableDeliveryAuthorizationsUsecase,
  );

  final _canReceiveAnother = Rx<bool>(false);
  late int deliveryID;
  late CabinetInfo cabinetInfo;

  bool get canReceiveAnother => _canReceiveAnother.value;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<Unit> _fetchData() async {
    late List<Delivery> receivableDeliveries;
    late List<DeliveryAuthorization> receivableDeliveryAuthorizations;
    final success = await run(
      () async {
        receivableDeliveries = await _getReceivableDeliveriesUsecase.run(cabinetId: cabinetInfo.id);
        receivableDeliveryAuthorizations = await _getReceivableDeliveryAuthorizationsUsecase.run(cabinetId: cabinetInfo.id);
      },
    );
    if (success) {
      _canReceiveAnother.value = receivableDeliveries.isNotEmpty || receivableDeliveryAuthorizations.isNotEmpty;
    }
    return unit;
  }
}
