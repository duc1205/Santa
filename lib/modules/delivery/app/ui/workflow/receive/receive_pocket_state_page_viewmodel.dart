import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/cabinet/domain/enums/pocket_status.dart';
import 'package:santapocket/modules/cabinet/domain/events/pocket_status_changed_event.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket.dart';
import 'package:santapocket/modules/charity/app/ui/workflow/result/fail/charity_delivery_failed_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/result/success/receive_pocket_state_complete_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/notify_close_pocket_dialog.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_status.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_type.dart';
import 'package:santapocket/modules/delivery/domain/enums/pocket_close_type.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_status_changed_event.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_delivery_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class ReceivePocketStatePageViewModel extends AppViewModel {
  final GetDeliveryUsecase _getDeliveryUsecase;
  final EventBus _eventBus;

  ReceivePocketStatePageViewModel(
    this._getDeliveryUsecase,
    this._eventBus,
  );

  late CabinetInfo cabinetInfo;

  late int deliveryId;

  StreamSubscription? _listenDeliveryStatusChanged;
  StreamSubscription? _listenPocketStatusChanged;
  bool isDeliveryFinish = false;
  bool onClickFinishDelivery = false;

  final _delivery = Rx<Delivery?>(null);
  final _isOpened = Rx<bool>(false);

  Delivery? get delivery => _delivery.value;

  bool get isOpened => _isOpened.value;

  List<Delivery> receivableDeliveries = [];
  bool isDialogShown = false;

  @override
  void initState() {
    _getDelivery();
    _registerEvent();
    super.initState();
  }

  @override
  void disposeState() {
    _listenDeliveryStatusChanged?.cancel();
    _listenPocketStatusChanged?.cancel();
    super.disposeState();
  }

  Future<Unit> _getDelivery() async {
    late Delivery deliveryLoaded;
    await showLoading();
    final success = await run(
      () async => deliveryLoaded = await _getDeliveryUsecase.run(deliveryId),
    );
    if (success) {
      _delivery.value = deliveryLoaded;
    }
    await hideLoading();
    return unit;
  }

  void onDeliveryStatusChanged(Delivery del) {
    final Delivery? deliveryChanged = _delivery.value?.copyWith(receivingPrice: del.receivingPrice);
    _delivery.value = null;
    _delivery.value = deliveryChanged;
  }

  void onPocketStatusChanged(Pocket pocket) {
    _isOpened.value = pocket.status == PocketStatus.opened;
  }

  void _registerEvent() {
    bool listenOnce = false;
    _listenDeliveryStatusChanged = _eventBus.on<DeliveryStatusChangedEvent>().listen((event) {
      if (deliveryId == event.delivery.id) {
        // ignore: missing_enum_constant_in_switch
        switch (event.delivery.status) {
          case DeliveryStatus.receiving:
            onDeliveryStatusChanged(event.delivery);
            break;
          case DeliveryStatus.completed:
            // wait for Back-End
            if (!listenOnce) {
              listenOnce = true;
              isDeliveryFinish = true;
              Get.off(
                () => ReceivePocketStateCompletePage(
                  cabinetInfo: cabinetInfo,
                  deliveryId: deliveryId,
                  isCharity: delivery?.type == DeliveryType.charity,
                ),
              );
            }

            break;
          case DeliveryStatus.canceled:
          case DeliveryStatus.failed:
            if (!listenOnce) {
              listenOnce = true;
              isDeliveryFinish = true;
              Get.off(
                () => CharityDeliveryFailedPage(
                  cabinetInfo: cabinetInfo,
                  deliveryId: deliveryId,
                ),
              );
            }
            break;
        }
      }
    });
    _listenPocketStatusChanged = _eventBus.on<PocketStatusChangedEvent>().listen((event) {
      if (delivery?.pocketId == event.pocket.id) {
        onPocketStatusChanged(event.pocket);
      }
    });
  }

  String get pocketName => "${LocaleKeys.delivery_pocket.trans()} ${delivery?.extra?.pocketExtra?.localId ?? ""}";

  int? get getReceivePrice => delivery?.receivingPrice;

  int? get getCoinAmount => delivery?.coinAmount;

  Future<Unit> onClickEndProcess() async {
    if (!isDeliveryFinish) {
      late DeliveryStatus deliveryStatus;
      await showLoading();
      final success = await run(
        () async => deliveryStatus = (await _getDeliveryUsecase.run(deliveryId)).status,
      );
      await hideLoading();
      if (success) {
        if (deliveryStatus == DeliveryStatus.received || deliveryStatus == DeliveryStatus.completed) {
          await Get.off(
            () => ReceivePocketStateCompletePage(
              cabinetInfo: cabinetInfo,
              deliveryId: deliveryId,
              isCharity: delivery?.type == DeliveryType.charity,
            ),
          );
        } else if (deliveryStatus == DeliveryStatus.failed) {
          await Get.off(
            () => CharityDeliveryFailedPage(
              cabinetInfo: cabinetInfo,
              deliveryId: deliveryId,
            ),
          );
        } else {
          await Get.dialog(
            const NotifyClosePocketDialog(isDismissable: true, pocketCloseType: PocketCloseType.finish),
            barrierDismissible: false,
          );
        }
      }
    }
    return unit;
  }
}
