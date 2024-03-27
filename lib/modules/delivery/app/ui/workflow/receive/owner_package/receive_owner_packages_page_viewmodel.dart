import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info/package_info.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/owner_package/widgets/balance_not_enough_receive_widget.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/receive_pocket_state_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/offline_dialog.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_type.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_estimate_final_receiving_price_usecase.dart';
import 'package:santapocket/modules/delivery/domain/usecases/receive_delivery_usecase.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/retrofit/rest_error.dart';
import 'package:suga_core/suga_core.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class ReceiveOwnerPackagesPageViewModel extends AppViewModel {
  final ReceiveDeliveryUsecase _receiveDeliveryUsecase;
  final GetSettingUsecase _getSettingUsecase;
  final GetEstimateFinalReceivingPriceUsecase _getEstimateFinalReceivingPriceUsecase;

  ReceiveOwnerPackagesPageViewModel(this._receiveDeliveryUsecase, this._getSettingUsecase, this._getEstimateFinalReceivingPriceUsecase);

  final _deliveries = Rx<List<Delivery>>([]);
  final _listCabinetWithDeliveries = Rx<List<CabinetInfo>>([]);
  late CabinetInfo cabinetInfo;
  User? user;
  Map<String, dynamic>? bankTransferInfo = {};
  bool? _isCabinetOffline;
  final _selectedDelivery = Rx<Delivery?>(null);

  Delivery? get selectedDelivery => _selectedDelivery.value;

  List<Delivery> get deliveries => _deliveries.value;

  List<CabinetInfo> get listCabinetWithDeliveries => _listCabinetWithDeliveries.value;

  void loadArguments(
    CabinetInfo cabinetInfo,
    List<Delivery> deliveries,
    List<CabinetInfo> listCabinetWithDeliveries,
    User? user,
    Map<String, dynamic>? bankTransferInfo,
  ) {
    this.cabinetInfo = cabinetInfo;
    _deliveries.value = deliveries;
    _listCabinetWithDeliveries.value = listCabinetWithDeliveries;
    this.user = user;
    this.bankTransferInfo = bankTransferInfo;
    _selectedDelivery.value = deliveries.isNotEmpty ? deliveries[0] : null;
  }

  void onItemClick(Delivery del) => _selectedDelivery(del);

  bool get enoughBalance => ((user?.freeUsage ?? 0) > 0) || ((user?.balance ?? 0) >= (selectedDelivery?.estimatedReceivingPrice ?? 0));

  Future<Unit> receiveDelivery() async {
    final unwrapSelectedDelivery = selectedDelivery;
    if (unwrapSelectedDelivery != null) {
      bool success = false;
      bool isUseCoin = false;

      await showLoading();
      success = await run(
        () async => _receiveDeliveryUsecase.run(unwrapSelectedDelivery.id, isUseCoin),
      );
      await hideLoading();
      if (success) {
        await Get.off(
          () => ReceivePocketStatePage(
            cabinetInfo: cabinetInfo,
            deliveryId: selectedDelivery!.id,
            isCharity: unwrapSelectedDelivery.type == DeliveryType.charity,
          ),
        );
      } else {
        if (_isCabinetOffline == true) {
          _showOfflineDialog();
          _isCabinetOffline = null;
        }
      }
    } else {
      showToast(LocaleKeys.delivery_please_choose_delivery.trans());
    }
    return unit;
  }

  void _showBottomSheetBalanceNotEnoughReceive() {
    Get.bottomSheet(
      BalanceNotEnoughReceiveWidget(
        phoneHotLine: bankTransferInfo?["contacts"]["call"]["value"],
        zaloUri: bankTransferInfo?["contacts"]["zalo"]["value"],
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
    );
  }

  Future<bool> sendEmail() async {
    String version = "";
    String? supportEmail;
    String osVersion = "";
    final PackageInfo info = await PackageInfo.fromPlatform();
    version = info.version;

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
    await showLoading();
    await run(
      () async => supportEmail = (await _getSettingUsecase.run(Constants.supportEmailSettingKey)).value as String?,
    );
    await hideLoading();
    final Uri url = Uri(
      scheme: 'mailto',
      path: supportEmail ?? 'huynhpl@suga.vn',
      query: "subject= ${LocaleKeys.delivery_title_email.trans()}&body=${LocaleKeys.delivery_body_email.trans(
        namedArgs: {
          "phoneNumber": user?.phoneNumber ?? "",
          "cabinetName": cabinetInfo.name,
          "version": version,
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

  void _showOfflineDialog() {
    Get.dialog(
      OfflineDialog(
        cabinetInfo: cabinetInfo,
        onConfirm: receiveDelivery,
      ),
    );
  }

  @override
  Future<Unit> handleRestError(RestError restError, String? errorCode) async {
    switch (errorCode) {
      case Constants.errorCodeNotEnoughBalanceToReceive:
        _showBottomSheetBalanceNotEnoughReceive();
        break;
      case Constants.errorCodeCabinetDisconnected:
        _isCabinetOffline = true;
        break;
      default:
        await super.handleRestError(restError, errorCode);
    }
    return unit;
  }

  Future<int> getEstimateFinalReceivingPrice() async {
    int finalPrice = 0;
    await showLoading();
    await run(
      () async => finalPrice = await _getEstimateFinalReceivingPriceUsecase.run(selectedDelivery!.id),
    );
    await hideLoading();
    return finalPrice;
  }

  //Check if list of all receivable deliveries from all cabinet as same as scanned cabinet
  bool checkIsCabinetFromSameList() {
    if (listCabinetWithDeliveries.length == 1 && listCabinetWithDeliveries.elementAt(0).id == cabinetInfo.id) {
      return true;
    }
    return false;
  }
}
