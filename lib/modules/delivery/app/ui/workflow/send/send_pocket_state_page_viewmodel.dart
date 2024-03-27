import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/modules/cabinet/domain/enums/pocket_status.dart';
import 'package:santapocket/modules/cabinet/domain/events/delivery_pocket_size_changed_event.dart';
import 'package:santapocket/modules/cabinet/domain/events/pocket_status_changed_event.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket_size.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_pocket_sizes_usecase.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/result/fail/delivery_failed_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/result/success/cancel_sending_delivery_success_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/result/success/pocket_send_complete_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/notify_close_pocket_dialog.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/pocket_state/bottom_sheet/change_pocket_size_bottom_sheet.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/pocket_state/dialog/cancel_sending_delivery_dialog.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_status.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_type.dart';
import 'package:santapocket/modules/delivery/domain/enums/pocket_close_type.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_status_changed_event.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/usecases/cancel_delivery_usecase.dart';
import 'package:santapocket/modules/delivery/domain/usecases/change_pocket_size_usecase.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_delivery_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class SendPocketStatePageViewModel extends AppViewModel {
  final GetDeliveryUsecase _getDeliveryUsecase;
  final CancelDeliveryUsecase _cancelDeliveryUsecase;
  final GetPocketSizesUsecase _getPocketSizesUsecase;
  final ChangePocketSizeUsecase _changePocketSizeUsecase;
  final EventBus _eventBus;

  StreamSubscription? _listenDeliveryStatusChanged;
  StreamSubscription? _listenPocketStatusChanged;
  StreamSubscription? _listenPocketSizeChanged;

  SendPocketStatePageViewModel(
    this._getDeliveryUsecase,
    this._cancelDeliveryUsecase,
    this._getPocketSizesUsecase,
    this._changePocketSizeUsecase,
    this._eventBus,
  );

  late CabinetInfo cabinetInfo;
  late int deliveryId;

  bool isDialogShown = false;
  bool isDeliveryFinish = false;
  bool isCanceled = false;

  final _isOpened = Rx<bool>(false);
  final _cancelable = Rx<bool>(false);
  final _delivery = Rx<Delivery?>(null);
  final _pocketSizes = Rx<List<PocketSize>?>([]);

  bool get cancelable => _cancelable.value;

  bool get isOpened => _isOpened.value;

  Delivery? get delivery => _delivery.value;

  List<PocketSize>? get pocketSizes => _pocketSizes.value;

  void onPocketStatusChanged(Pocket pocket) {
    _isOpened(pocket.status == PocketStatus.opened);
  }

  @override
  void initState() {
    _getDelivery();
    _getPocketSizes();
    _registerEvent();
    super.initState();
  }

  @override
  void disposeState() {
    _listenDeliveryStatusChanged?.cancel();
    _listenPocketStatusChanged?.cancel();
    _listenPocketSizeChanged?.cancel();
  }

  Future<bool> _getPocketSizes() async {
    late List<PocketSize>? pocketSizesLoaded;
    final success = await run(
      () async {
        pocketSizesLoaded = await _getPocketSizesUsecase.run(cabinetInfo.id);
      },
    );
    if (success) {
      _pocketSizes.value = null;
      _pocketSizes.value = pocketSizesLoaded;
    }
    return success;
  }

  Future<bool> _getDelivery() async {
    late Delivery deliveryLoaded;
    await showLoading();
    final success = await run(
      () async => deliveryLoaded = await _getDeliveryUsecase.run(deliveryId),
    );
    await hideLoading();
    if (success) {
      _delivery.value = null;
      _delivery.value = deliveryLoaded;
    }
    return success;
  }

  Future<Unit> _registerEvent() async {
    _listenPocketStatusChanged = _eventBus.on<PocketStatusChangedEvent>().listen((event) {
      final isClosed = event.pocket.status == PocketStatus.closed;
      if (isClosed && isCanceled) {
        Get.off(() => const CancelSendingDeliverySuccessPage());
      } else {
        onPocketStatusChanged(event.pocket);
      }
    });
    _listenDeliveryStatusChanged = _eventBus.on<DeliveryStatusChangedEvent>().listen((event) {
      if (event.delivery.id == deliveryId) {
        // ignore: missing_enum_constant_in_switch
        switch (event.delivery.status) {
          case DeliveryStatus.sent:
            isDeliveryFinish = true;
            Get.off(
              () => PocketSendCompletePage(
                cabinetInfo: cabinetInfo,
                deliveryId: deliveryId,
                isCharity: delivery?.type == DeliveryType.charity,
              ),
            );
            break;
          case DeliveryStatus.failed:
            isDeliveryFinish = true;
            Get.off(
              () => DeliveryFailedPage(
                cabinetInfo: cabinetInfo,
                deliveryId: deliveryId,
                isFromReceiveDelivery: false,
              ),
            );
            break;
          case DeliveryStatus.sending:
            _cancelable.value = true;
            break;
        }
      }
    });
    _listenPocketSizeChanged = _eventBus.on<DeliveryPocketSizeChangedEvent>().listen((event) {
      _isOpened(true);
      _getPocketSizes();
      _getDelivery();
      Get.back();
    });
    return unit;
  }

  void showCancelSendingDialog() {
    Get.dialog(
      CancelSendingDeliveryDialog(
        onConfirmButtonClicked: cancelDelivery,
      ),
    );
  }

  void showChangePocketSize() {
    if (!isDeliveryFinish) {
      Get.bottomSheet(
        Obx(
          () => ChangePocketSizeBottomSheet(
            onSubmit: (pocketSize) {
              Get.back();
              changePocketSize(deliveryId, pocketSize);
            },
            pocketSizes: pocketSizes ?? [],
            selectedPocketSizeIndex: -1,
            selectedPocketSizeId: delivery?.pocket?.sizeId ?? 0,
          ),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
      );
    }
  }

  Future<bool> cancelDelivery() async {
    Get.back();
    late bool cancel;
    await showLoading();
    final success = await run(
      () async => cancel = await _cancelDeliveryUsecase.run(deliveryId),
    );
    await hideLoading();
    if (success) {
      isCanceled = cancel;
      await Get.dialog(
        const NotifyClosePocketDialog(isDismissable: true, pocketCloseType: PocketCloseType.cancel),
        barrierDismissible: false,
      );
    }
    return success;
  }

  void handleWhenAppPaused() {
    if (_listenDeliveryStatusChanged?.isPaused ?? true) {
      _listenDeliveryStatusChanged?.resume();
    }
    if (_listenPocketStatusChanged?.isPaused ?? true) {
      _listenPocketStatusChanged?.resume();
    }
    if (_listenPocketSizeChanged?.isPaused ?? true) {
      _listenPocketSizeChanged?.resume();
    }
  }

  Future<Unit> endProcess() async {
    if (!isDeliveryFinish) {
      late DeliveryStatus deliveryStatus;
      await showLoading();
      final success = await run(
        () async => deliveryStatus = (await _getDeliveryUsecase.run(deliveryId)).status,
      );
      await hideLoading();
      if (success) {
        if (deliveryStatus == DeliveryStatus.sent) {
          await Get.off(
            () => PocketSendCompletePage(
              cabinetInfo: cabinetInfo,
              deliveryId: deliveryId,
              isCharity: delivery?.type == DeliveryType.charity,
            ),
          );
        } else if (deliveryStatus == DeliveryStatus.failed) {
          await Get.off(
            () => DeliveryFailedPage(
              cabinetInfo: cabinetInfo,
              deliveryId: deliveryId,
              isFromReceiveDelivery: false,
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

  Future<Unit> changePocketSize(int deliveryId, PocketSize pocketSize) async {
    await showLoading();
    await run(
      () async {
        if (delivery?.pocket?.sizeId != pocketSize.id) {
          // ignore: unawaited_futures
          Get.dialog(
            const NotifyClosePocketDialog(isDismissable: false, pocketCloseType: PocketCloseType.changePocketSize),
            barrierDismissible: false,
          );
          await _changePocketSizeUsecase.run(deliveryId, pocketSize);
        }
      },
    );
    await hideLoading();
    return unit;
  }
}
