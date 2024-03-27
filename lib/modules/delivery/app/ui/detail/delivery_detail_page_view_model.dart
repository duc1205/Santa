import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/core/helpers/loading_helper.dart';
import 'package:santapocket/deeplink/qr_code_manager.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_detail/cabinet_detail_page.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_maintenance/cabinet_maintenance_page.dart';
import 'package:santapocket/modules/cabinet/domain/enums/cabinet_status.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_cabinet_info_usecase.dart';
import 'package:santapocket/modules/delivery/app/ui/cancel/cancel_delivery_state_page.dart';
import 'package:santapocket/modules/delivery/app/ui/cancel/scan_wrong_cabinet/scan_wrong_cabinet_page.dart';
import 'package:santapocket/modules/delivery/app/ui/detail/widgets/reopen_pocket_widget.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/owner_package/widgets/balance_not_enough_receive_widget.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/receive_packages_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/receive_pocket_state_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/reopen_pocket/reopen_pocket_state_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/cancel_delivery_dialog.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/offline_dialog.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_status.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_type.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_receiver_changed_event.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_status_changed_event.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery_status_log.dart';
import 'package:santapocket/modules/delivery/domain/models/reopen_request.dart';
import 'package:santapocket/modules/delivery/domain/usecases/cancel_sent_delivery_usecase.dart';
import 'package:santapocket/modules/delivery/domain/usecases/check_delivery_reopenable_usecase.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_charity_delivery_usecase.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_delivery_usecase.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_estimate_final_receiving_price_usecase.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_receivable_deliveries_usecase.dart';
import 'package:santapocket/modules/delivery/domain/usecases/receive_delivery_usecase.dart';
import 'package:santapocket/modules/delivery/domain/usecases/reopen_pocket_usecase.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/authorize/authorize_delivery_dialog.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/authorize/widgets/cancel_authorized_dialog.dart';
import 'package:santapocket/modules/delivery_authorization/domain/enums/delivery_authorization_status.dart';
import 'package:santapocket/modules/delivery_authorization/domain/events/authorize_delivery_successful_event.dart';
import 'package:santapocket/modules/delivery_authorization/domain/usecases/cancel_delivery_authorization_usecase.dart';
import 'package:santapocket/modules/main/app/ui/widgets/qr_scanner_page.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/retrofit/rest_error.dart';
import 'package:suga_core/suga_core.dart';
import 'package:suga_core/suga_core.dart' hide BaseViewModel;

@injectable
class DeliveryDetailPageViewModel extends AppViewModel {
  final GetDeliveryUsecase _getDeliveryUsecase;
  final GetCharityDeliveryUsecase _getCharityDeliveryUsecase;
  final GetProfileUsecase _getProfileUsecase;
  final ReceiveDeliveryUsecase _receiveDeliveryUsecase;
  final GetSettingUsecase _getSettingUsecase;
  final GetCabinetInfoUsecase _getCabinetInfoUsecase;
  final GetReceivableDeliveriesUsecase _getReceivableDeliveriesUsecase;
  final GetEstimateFinalReceivingPriceUsecase _getEstimateFinalReceivingPriceUsecase;
  final CancelDeliveryAuthorizationUsecase _cancelDeliveryAuthorizationUsecase;
  final CancelSentDeliveryUsecase _cancelSentDeliveryUsecase;
  final CheckDeliveryReopenableUsecase _checkDeliveryReopenableUsecase;
  final ReopenPocketUsecase _reopenPocketUsecase;
  final EventBus _eventBus;

  DeliveryDetailPageViewModel(
    this._getDeliveryUsecase,
    this._getCharityDeliveryUsecase,
    this._getProfileUsecase,
    this._receiveDeliveryUsecase,
    this._getSettingUsecase,
    this._getCabinetInfoUsecase,
    this._getReceivableDeliveriesUsecase,
    this._getEstimateFinalReceivingPriceUsecase,
    this._cancelDeliveryAuthorizationUsecase,
    this._cancelSentDeliveryUsecase,
    this._checkDeliveryReopenableUsecase,
    this._reopenPocketUsecase,
    this._eventBus,
  );

