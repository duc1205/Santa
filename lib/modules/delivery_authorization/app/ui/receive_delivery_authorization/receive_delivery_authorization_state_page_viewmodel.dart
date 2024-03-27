import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/modules/cabinet/domain/enums/pocket_status.dart';
import 'package:santapocket/modules/cabinet/domain/events/pocket_status_changed_event.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/result/fail/delivery_failed_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/notify_close_pocket_dialog.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_status.dart';
import 'package:santapocket/modules/delivery/domain/enums/pocket_close_type.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_status_changed_event.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/result/receive_delivery_authorization_success_page.dart';
import 'package:santapocket/modules/delivery_authorization/domain/usecases/get_delivery_authorization_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class ReceiveDeliveryAuthorizationStatePageViewModel extends AppViewModel {
  final GetDeliveryAuthorizationUsecase _getDeliveryAuthorizationUsecase;
  final EventBus _eventBus;

  ReceiveDeliveryAuthorizationStatePageViewModel(
    this._getDeliveryAuthorizationUsecase,
    this._eventBus,
  );

  StreamSubscription? listenDeliveryStatusChanged;

  StreamSubscription? listenPocketStatusChanged;

  final _delivery = Rx<Delivery?>(null);
  final _isPocketOpen = Rx<bool>(false);

  late int deliveryAuthorizationId;
  late CabinetInfo cabinetInfo;
  late bool isCharity;

  Delivery? get delivery => _delivery.value;

  bool get isPocketOpen => _isPocketOpen.value;
  bool isDeliveryFinish = false;

  void onPocketStatusChanged(Pocket pocket) {
    _isPocketOpen.value = pocket.status == PocketStatus.opened;
  }

  @override
  void initState() {
    _getDelivery();
    _registerEvent();
    super.initState();
  }

  @override
  void disposeState() {
    listenDeliveryStatusChanged?.cancel();
    listenPocketStatusChanged?.cancel();
  }

  void _registerEvent() {
    listenDeliveryStatusChanged = _eventBus.on<DeliveryStatusChangedEvent>().listen((event) async {
      if (delivery?.id == event.delivery.id) {
        // ignore: missing_enum_constant_in_switch
        switch (event.delivery.status) {
          case DeliveryStatus.received:
            isDeliveryFinish = true;
            await Get.off(
              () => ReceiveDeliveryAuthorizationSuccessPage(
                cabinetInfo: cabinetInfo,
                deliveryAuthorizationId: deliveryAuthorizationId,
              ),
            );
            break;
          case DeliveryStatus.failed:
            isDeliveryFinish = true;
            await Get.off(
              () => DeliveryFailedPage(
                cabinetInfo: cabinetInfo,
                deliveryId: delivery!.id,
                isFromReceiveDelivery: true,
              ),
            );
            break;
        }
      }
    });
    listenPocketStatusChanged = _eventBus.on<PocketStatusChangedEvent>().listen((event) {
      if (delivery?.pocketId == event.pocket.id) {
        onPocketStatusChanged(event.pocket);
      }
    });
  }

  Future<Unit> _getDelivery() async {
    late Delivery? deliveryLoaded;
    await showLoading();
    final success = await run(
      () async => deliveryLoaded = (await _getDeliveryAuthorizationUsecase.run(deliveryAuthorizationId)).delivery,
    );
    if (success) {
      _delivery.value = deliveryLoaded;
    }
    await hideLoading();
    return unit;
  }

  Future<Unit> onClickEndProcess() async {
    if (!isDeliveryFinish) {
      late DeliveryStatus? status;
      await showLoading();
      final success = await run(
        () async => status = (await _getDeliveryAuthorizationUsecase.run(deliveryAuthorizationId)).delivery?.status,
      );
      await hideLoading();
      if (success) {
        if (status == DeliveryStatus.completed) {
          await Get.off(
            () => ReceiveDeliveryAuthorizationSuccessPage(
              cabinetInfo: cabinetInfo,
              deliveryAuthorizationId: deliveryAuthorizationId,
            ),
          );
        } else if (delivery?.status == DeliveryStatus.failed) {
          await Get.off(
            () => DeliveryFailedPage(
              cabinetInfo: cabinetInfo,
              deliveryId: delivery!.id,
              isFromReceiveDelivery: true,
            ),
          );
        } else {
          await Get.dialog(const NotifyClosePocketDialog(isDismissable: true, pocketCloseType: PocketCloseType.finish), barrierDismissible: false);
        }
        return unit;
      }
      return unit;
    }
    return unit;
  }
}
