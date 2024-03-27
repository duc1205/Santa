import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/deeplink/qr_code_manager.dart';
import 'package:santapocket/deeplink/type_deeplink.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/firebase/domain/events/fcm_initial_message_navigation_event.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/auth/app/ui/widgets/session_expired_widget.dart';
import 'package:santapocket/modules/auth/domain/events/session_expired_event.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_maintenance/cabinet_maintenance_page.dart';
import 'package:santapocket/modules/cabinet/domain/enums/cabinet_status.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_cabinet_info_usecase.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/send/send_package_info_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/send_and_receive/send_and_receive_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/receive_packages_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/self_rent/self_rent_pocket_info_page.dart';
import 'package:santapocket/modules/main/app/ui/home/enums/action_scan.dart';
import 'package:santapocket/modules/payment/app/ui/result_payment/payment_error.dart';
import 'package:santapocket/modules/payment/app/ui/result_payment/payment_processing.dart';
import 'package:santapocket/modules/payment/app/ui/result_payment/payment_success.dart';
import 'package:santapocket/modules/payment/domain/enums/payment_method.dart';
import 'package:santapocket/modules/payment/domain/enums/payment_result.dart';
import 'package:santapocket/modules/payment/domain/events/vnpay_payment_finished_event.dart';
import 'package:santapocket/modules/permission/domain/usecases/check_and_request_notification_permission_usecase.dart';
import 'package:santapocket/modules/tutorial/app/ui/static_home_page.dart';
import 'package:santapocket/modules/user/app/ui/app_info/web_view_page.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:suga_core/suga_core.dart' hide BaseViewModel;
import 'package:uni_links/uni_links.dart';

@injectable
class MainPageViewModel extends AppViewModel {
  final GetCabinetInfoUsecase _getCabinetInfoUsecase;
  final GetProfileUsecase _getProfileUsecase;
  final CheckAndRequestNotificationPermissionUsecase _checkAndRequestNotificationPermissionUsecase;

  MainPageViewModel(
    this._getCabinetInfoUsecase,
    this._getProfileUsecase,
    this._checkAndRequestNotificationPermissionUsecase,
  );

  StreamSubscription? _deepLinkStream;
  StreamSubscription? _listenSessionExpired;
  StreamSubscription? _listenFCMInitialMessageNavigation;
  bool _initialLinkIsHandled = false;

  @override
  void initState() {
    super.initState();
    _initializeDeepLink();
    _listenSessionExpired = locator<EventBus>().on<SessionExpiredEvent>().listen((event) {
      Get.bottomSheet(
        const SessionExpiredWidget(),
        isDismissible: false,
        isScrollControlled: false,
        enableDrag: false,
        elevation: 1,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
      );
    });

    _listenFCMInitialMessageNavigation = locator<EventBus>().on<FCMInitialMessageNavigationEvent>().listen((event) {
      event.navigationCall.call();
    });
  }

  Future<Unit> checkAndRequestNotificationPermission() async {
    await _checkAndRequestNotificationPermissionUsecase.run();
    return unit;
  }

  Future<bool> checkCompletedTutorial() async {
    User? user;
    bool? result;
    final success = await run(() async => user = await _getProfileUsecase.run());
    if (success && user != null) {
      result = !user!.isCompletedTutorial ? await Get.to(const StaticHomePage()) : true;
    }
    return result ?? false;
  }

  @override
  void disposeState() {
    _deepLinkStream?.cancel();
    _listenSessionExpired?.cancel();
    _listenFCMInitialMessageNavigation?.cancel();
    super.disposeState();
  }

  Future<Unit> handleQrCodeData({required String barcode, required ActionScan scan}) async {
    final status = await QrCodeManager.instance.parseQrData(barcode);
    if (status is ValidQrStatus) {
      final CabinetInfo? cabinetInfo = await getCabinetInfo(status.uuid!, status.otp);
      if (cabinetInfo != null) {
        if (cabinetInfo.isOnline) {
          switch (cabinetInfo.status) {
            case CabinetStatus.unknown:
            case CabinetStatus.inStock:
              showToast(LocaleKeys.main_cabinet_can_not_use.trans());
              break;
            case CabinetStatus.production:
              await _handleActionScan(cabinetInfo: cabinetInfo, actionScan: scan);
              break;
            case CabinetStatus.maintenance:
              await Get.to(
                () => CabinetMaintenancePage(
                  cabinetName: cabinetInfo.name,
                ),
              );
              break;
          }
        } else {
          await Get.to(
            () => CabinetMaintenancePage(
              cabinetName: cabinetInfo.name,
            ),
          );
        }
      }
    } else if (status is InValidQrStatus) {
      showToast(LocaleKeys.main_wrong_qr_code.trans());
    } else if (status is SurpriseQrStatus) {
      if (scan == ActionScan.scan) {
        await Get.to(() => WebViewPage(url: status.proccessedUrl ?? ""));
      } else {
        showToast(LocaleKeys.main_wrong_qr_code.trans());
      }
    }
    return unit;
  }