  late int deliveryId;
  late bool isCharity;
  final _delivery = Rx<Delivery?>(null);
  final _statusLogs = Rx<List<DeliveryStatusLog>>([]);
  final _currentUser = Rx<User?>(null);
  final _countDown = 0.obs;
  final _isDeliveryReopenable = RxBool(false);
  bool _isCabinetOffline = false;
  final _bankTransferInfo = Rx<Map<String, dynamic>>({});

  Timer? _timer;

  StreamSubscription? _listenDeliveryStatusChanged;
  StreamSubscription? _listenDeliveryReceiverChanged;

  Delivery? get delivery => _delivery.value;

  User? get currentUser => _currentUser.value;

  List<DeliveryStatusLog> get statusLogs => _statusLogs.value;

  int get countDown => _countDown.value;

  String get senderName => (delivery?.sender?.name != null && delivery!.sender!.name!.trim().isNotEmpty) ? "(${delivery?.sender?.name})" : "";

  String get receiverName => (delivery?.receiver?.name != null && delivery!.receiver!.name!.trim().isNotEmpty) ? "(${delivery?.receiver?.name})" : "";

  String get authorizationName => (delivery?.authorization?.user?.name != null && delivery!.authorization!.user!.name!.trim().isNotEmpty)
      ? "(${delivery?.authorization?.user?.name})"
      : "";

  bool get isDeliveryReOpenable => _isDeliveryReopenable.value;

  Map<String, dynamic> get bankTransferInfo => _bankTransferInfo.value;

  bool get isShowCharityInfo => delivery?.charity != null || delivery?.charityCampaign != null;

  bool isShowReopenButton() =>
      ([DeliveryStatus.canceled, DeliveryStatus.failed, DeliveryStatus.completed].any((status) => delivery?.status == status) &&
          currentUser?.id == delivery?.receiverId);

  bool checkHadAuthorize() {
    final deliveryAuthorization = delivery?.authorization;
    return deliveryAuthorization != null && deliveryAuthorization.status != DeliveryAuthorizationStatus.canceled;
  }

  bool checkCanCancelAuthorize() {
    final deliveryAuthorization = delivery?.authorization;
    return deliveryAuthorization != null &&
        deliveryAuthorization.status == DeliveryAuthorizationStatus.created &&
        delivery?.status == DeliveryStatus.sent;
  }

  bool get isReceivedByAuthorization => delivery?.authorization?.isReceived == true;

  bool isReceivedByReceiver() {
    if (isReceivedByAuthorization) {
      return false;
    }
    return delivery?.status == DeliveryStatus.completed;
  }

  String? get authorizedPerson {
    if (delivery?.authorization == null) {
      return null;
    } else if (isReceiver) {
      return LocaleKeys.delivery_authorized_receiver_package.trans(
        namedArgs: {
          "phoneNumber": delivery?.authorization?.user?.displayPhoneNumberAndName ?? "",
        },
      );
    } else {
      return LocaleKeys.delivery_authorized_by.trans(
        namedArgs: {
          "phoneNumber": delivery?.authorization?.user?.displayPhoneNumberAndName ?? "",
        },
      );
    }
  }

  String getAuthorizedInfo() {
    final deliveryAuthorization = delivery?.authorization;
    return deliveryAuthorization == null
        ? ""
        : LocaleKeys.delivery_authorized_info_detail
            .trans(namedArgs: {"userPhoneAndName": deliveryAuthorization.user?.displayPhoneNumberAndName ?? ""});
  }

  bool get isReceiver => delivery?.receiverId == currentUser?.id;

