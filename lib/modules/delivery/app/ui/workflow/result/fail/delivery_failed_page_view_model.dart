import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info/package_info.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_maintenance/cabinet_maintenance_page.dart';
import 'package:santapocket/modules/cabinet/domain/enums/cabinet_status.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/reopen_pocket/reopen_pocket_state_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/offline_dialog.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/models/reopen_request.dart';
import 'package:santapocket/modules/delivery/domain/usecases/check_delivery_reopenable_usecase.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_delivery_usecase.dart';
import 'package:santapocket/modules/delivery/domain/usecases/reopen_pocket_usecase.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/retrofit/rest_error.dart';
import 'package:suga_core/suga_core.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class DeliveryFailedPageViewModel extends AppViewModel {
  final GetProfileUsecase _getProfileUsecase;
  final GetSettingUsecase _getSettingUsecase;
  final ReopenPocketUsecase _reopenPocketUsecase;
  final CheckDeliveryReopenableUsecase _checkDeliveryReopenableUsecase;
  final GetDeliveryUsecase _getDeliveryUsecase;

  DeliveryFailedPageViewModel(
    this._getProfileUsecase,
    this._getSettingUsecase,
    this._reopenPocketUsecase,
    this._checkDeliveryReopenableUsecase,
    this._getDeliveryUsecase,
  );

  late CabinetInfo cabinetInfo;
  late int deliveryId;

  final _isDeliveryReopenable = RxBool(false);
  final _delivery = Rx<Delivery?>(null);
  final _bankTransferInfo = Rx<Map<String, dynamic>>({});

  bool get isDeliveryReopenable => _isDeliveryReopenable.value;

  Map<String, dynamic> get bankTransferInfo => _bankTransferInfo.value;

  Delivery? get delivery => _delivery.value;
  String osVersion = "";
  String appVersion = "";
  String? supportEmail;
  User? user;
  bool _isCabinetOffline = false;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<bool> sendEmail() async {
    await showLoading();
    final success = await run(
      () async {
        await _getDeviceInfo();
        user = await _getProfileUsecase.run();
        supportEmail = (await _getSettingUsecase.run(Constants.supportEmailSettingKey)).value as String?;
      },
    );
    await hideLoading();
    if (success) {
      final Uri url = Uri(
        scheme: 'mailto',
        path: supportEmail ?? 'huynhpl@suga.vn',
        query: "subject= ${LocaleKeys.delivery_title_mail_delivery_fail.trans()}&body=${LocaleKeys.delivery_body_mail_delivery_fail.trans(
          namedArgs: {
            "deliveryId": deliveryId.toString(),
            "phoneNumber": user?.phoneNumber ?? "",
            "cabinetName": cabinetInfo.name,
            "version": appVersion,
            "osVersion": osVersion,
          },
        )}",
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
        return true;
      } else {
        showToast("Could not open email");
        return false;
      }
    }
    return success;
  }

  Future<Unit> _fetchData() async {
    late Map<String, dynamic> bankTransferInfoLoaded;
    late bool isDeliveryReopenable;
    late Delivery deliveryLoaded;
    await showLoading();
    final success = await run(
      () async {
        isDeliveryReopenable = await checkDeliveryReOpenable();
        deliveryLoaded = await _getDeliveryUsecase.run(deliveryId);
        final bankTransferInfoFetched = (await _getSettingUsecase.run(Constants.appBankTransferInfo)).value;
        if (bankTransferInfoFetched is Map<String, dynamic>) {
          bankTransferInfoLoaded = bankTransferInfoFetched;
        }
      },
    );
    if (success) {
      _isDeliveryReopenable(isDeliveryReopenable);
      _delivery(deliveryLoaded);
      _bankTransferInfo.value = bankTransferInfoLoaded;
    }
    await hideLoading();
    return unit;
  }

  Future<bool> checkDeliveryReOpenable() async {
    bool isDeliveryReOpenable = false;
    await showLoading();
    await run(
      () async => isDeliveryReOpenable = await _checkDeliveryReopenableUsecase.run(deliveryId),
    );
    await hideLoading();
    return isDeliveryReOpenable;
  }

  Future<Unit> _getDeviceInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    appVersion = info.version;
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      final release = androidInfo.version.release;
      final manufacturer = androidInfo.manufacturer;
      osVersion = "Android($release) ,$manufacturer";
    }

    if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await DeviceInfoPlugin().iosInfo;
      final systemName = iosInfo.systemName;
      final version = iosInfo.systemVersion;
      osVersion = "$systemName ($version)";
    }
    return unit;
  }

  Future<Unit> reopenPocket() async {
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
    if (isDeliveryReopenable && unwrapDelivery != null) {
      await showLoading();
      ReopenRequest? reopenRequest;
      final success = await run(
        () async => reopenRequest = await _reopenPocketUsecase.run(deliveryId: deliveryId, cabinetId: cabinetInfo.id),
      );
      await hideLoading();
      if (success) {
        await hideLoading();
        await Get.off(
          ReopenPocketStatePage(
            cabinetInfo: cabinetInfo,
            delivery: unwrapDelivery,
            reopenRequestId: reopenRequest?.id as int,
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
    }
    return unit;
  }

  @override
  Future<Unit> handleRestError(RestError restError, String? errorCode) async {
    switch (errorCode) {
      case Constants.errorCodeCabinetDisconnected:
        _isCabinetOffline = true;
        break;
      default:
        await super.handleRestError(restError, errorCode);
    }
    return unit;
  }
}
