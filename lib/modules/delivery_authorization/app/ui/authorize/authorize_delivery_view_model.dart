import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/charity/app/ui/charity_phone_number_picker/charity_phone_number_picker_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/phone_number_picker/phone_number_picker_page.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_type.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/result/authorize_receiver_package_success_dialog.dart';
import 'package:santapocket/modules/delivery_authorization/domain/usecases/create_delivery_authorization_usecase.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user_public_info.dart';
import 'package:santapocket/modules/user/domain/usecases/find_user_public_info_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class AuthorizeDeliveryViewModel extends AppViewModel {
  final FindUserPublicInfoUsecase _findUserPublicInfoUsecase;
  final GetSettingUsecase _getSettingUsecase;
  final CreateDeliveryAuthorizationUsecase _createDeliveryAuthorizationUsecase;

  AuthorizeDeliveryViewModel(this._findUserPublicInfoUsecase, this._getSettingUsecase, this._createDeliveryAuthorizationUsecase);

  late TextEditingController phoneController;
  late FocusNode focusNode;

  String phoneNumberAuthorize = "";

  bool invalidPhoneAuthorize = false;
  bool phoneNumberAuthorizeInSystem = true;

  UserPublicInfo? userAuthorized;

  late Delivery delivery;
  late String cabinetName;

  final _phoneHotline = Rx<String?>(null);
  final _authorizedName = Rx<String>('');
  final _isLoadingName = Rx<bool>(false);

  String? get phoneHotline => _phoneHotline.value;

  String get authorizedName => _authorizedName.value;

  bool get isLoadingName => _isLoadingName.value;

  @override
  void initState() {
    fetchData();
    phoneController = TextEditingController();
    focusNode = FocusNode();
    focusNode.addListener(() async {
      if (!focusNode.hasFocus && phoneNumberAuthorize.trim().isNotEmpty) {
        await getUserNameByPhoneNumber();
      }
    });
    super.initState();
  }

  Future<Unit> fetchData() async {
    late String? phoneLoaded;
    await showLoading();
    final success = await run(
      () async => phoneLoaded = (await _getSettingUsecase.run(Constants.hotlineSettingKey)).value as String?,
    );
    await hideLoading();
    if (success) {
      _phoneHotline.value = phoneLoaded;
    }
    return unit;
  }

  void onNavigatePhoneNumberPickerPage() {
    focusNode.unfocus();
    delivery.type == DeliveryType.charity
        ? Get.to(() => CharityPhoneNumberPickerPage(
              cabinetName: cabinetName,
              delivery: delivery,
              onSelect: onSelectContact,
            ))
        : Get.to(() => PhoneNumberPickerPage(
              cabinetName: cabinetName,
              onSelect: onSelectContact,
            ));
  }

  Future<Unit> onSelectContact(String phone, {String? name}) async {
    phoneController.text = phone;
    setPhoneNumberAuthorize(phone);
    if (name != null) {
      _authorizedName(name);
      invalidPhoneAuthorize = true;
    } else {
      await getUserNameByPhoneNumber();
    }
    return unit;
  }

  void onSubmitText(String phone) {
    setPhoneNumberAuthorize(phone);
    if (phoneNumberAuthorize.trim().isNotEmpty) {
      getUserNameByPhoneNumber();
    }
  }

  Future<Unit> getUserNameByPhoneNumber() async {
    if (phoneNumberAuthorize.trim().isNotEmpty) {
      _isLoadingName(true);
      await run(
        () async {
          try {
            userAuthorized = await _findUserPublicInfoUsecase.run(phoneNumber: phoneNumberAuthorize);
            _authorizedName(userAuthorized?.name ?? LocaleKeys.delivery_authorization_unknown.trans());
            phoneNumberAuthorizeInSystem = userAuthorized?.lastSeen != null;
            _isLoadingName(false);
            invalidPhoneAuthorize = true;
          } catch (error) {
            _authorizedName(LocaleKeys.delivery_authorization_unknown.trans());
            _isLoadingName(false);
            invalidPhoneAuthorize = false;
          }
        },
        shouldHandleError: false,
      );
      return unit;
    }
    return unit;
  }

  void setPhoneNumberAuthorize(String phone) {
    phoneNumberAuthorize = phone.removeAllWhitespace;
  }

  Future<Unit> confirmAuthorization() async {
    if (phoneNumberAuthorize.trim().isEmpty) {
      showToast(LocaleKeys.delivery_authorization_must_fill_phone_number.trans());
    } else if (invalidPhoneAuthorize) {
      await _createDeliveryAuthorization();
    } else {
      showToast(LocaleKeys.delivery_authorization_invalid_phone_number.trans());
    }
    return unit;
  }

  Future<Unit> _createDeliveryAuthorization() async {
    await showLoading();
    final success = await run(
      () async => _createDeliveryAuthorizationUsecase.run(deliveryId: delivery.id, phoneNumber: phoneNumberAuthorize),
    );
    await hideLoading();
    if (success) {
      Get.back(result: true);
      await Get.dialog(const AuthorizeReceiverPackageSuccessDialog());
    }
    return unit;
  }
}
