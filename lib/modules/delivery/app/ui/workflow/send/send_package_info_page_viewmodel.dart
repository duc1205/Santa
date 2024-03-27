import 'package:event_bus/event_bus.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/core/helpers/loading_helper.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket_size.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_pocket_sizes_usecase.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/send/send_pocket_state_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/send/widgets/phone_number_receiver_not_in_system_dialog.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/agree_to_term_and_condition_dialog.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/cabinet_empty_pocket_dialog.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/offline_dialog.dart';
import 'package:santapocket/modules/delivery/domain/enums/package_category.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/usecases/create_delivery_usecase.dart';
import 'package:santapocket/modules/main/app/events/user_accept_tos_event.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/agree_tos_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/find_user_public_info_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/retrofit/rest_error.dart';
import 'package:suga_core/suga_core.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class SendPackageInfoPageViewModel extends AppViewModel {
  final GetPocketSizesUsecase _getPocketSizesUsecase;
  final CreateDeliveryUsecase _createDeliveryUsecase;
  final FindUserPublicInfoUsecase _findUserPublicInfoUsecase;
  final GetProfileUsecase _getProfileUsecase;
  final AgreeTosUsecase _agreeTOSUserCase;
  final GetSettingUsecase _getSettingUsecase;

  SendPackageInfoPageViewModel(
    this._getPocketSizesUsecase,
    this._createDeliveryUsecase,
    this._findUserPublicInfoUsecase,
    this._getProfileUsecase,
    this._agreeTOSUserCase,
    this._getSettingUsecase,
  );

  late CabinetInfo cabinetInfo;

  bool availablePocket = false;
  bool invalidPhone = false;
  bool phoneNumberInSystem = true;
  bool? _isCabinetOffline;

  final _isLoadingName = Rx<bool>(false);
  final _recipientPhone = Rx<String>("");
  final _note = Rx<String>("");
  final _receiverName = Rx<String>("");
  final _pocketSizes = Rx<List<PocketSize>>([]);
  final _selectedCategory = Rx<PackageCategory?>(null);
  final _selectedIndex = Rx<int>(-1);

  List<PocketSize> get pocketSizes => _pocketSizes.value;

  int get selectedIndex => _selectedIndex.value;

  bool get isLoadingName => _isLoadingName.value;

  String get recipientPhone => _recipientPhone.value;

  String get notes => _note.value;

  String get receiverName => _receiverName.value;

  String get getPocketPrice => FormatHelper.formatCurrency(selectedIndex == -1 ? 0 : pocketSizes[selectedIndex].pricing?.sendingPrice ?? 0);

  void setSelectedIndex(int index) {
    if ((pocketSizes[index].availablePocketsCount ?? 0) > 0) {
      _selectedIndex.value = index;
    }
  }

  PackageCategory? get selectedCategory => _selectedCategory.value;

  bool get isCouldSubmit => recipientPhone.isNotEmpty && selectedIndex != -1 && selectedCategory != null;

  void onSelectCategory(PackageCategory itemSelect) => _selectedCategory(itemSelect);

  void setPhone(String phone) => _recipientPhone(phone.removeWhitespaces());

  void setNote(String note) => _note(note);

  @override
  void initState() {
    _onInit();
    super.initState();
  }

  Future<Unit> _onInit() async {
    await showLoading();
    await _checkAgreeToTermAndCondition();
    await _getPocketSizes();
    await hideLoading();
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

  Future<Unit> _checkAgreeToTermAndCondition() async {
    User? user;
    String termsAndConditionsUrl = '';
    String privacyPolicyUrl = '';
    final locale = FormatHelper.getPlatformLocaleName();

    await showLoading();
    await run(() async {
      user = await _getProfileUsecase.run();
      termsAndConditionsUrl =
          (await _getSettingUsecase.run(locale == Language.vi.getValue() ? Constants.termsAndConditionsUrlVI : Constants.termsAndConditionsUrlEN))
                  .value ??
              '';
      privacyPolicyUrl =
          (await _getSettingUsecase.run(locale == Language.vi.getValue() ? Constants.privacyPolicyUrlVI : Constants.privacyPolicyUrlEN)).value ?? '';
    });
    await hideLoading();
    if (user?.tosAgreedAt == null) {
      await locator<LoadingHelper>().clear();
      await Get.dialog(
        AgreeToTermAndConditionDialog(
          onAccept: _onAcceptTOS,
          onPrivacyPolicyTap: () => _launchUri(privacyPolicyUrl),
          onTermAndConditionTap: () => _launchUri(termsAndConditionsUrl),
        ),
        barrierDismissible: false,
      );
    }
    return unit;
  }

  Future<Unit> _launchUri(String uri) async {
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      showToast("Could not launch url");
    }
    return unit;
  }

  Future<Unit> _onAcceptTOS() async {
    await showLoading();
    final bool result = await run(() => _agreeTOSUserCase.run());
    if (result) {
      locator<EventBus>().fire(const UserAcceptTOSEvent());
    }
    await hideLoading();
    return unit;
  }

  Future<Unit> getUserNameByPhoneNumber() async {
    if (recipientPhone.trim().isNotEmpty) {
      _isLoadingName(true);
      await run(
        () async {
          try {
            final userPublicInfo = await _findUserPublicInfoUsecase.run(phoneNumber: recipientPhone);
            _receiverName(userPublicInfo?.name ?? LocaleKeys.delivery_unknown.trans());
            phoneNumberInSystem = userPublicInfo?.lastSeen != null;
            _isLoadingName(false);
            invalidPhone = true;
          } catch (error) {
            _receiverName(LocaleKeys.delivery_unknown.trans());
            _isLoadingName(false);
            invalidPhone = false;
          }
        },
        shouldHandleError: false,
      );
      return unit;
    }
    return unit;
  }

  bool get isAvailablePocket {
    bool isCheck = false;
    for (final item in pocketSizes) {
      if ((item.availablePocketsCount ?? 0) > 0) {
        isCheck = true;
        break;
      }
    }
    return isCheck;
  }

  Future<bool> _getPocketSizes() async {
    late List<PocketSize> pocketSizes;
    await showLoading();
    final success = await run(
      () async => pocketSizes = await _getPocketSizesUsecase.run(cabinetInfo.id),
    );
    await hideLoading();
    if (success) {
      _pocketSizes.value = pocketSizes;
      if (!isAvailablePocket) {
        _showDialogEmptyPocket();
      }
    }
    return success;
  }

  void _showDialogEmptyPocket() {
    Get.dialog(
      CabinetEmptyPocketDialog(
        cabinetName: cabinetInfo.name,
      ),
      barrierDismissible: false,
    );
  }

  Future<Unit> onSubmitButtonClicked() async {
    if (selectedIndex < 0) {
      showToast(LocaleKeys.delivery_must_select_pocket_sentence.trans());
    } else if (recipientPhone == "") {
      showToast(LocaleKeys.delivery_must_fill_phone_sentence.trans());
    } else if (selectedCategory == null) {
      showToast(LocaleKeys.delivery_please_choose_category.trans());
    } else if (invalidPhone) {
      if (phoneNumberInSystem) {
        await _handleSendPackage();
      } else {
        _showDialogPhoneNumber();
      }
    } else {
      showToast(LocaleKeys.delivery_invalid_phone_number.trans());
    }

    return unit;
  }

  void _showDialogPhoneNumber() {
    Get.dialog(
      PhoneNumberReceiverNotInSystemDialog(
        phoneNumber: recipientPhone,
        cabinetInfo: cabinetInfo,
        onConfirm: _handleSendPackage,
      ),
    );
  }

  void _showOfflineDialog() {
    Get.dialog(
      OfflineDialog(
        cabinetInfo: cabinetInfo,
        onConfirm: _handleSendPackage,
      ),
    );
  }

  Future<Unit> _handleSendPackage() async {
    late Delivery delivery;
    await showLoading();
    final success = await run(
      () async => delivery = await _createDeliveryUsecase.run(
        cabinetId: cabinetInfo.id,
        sizeId: pocketSizes[selectedIndex].id,
        receiverPhoneNumber: recipientPhone,
        note: notes,
        packageCategory: selectedCategory,
      ),
    );
    await hideLoading();
    if (success) {
      await Get.to(
        () => SendPocketStatePage(
          deliveryId: delivery.id,
          cabinetInfo: cabinetInfo,
        ),
      );
    } else {
      if (_isCabinetOffline == true) {
        _showOfflineDialog();
        _isCabinetOffline = null;
      }
    }
    return unit;
  }
}
