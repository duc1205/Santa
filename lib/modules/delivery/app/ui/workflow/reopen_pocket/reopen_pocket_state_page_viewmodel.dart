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
import 'package:santapocket/modules/delivery/app/ui/workflow/result/success/reopen_pocket_complete_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/notify_close_pocket_dialog.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_reopen_request_status.dart';
import 'package:santapocket/modules/delivery/domain/enums/pocket_close_type.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_reopen_request_event.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/models/reopen_request.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_delivery_reopen_request_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class ReopenPocketStatePageViewModel extends AppViewModel {
  final GetDeliveryReopenRequestUsecase _getDeliveryReopenRequestUsecase;
  final EventBus _eventBus;

  StreamSubscription? _listenDeliveryStatusChanged;
  StreamSubscription? _listenPocketStatusChanged;

  ReopenPocketStatePageViewModel(
    this._getDeliveryReopenRequestUsecase,
    this._eventBus,
  );

  late CabinetInfo cabinetInfo;
  late Delivery delivery;
  late int reopenRequestId;

  bool isDialogShown = false;
  bool isDeliveryFinish = false;

  final _isOpened = Rx<bool>(false);

  bool get isOpened => _isOpened.value;

  void onPocketStatusChanged(Pocket pocket) {
    _isOpened(pocket.status == PocketStatus.opened);
  }

  @override
  void initState() {
    _registerEvent();
    super.initState();
  }

  @override
  void disposeState() {
    _listenDeliveryStatusChanged?.cancel();
    _listenPocketStatusChanged?.cancel();
  }

  Future<Unit> _registerEvent() async {
    _listenPocketStatusChanged = _eventBus.on<PocketStatusChangedEvent>().listen((event) {
      final isClosed = event.pocket.status == PocketStatus.closed;
      if (!isClosed) {
        onPocketStatusChanged(event.pocket);
      }
    });
    _listenDeliveryStatusChanged = _eventBus.on<DeliveryReopenRequestEvent>().listen((event) {
      switch (event.reopenRequest.status) {
        case DeliveryReopenRequestStatus.completed:
          Get.off(
            () => const ReopenPocketCompletePage(),
          );
          break;
        case DeliveryReopenRequestStatus.failed:
          Get.off(() => DeliveryFailedPage(
                cabinetInfo: cabinetInfo,
                deliveryId: event.reopenRequest.deliveryId,
              ));
          break;
        case DeliveryReopenRequestStatus.unknown:
        case DeliveryReopenRequestStatus.created:
        case DeliveryReopenRequestStatus.opening:
        case DeliveryReopenRequestStatus.opened:
      }
    });
    return unit;
  }

  void handleWhenAppPaused() {
    if (_listenDeliveryStatusChanged?.isPaused ?? true) {
      _listenDeliveryStatusChanged?.resume();
    }
    if (_listenPocketStatusChanged?.isPaused ?? true) {
      _listenPocketStatusChanged?.resume();
    }
  }

  Future<Unit> endProcess() async {
    if (!isDeliveryFinish) {
      ReopenRequest? reopenRequest;
      await showLoading();
      final success = await run(
        () async => reopenRequest = await _getDeliveryReopenRequestUsecase.run(reopenRequestId),
      );
      await hideLoading();
      if (success) {
        if (reopenRequest?.status == DeliveryReopenRequestStatus.completed) {
          await Get.off(
            () => const ReopenPocketCompletePage(),
          );
        } else if (reopenRequest?.status == DeliveryReopenRequestStatus.failed) {
          await Get.off(() => DeliveryFailedPage(
                cabinetInfo: cabinetInfo,
                deliveryId: delivery.id,
              ));
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
