import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_type.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_receivable_deliveries_usecase.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/delivery_authorization_detail/delivery_authorization_detail_page.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:santapocket/modules/delivery_authorization/domain/usecases/get_delivery_authorization_usecase.dart';
import 'package:santapocket/modules/delivery_authorization/domain/usecases/get_receivable_delivery_authorizations_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class ReceiveDeliveryAuthorizationSuccessPageViewModel extends AppViewModel {
  final GetReceivableDeliveriesUsecase _getReceivableDeliveriesUsecase;
  final GetReceivableDeliveryAuthorizationsUsecase _getReceivableDeliveryAuthorizationsUsecase;
  final GetDeliveryAuthorizationUsecase _getDeliveryAuthorizationUsecase;

  ReceiveDeliveryAuthorizationSuccessPageViewModel(
    this._getReceivableDeliveriesUsecase,
    this._getReceivableDeliveryAuthorizationsUsecase,
    this._getDeliveryAuthorizationUsecase,
  );

  final _canReceiveAnother = Rx<bool>(false);
  late int deliveryAuthorizationId;
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
    await showLoading();
    final success = await run(
      () async {
        receivableDeliveries = await _getReceivableDeliveriesUsecase.run(cabinetId: cabinetInfo.id);

        receivableDeliveryAuthorizations = await _getReceivableDeliveryAuthorizationsUsecase.run(cabinetId: cabinetInfo.id);
        await Future.delayed(
          const Duration(milliseconds: 500),
        );
      },
    );
    if (success) {
      _canReceiveAnother.value = receivableDeliveries.isNotEmpty || receivableDeliveryAuthorizations.isNotEmpty;
    }
    await hideLoading();
    return unit;
  }

  Future<Unit> onViewDetailClick() async {
    await run(() async {
      final deliveryAuthorizationDetail = await _getDeliveryAuthorizationUsecase.run(deliveryAuthorizationId);
      await Get.to(
        () => DeliveryAuthorizationDetailPage(
          deliveryAuthorizationId: deliveryAuthorizationId,
          isCharity: deliveryAuthorizationDetail.delivery?.type == DeliveryType.charity,
        ),
      );
    });
    return unit;
  }
}
