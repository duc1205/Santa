import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/offline_dialog.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/receive_delivery_authorization/receive_delivery_authorization_state_page.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/receive_delivery_authorization/widgets/notice_user_not_enough_balance_to_receive_widget.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:santapocket/modules/delivery_authorization/domain/usecases/notify_delivery_authorization_receiver_usecase.dart';
import 'package:santapocket/modules/delivery_authorization/domain/usecases/receive_delivery_authorization_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/retrofit/rest_error.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class ReceiveDeliveryAuthorizationsPageViewModel extends AppViewModel {
  final ReceiveDeliveryAuthorizationUsecase _receiveDeliveryAuthorizationUsecase;
  final NotifyDeliveryAuthorizationReceiverUsecase _notifyDeliveryAuthorizationReceiverUsecase;

  ReceiveDeliveryAuthorizationsPageViewModel(
    this._receiveDeliveryAuthorizationUsecase,
    this._notifyDeliveryAuthorizationReceiverUsecase,
  );

  late List<DeliveryAuthorization> deliveryAuthorizations;
  late CabinetInfo cabinetInfo;
  User? user;
  Map<String, dynamic>? bankTransferInfo = {};
  final _listCabinetWithDeliveries = Rx<List<CabinetInfo>>([]);

  bool? _isCabinetOffline;

  final _selectedDeliveryAuthorization = Rx<DeliveryAuthorization?>(null);

  DeliveryAuthorization? get selectedDeliveryAuthorization => _selectedDeliveryAuthorization.value;

  List<CabinetInfo> get listCabinetWithDeliveries => _listCabinetWithDeliveries.value;

  void loadArguments(
    List<DeliveryAuthorization> listAuthorization,
    CabinetInfo info,
    User? user,
    Map<String, dynamic>? bankTransferInfo,
    List<CabinetInfo> listCabinetWithDeliveries,
  ) {
    deliveryAuthorizations = listAuthorization;
    cabinetInfo = info;
    this.user = user;
    this.bankTransferInfo = bankTransferInfo;
    _selectedDeliveryAuthorization(listAuthorization.isNotEmpty ? listAuthorization[0] : null);
    _listCabinetWithDeliveries.value = listCabinetWithDeliveries;
  }

  void setSelectedDeliveryAuthorization(DeliveryAuthorization deliveryAuthorization) => _selectedDeliveryAuthorization(deliveryAuthorization);

  Future<Unit> receiveDeliveryAuthorization() async {
    if (selectedDeliveryAuthorization != null) {
      await showLoading();
      final success = await run(
        () async => _receiveDeliveryAuthorizationUsecase.run(selectedDeliveryAuthorization!.id),
      );
      await hideLoading();
      if (success) {
        await Get.to(
          () => ReceiveDeliveryAuthorizationStatePage(
            deliveryAuthorizationId: selectedDeliveryAuthorization!.id,
            cabinetInfo: cabinetInfo,
            isCharity: false,
          ),
        );
      } else {
        if (_isCabinetOffline == true) {
          _showOfflineDialog();
          _isCabinetOffline = null;
        }
      }
    } else {
      showToast(LocaleKeys.delivery_authorization_please_choose_delivery.trans());
    }
    return unit;
  }

  Future<Unit> notifyDeliveryAuthorizationReceiver() async {
    await showLoading();
    final success = await run(
      () async => _notifyDeliveryAuthorizationReceiverUsecase.run(selectedDeliveryAuthorization!.id),
    );
    await hideLoading();
    if (success) {
      Get.back();
      showToast(LocaleKeys.delivery_authorization_notify_owner_successfully.trans());
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

  void _showOfflineDialog() {
    Get.dialog(
      OfflineDialog(
        cabinetInfo: cabinetInfo,
        onConfirm: receiveDeliveryAuthorization,
      ),
    );
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

  //Check if list of all receivable deliveries from all cabinet as same as scanned cabinet
  bool checkIsCabinetFromSameList() {
    if (listCabinetWithDeliveries.length == 1 && listCabinetWithDeliveries.elementAt(0).id == cabinetInfo.id) {
      return true;
    }
    return false;
  }
}