  Future<Unit> _handleActionScan({required CabinetInfo cabinetInfo, required ActionScan actionScan}) async {
    switch (actionScan) {
      case ActionScan.send:
        await Get.to(
          () => SendPackageInfoPage(
            cabinetInfo: cabinetInfo,
          ),
        );
        break;
      case ActionScan.receive:
        await Get.to(
          () => ReceivePackagesPage(
            cabinetInfo: cabinetInfo,
          ),
        );
        break;
      case ActionScan.scan:
        await Get.to(
          () => SendAndReceivePage(
            cabinetInfo: cabinetInfo,
          ),
        );
        break;
      case ActionScan.selfRent:
        await Get.to(() => SelfRentPocketInfoPage(
              cabinetInfo: cabinetInfo,
            ));
        break;
    }
    return unit;
  }

  Future<CabinetInfo?> getCabinetInfo(String uuid, String? otp) async {
    late CabinetInfo? cabinetInfo;
    await showLoading();
    final bool isSuccess = await run(
      () async => cabinetInfo = await _getCabinetInfoUsecase.run(uuid: uuid, otp: otp),
    );
    await Future.delayed(const Duration(milliseconds: 500));
    await hideLoading();
    if (isSuccess) {
      return cabinetInfo;
    }
    return null;
  }

  Future<void> _initializeDeepLink() async {
    _deepLinkStream = linkStream.listen(
      (link) async {
        if (link == null) return;
        final Uri uri = Uri.parse(link);
        final String? type = uri.queryParameters["type"];
        if (type == null) {
          return;
        } else {
          switch (type.parseType()) {
            case TypeDeepLink.CabinetInfo:
              final status = QrCodeManager.instance.analyzeDeepLink(link);
              if (status is ValidQrStatus) {
                final CabinetInfo? cabinetInfo = await getCabinetInfo(status.uuid!, status.otp);
                if (cabinetInfo != null) {
                  await Get.to(
                    () => SendAndReceivePage(
                      cabinetInfo: cabinetInfo,
                    ),
                  );
                }
              } else if (status is InValidQrStatus) {
                showToast(LocaleKeys.main_wrong_qr_code.trans());
              } else if (status is SurpriseQrStatus) {
                showToast(LocaleKeys.main_wrong_qr_code.trans());
              }
              break;
            case TypeDeepLink.MomoPayment:
              final String? code = uri.queryParameters["resultCode"];
              final String? amount = uri.queryParameters["amount"];
              if (code != null) {
                switch (code.getResultPaymentMomo()) {
                  case PaymentResult.success:
                    await Get.to(
                      () => PaymentSuccess(
                        amount: int.parse(amount ?? "0"),
                        paymentMethod: PaymentMethod.moMo,
                      ),
                    );
                    break;
                  case PaymentResult.processing:
                    await Get.to(
                      () => PaymentProcessing(
                        amount: int.parse(amount ?? "0"),
                        paymentMethod: PaymentMethod.moMo,
                      ),
                    );
                    break;
                  case PaymentResult.error:
                    await Get.to(() => const PaymentError());
                    break;
                  default:
                    break;
                }
              }
              break;
            case TypeDeepLink.VnPayPayment:
              locator<EventBus>().fire(const VnPayPaymentFinishedEvent());
              break;
            default:
              break;
          }
        }
      },
      onError: (err) {
        showToast(err.toString());
      },
    );
    if (!_initialLinkIsHandled) {
      _initialLinkIsHandled = true;
      try {
        final link = await getInitialLink();
        if (link == null) return;
        final Uri uri = Uri.parse(link);
        final String? type = uri.queryParameters["type"];
        if (type == null) {
          return;
        } else {
          switch (type.parseType()) {
            case TypeDeepLink.CabinetInfo:
              final status = QrCodeManager.instance.analyzeDeepLink(link);
              if (status is ValidQrStatus) {
                final CabinetInfo? cabinetInfo = await getCabinetInfo(status.uuid!, status.otp);
                if (cabinetInfo != null) {
                  await Get.to(
                    () => SendAndReceivePage(
                      cabinetInfo: cabinetInfo,
                    ),
                  );
                }
              } else if (status is InValidQrStatus) {
                showToast(LocaleKeys.main_wrong_qr_code.trans());
              } else if (status is SurpriseQrStatus) {
                showToast(LocaleKeys.main_wrong_qr_code.trans());
              }
              break;
            default:
              break;
          }
        }
      } on PlatformException {
        showToast(LocaleKeys.main_fail_initialize_link.trans());
      }
    }
  }
}
