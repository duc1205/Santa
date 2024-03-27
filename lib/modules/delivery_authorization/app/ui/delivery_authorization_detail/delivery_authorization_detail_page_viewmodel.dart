import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/deeplink/qr_code_manager.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_detail/cabinet_detail_page.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_maintenance/cabinet_maintenance_page.dart';
import 'package:santapocket/modules/cabinet/domain/enums/cabinet_status.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_cabinet_info_usecase.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/receive_packages_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/offline_dialog.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_status.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery_status_log.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_estimate_final_receiving_price_usecase.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/receive_delivery_authorization/receive_delivery_authorization_state_page.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/receive_delivery_authorization/widgets/notice_user_not_enough_balance_to_receive_widget.dart';
import 'package:santapocket/modules/delivery_authorization/data/repositories/delivery_authorization_repositories.dart';
import 'package:santapocket/modules/delivery_authorization/domain/enums/delivery_authorization_status.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:santapocket/modules/delivery_authorization/domain/usecases/get_delivery_authorization_usecase.dart';
import 'package:santapocket/modules/delivery_authorization/domain/usecases/get_receivable_delivery_authorizations_usecase.dart';
import 'package:santapocket/modules/delivery_authorization/domain/usecases/notify_delivery_authorization_receiver_usecase.dart';
import 'package:santapocket/modules/main/app/ui/widgets/qr_scanner_page.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/retrofit/rest_error.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class DeliveryAuthorizationDetailPageViewModel extends AppViewModel {
  final GetDeliveryAuthorizationUsecase _getDeliveryAuthorizationUsecase;
  final GetCabinetInfoUsecase _getCabinetInfoUsecase;
  final GetReceivableDeliveryAuthorizationsUsecase _getReceivableDeliveriesUsecase;
  final GetEstimateFinalReceivingPriceUsecase _getEstimateFinalReceivingPriceUsecase;
  final DeliveryAuthorizationRepositories _receiveDeliveryUsecase;
  final GetSettingUsecase _getSettingUsecase;
  final GetProfileUsecase _getProfileUsecase;
  final NotifyDeliveryAuthorizationReceiverUsecase _notifyDeliveryAuthorizationReceiverUsecase;

  DeliveryAuthorizationDetailPageViewModel(
    this._getDeliveryAuthorizationUsecase,
    this._getCabinetInfoUsecase,
    this._getReceivableDeliveriesUsecase,
    this._getEstimateFinalReceivingPriceUsecase,
    this._receiveDeliveryUsecase,
    this._getSettingUsecase,
    this._getProfileUsecase,
    this._notifyDeliveryAuthorizationReceiverUsecase,
  );

  late int deliveryAuthorizationId;
  late bool isCharity;
  final _delivery = Rx<Delivery?>(null);
  final _user = Rx<User?>(null);
  final _statusLogs = Rx<List<DeliveryStatusLog>>([]);
  final _bankTransferInfo = Rx<Map<String, dynamic>>({});

  User? get user => _user.value;

  Delivery? get delivery => _delivery.value;

  List<DeliveryStatusLog> get statusLogs => _statusLogs.value;

  String get senderName => (delivery?.sender?.name != null && delivery!.sender!.name!.trim().isNotEmpty) ? "(${delivery?.sender?.name})" : "";

  String get receiverName => (delivery?.receiver?.name != null && delivery!.receiver!.name!.trim().isNotEmpty) ? "(${delivery?.receiver?.name})" : "";

  String get authorizationName => (user?.name != null && user!.name!.trim().isNotEmpty) ? "(${user?.name})" : "";

  String get authorizedPerson => LocaleKeys.delivery_authorization_authorized_by.trans(
        namedArgs: {
          "phoneNumber": delivery?.receiver?.displayPhoneNumberAndName ?? "",
        },
      );

  String get proxyPerson {
    String s = user?.phoneNumber ?? "";
    if (user?.name?.isNotEmpty ?? false) {
      s += " (${user?.name})";
    }
    return s;
  }

  Map<String, dynamic> get bankTransferInfo => _bankTransferInfo.value;

  bool get isShowCharityInfo => delivery?.charity != null || delivery?.charityCampaign != null;

  bool _isCabinetOffline = false;

  bool checkIsDeliveryAuthorizationCompleted() {
    return (delivery?.authorization?.status == DeliveryAuthorizationStatus.received || delivery?.authorization?.status == null);
  }

  void navigateCabinetDetail() {
    if (delivery?.cabinet != null) {
      Get.to(() => CabinetDetailPage(cabinetId: delivery!.cabinet!.id));
    }
  }

  bool get deliveryReceived => delivery?.status == DeliveryStatus.completed || delivery?.status == DeliveryStatus.received;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<Unit> fetchData() async {
    late Delivery? deliveryLoaded;
    late Map<String, dynamic> bankTransferInfoLoaded;
    await showLoading();
    final success = await run(
      () async {
        deliveryLoaded = (await _getDeliveryAuthorizationUsecase.run(deliveryAuthorizationId)).delivery;
        final bankTransferInfoFetched = (await _getSettingUsecase.run(Constants.appBankTransferInfo)).value;
        if (bankTransferInfoFetched is Map<String, dynamic>) {
          bankTransferInfoLoaded = bankTransferInfoFetched;
        }
      },
    );
    if (success) {
      _delivery.value = deliveryLoaded;
      _statusLogs.value = deliveryLoaded?.statusLogs ?? [];
      _bankTransferInfo.value = bankTransferInfoLoaded;
    }
    await _getProfile();
    await hideLoading();
    return unit;
  }

  Future<Unit> _getProfile() async {
    await run(() async {
      final fetched = await _getProfileUsecase.run();
      _user.value = fetched;
    });
    return unit;
  }

  Future<Unit> onRefresh() {
    return fetchData();
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
      showToast(LocaleKeys.delivery_authorization_wrong_qr_code.trans());
    }
    return null;
  }

  Future<bool> checkCanReceive(CabinetInfo cabinetInfo, Delivery delivery) async {
    await showLoading();
    var receivableDeliveries = <DeliveryAuthorization>[];
    await run(() async {
      receivableDeliveries = await _getReceivableDeliveriesUsecase.run(cabinetId: cabinetInfo.id);
    });
    await hideLoading();
    return receivableDeliveries.isNotEmpty ? receivableDeliveries.any((element) => delivery.id == element.deliveryId) : false;
  }

  Future<int> getEstimateFinalReceivingPrice() async {
    int finalPrice = 0;
    await showLoading();
    await run(
      () async => finalPrice = await _getEstimateFinalReceivingPriceUsecase.run(deliveryAuthorizationId),
    );
    await hideLoading();
    return finalPrice;
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
            () => _receiveDeliveryUsecase.receiveDeliveryAuthorization(deliveryAuthorizationId),
          );
          await hideLoading();
          if (success) {
            await hideLoading();
            await Get.off(
              ReceiveDeliveryAuthorizationStatePage(
                cabinetInfo: cabinetInfo,
                deliveryAuthorizationId: deliveryAuthorizationId,
                isCharity: isCharity,
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

  Future<Unit> notifyDeliveryAuthorizationReceiver() async {
    await showLoading();
    final success = await run(
      () async => _notifyDeliveryAuthorizationReceiverUsecase.run(deliveryAuthorizationId),
    );
    await hideLoading();
    if (success) {
      Get.back();
      showToast(LocaleKeys.delivery_authorization_notify_owner_successfully.trans());
    }

    return unit;
  }

  @override
  Future<Unit> handleRestError(RestError restError, String? errorCode) async {
    switch (errorCode) {
      case Constants.errorCodeNotEnoughBalanceToReceive:
        showNoticeBottomSheet();
        break;
      case Constants.errorCodeCabinetDisconnected:
        _isCabinetOffline = true;
        break;
      default:
        await super.handleRestError(restError, errorCode);
    }
    return unit;
  }

  void showNoticeBottomSheet() {
    Get.bottomSheet(
      NoticeUserNotEnoughBalanceToReceiveWidget(
        notifyUser: notifyDeliveryAuthorizationReceiver,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      backgroundColor: Colors.white,
    );
  }
}