  bool get deliveryReceived => delivery?.status == DeliveryStatus.completed || delivery?.status == DeliveryStatus.received;

  bool get deliveryCanceled => delivery?.status == DeliveryStatus.canceled || delivery?.status == DeliveryStatus.failed;

  @override
  void disposeState() {
    _timer?.cancel();
    _listenDeliveryStatusChanged?.cancel();
    _listenDeliveryReceiverChanged?.cancel();
    super.disposeState();
  }

  @override
  void initState() {
    _fetchData();
    _initListener();
    super.initState();
  }

  void _initListener() {
    _listenDeliveryStatusChanged = locator<EventBus>().on<DeliveryStatusChangedEvent>().listen((event) {
      _fetchData();
    });
    _listenDeliveryReceiverChanged = locator<EventBus>().on<DeliveryReceiverChangedEvent>().listen((event) {
      _fetchData();
    });
  }

  Future<Unit> _initCountDown() async {
    final unwrapDelivery = delivery;
    if (unwrapDelivery != null) {
      final limitCountDownSetting = int.tryParse((await _getSettingUsecase.run(Constants.senderCancelDeliveryDuration)).value.toString());
      if (limitCountDownSetting != null) {
        final limitCountDown = limitCountDownSetting * 60;
        final now = DateTime.now();
        final delta = now.difference(unwrapDelivery.createdAt).inSeconds;
        _countDown.value = delta >= limitCountDown ? 0 : limitCountDown - delta;
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (countDown <= 0) {
            timer.cancel();
          } else {
            _countDown.value--;
          }
        });
      }
    }
    return unit;
  }

  String countDownString() {
    final formatter = NumberFormat("00");
    final minute = (countDown / 60).floor();
    final second = (countDown % 60);
    return "$minute:${formatter.format(second)}";
  }

  void navigateCabinetDetail() {
    if (delivery?.cabinet != null) {
      Get.to(() => CabinetDetailPage(cabinetId: delivery!.cabinet!.id));
    }
  }

  Future<Unit> _fetchData() async {
    late Delivery deliveryLoaded;
    late User userLoaded;
    late Map<String, dynamic> bankTransferInfoLoaded;
    await showLoading();
    final success = await run(
      () async {
        deliveryLoaded = isCharity ? await _getCharityDeliveryUsecase.run(deliveryId) : await _getDeliveryUsecase.run(deliveryId);
        userLoaded = await _getProfileUsecase.run();
        final bankTransferInfoFetched = (await _getSettingUsecase.run(Constants.appBankTransferInfo)).value;
        if (bankTransferInfoFetched is Map<String, dynamic>) {
          bankTransferInfoLoaded = bankTransferInfoFetched;
        }
      },
    );
    if (success) {
      _delivery.value = null;
      _delivery(deliveryLoaded);
      _currentUser(userLoaded);
      _statusLogs.value = deliveryLoaded.statusLogs ?? [];
      _bankTransferInfo.value = bankTransferInfoLoaded;
      await _initCountDown();
    }
    await checkDeliveryReOpenable();
    await hideLoading();
    return unit;
  }

  Future<Unit> onRefresh() => _fetchData();

  Future<Unit> showAuthorizeDialog() async {
    final bool? authorizedSuccess = await Get.dialog(
      AuthorizeDeliveryDialog(
        cabinetName: delivery?.cabinet?.name ?? "",
        delivery: delivery!,
      ),
    );
    if (authorizedSuccess == true) {
      _eventBus.fire(const AuthorizeDeliverySuccessfulEvent());
      await _fetchData();
    }
    return unit;
  }

  Future<bool> checkCanReceive(CabinetInfo cabinetInfo, Delivery delivery) async {
    await showLoading();
    var receivableDeliveries = <Delivery>[];
    await run(() async {
      receivableDeliveries = await _getReceivableDeliveriesUsecase.run(cabinetId: cabinetInfo.id);
    });
    await hideLoading();
    return receivableDeliveries.isNotEmpty ? receivableDeliveries.any((element) => delivery.id == element.id) : false;
  }

  Future<Unit> receiveDelivery() async {
    final cabinetInfo = await _getCabinetInfo();
    if (cabinetInfo != null) {
      final unwrapDelivery = delivery;
      if (unwrapDelivery != null) {
        await showLoading();
        final canReceived = await checkCanReceive(cabinetInfo, unwrapDelivery);
        if (canReceived) {
          await showLoading();
          final success = await run(
            () => _receiveDeliveryUsecase.run(unwrapDelivery.id, false),
          );
          await hideLoading();
          if (success) {
            await hideLoading();
            await Get.to(
              () => ReceivePocketStatePage(
                cabinetInfo: cabinetInfo,
                deliveryId: unwrapDelivery.id,
              ),
            );
          } else {
            if (_isCabinetOffline) {
              await hideLoading();
              await Get.dialog(
                OfflineDialog(
                  cabinetInfo: cabinetInfo,
                  onConfirm: () => Get.back(),
                ),
              );
              _isCabinetOffline = false;
            }
          }
        } else {
          await hideLoading();
          await Get.to(
            () => ReceivePackagesPage(
              cabinetInfo: cabinetInfo,
            ),
          );
        }
        await hideLoading();
      }
    }
    return unit;
  }

  void onCancelAuthorizedClicked() {
    Get.dialog(
      CancelAuthorizedDialog(
        onConfirmCancel: () async {
          final success = await _cancelAuthorized();
          if (success) {
            await onRefresh();
            Get.back();
          }
          return unit;
        },
      ),
    );
  }

  void onCancelDeliveryClicked() {
    Get.dialog(
      CancelDeliveryDialog(
        onConfirmCancel: () async {
          final cabinetInfo = await _getCabinetInfo();
          if (cabinetInfo != null) {
            await _cancelDelivery(cabinetInfo);
          }
          Get.back();
          return unit;
        },
      ),
    );
  }

  Future<Unit> _cancelDelivery(CabinetInfo cabinetInfo) async {
    final unwrapDelivery = delivery;
    if (unwrapDelivery != null) {
      if (cabinetInfo.id == unwrapDelivery.cabinet?.id) {
        await showLoading();
        final success = await run(
          () => _cancelSentDeliveryUsecase.run(deliveryId: deliveryId, cabinetId: cabinetInfo.id),
        );
        await hideLoading();
        if (success) {
          await Get.off(
            CancelDeliveryStatePage(
              cabinetInfo: cabinetInfo,
              deliveryId: unwrapDelivery.id,
            ),
          );
        }
      } else {
        await Get.to(
          const ScanWrongCabinetPage(),
        );
      }
    }
    return unit;
  }

  Future<bool> _cancelAuthorized() async {
    final authorizationId = delivery?.authorization?.id;
    if (authorizationId == null) {
      return false;
    } else {
      await showLoading();
      final success = await run(() => _cancelDeliveryAuthorizationUsecase.run(deliveryId: authorizationId));
      await hideLoading();
      return success;
    }
  }

  Future<CabinetInfo?> _getCabinetInfo() async {
    final barcode = await Get.to(
      () => const QRScannerPage(),
    );
    final status = await QrCodeManager.instance.parseQrData(barcode);
    if (status is ValidQrStatus) {
      final CabinetInfo cabinetInfo = await _getCabinetInfoUsecase.run(uuid: status.uuid!, otp: status.otp);
      if (cabinetInfo.isOnline) {
        switch (cabinetInfo.status) {
          case CabinetStatus.production:
            return cabinetInfo;
          case CabinetStatus.maintenance:
            await Get.to(
              () => CabinetMaintenancePage(
                cabinetName: cabinetInfo.name,
              ),
            );
            break;
          case CabinetStatus.unknown:
          case CabinetStatus.inStock:
            break;
          default:
            break;
        }
      } else {
        await Get.to(
          () => CabinetMaintenancePage(
            cabinetName: cabinetInfo.name,
          ),
        );
      }
    } else if (status is InValidQrStatus) {
      showToast(LocaleKeys.delivery_wrong_qr_code.trans());
    } else if (status is SurpriseQrStatus) {
      showToast(LocaleKeys.delivery_wrong_qr_code.trans());
    }
    return null;
  }

  @override
  Future<Unit> handleRestError(RestError restError, String? errorCode) async {
    switch (errorCode) {
      case Constants.errorCodeNotEnoughBalanceToReceive:
        await _showBottomSheetBalanceNotEnoughReceive();
        break;
      case Constants.errorCodeCabinetDisconnected:
        _isCabinetOffline = true;
        break;
      case Constants.errorCodeDeliveryInvalid:
        Get.back();
        showToast(restError.getError());
        break;
      default:
        await super.handleRestError(restError, errorCode);
    }
    return unit;
  }

  Future<Unit> _showBottomSheetBalanceNotEnoughReceive() async {
    await locator<LoadingHelper>().clear();
    await Get.bottomSheet(
      BalanceNotEnoughReceiveWidget(
        phoneHotLine: bankTransferInfo["contacts"]["call"]["value"],
        zaloUri: bankTransferInfo["contacts"]["zalo"]["value"],
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
    );
    return unit;
  }

  Future<Unit> showReopenPocketDialog() async {
    await Get.dialog(
      ReopenPocketWidget(
        delivery: delivery,
        callBack: reopenPocket,
      ),
    );
    return unit;
  }

  Future<Unit> reopenPocket() async {
    final cabinetInfo = await _getCabinetInfo();
    if (cabinetInfo != null) {
      if (cabinetInfo.status == CabinetStatus.maintenance) {
        await Get.to(
          () => CabinetMaintenancePage(
            cabinetName: cabinetInfo.name,
          ),
        );
        return unit;
      }
      if (!cabinetInfo.isOnline) {
        await Get.dialog(
          OfflineDialog(
            cabinetInfo: cabinetInfo,
            onConfirm: () => Get.back(),
          ),
        );
        return unit;
      }
      final unwrapDelivery = delivery;

      if (unwrapDelivery != null && isDeliveryReOpenable) {
        await showLoading();
        ReopenRequest? reopenRequest;
        final success = await run(
          () async => reopenRequest = await _reopenPocketUsecase.run(deliveryId: unwrapDelivery.id, cabinetId: cabinetInfo.id),
        );
        await hideLoading();
        if (success) {
          await hideLoading();
          await Get.to(
            ReopenPocketStatePage(
              cabinetInfo: cabinetInfo,
              delivery: unwrapDelivery,
              reopenRequestId: reopenRequest?.id as int,
              isCharity: unwrapDelivery.type == DeliveryType.charity,
            ),
          );
        } else {
          await checkDeliveryReOpenable();
          if (_isCabinetOffline) {
            await hideLoading();
            await Get.dialog(
              OfflineDialog(
                cabinetInfo: cabinetInfo,
                onConfirm: () => Get.back(),
              ),
            );
            _isCabinetOffline = false;
          }
        }
      }
    }
    return unit;
  }

  Future<int> getEstimateFinalReceivingPrice() async {
    int finalPrice = 0;
    await showLoading();
    await run(
      () async => finalPrice = await _getEstimateFinalReceivingPriceUsecase.run(deliveryId),
    );
    await hideLoading();
    return finalPrice;
  }

  Future<Unit> checkDeliveryReOpenable() async {
    await showLoading();
    await run(
      () async {
        final fetched = await _checkDeliveryReopenableUsecase.run(deliveryId);
        _isDeliveryReopenable.value = fetched;
      },
    );
    await hideLoading();
    return unit;
  }
}
