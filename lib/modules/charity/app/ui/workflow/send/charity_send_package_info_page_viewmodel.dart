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
import 'package:santapocket/modules/charity/app/ui/workflow/send/charity_send_pocket_state_page.dart';
import 'package:santapocket/modules/charity/domain/models/charity.dart';
import 'package:santapocket/modules/charity/domain/models/charity_campaign.dart';
import 'package:santapocket/modules/delivery/domain/usecases/donate_for_charity_usecase.dart';
import 'package:santapocket/modules/charity/domain/usecases/get_charity_by_id_usecase.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/agree_to_term_and_condition_dialog.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/cabinet_empty_pocket_dialog.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/offline_dialog.dart';
import 'package:santapocket/modules/delivery/domain/enums/package_category.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/main/app/events/user_accept_tos_event.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/agree_tos_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/retrofit/rest_error.dart';
import 'package:suga_core/suga_core.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class CharitySendPackageInfoPageViewModel extends AppViewModel {
  final GetPocketSizesUsecase _getPocketSizesUsecase;
  final GetProfileUsecase _getProfileUsecase;
  final AgreeTosUsecase _agreeTOSUserCase;
  final GetSettingUsecase _getSettingUsecase;
  final GetCharityByIdUsecase _getCharityByIdUsecase;
  final DonateForCharityUsecase _donateForCharityUsecase;

  CharitySendPackageInfoPageViewModel(
    this._getPocketSizesUsecase,
    this._getProfileUsecase,
    this._agreeTOSUserCase,
    this._getSettingUsecase,
    this._getCharityByIdUsecase,
    this._donateForCharityUsecase,
  );

  late CabinetInfo cabinetInfo;
  late Charity charity;
  late CharityCampaign? charityCampaign;

  bool availablePocket = false;
  bool invalidPhone = false;
  bool phoneNumberInSystem = true;
  bool? _isCabinetOffline;

  final _isLoadingName = Rx<bool>(false);
  final _charityId = Rx<String>("");
  final _note = Rx<String>("");
  final _receiverName = Rx<String>("");
  final _charityOrg = Rx<String>("");
  final _pocketSizes = Rx<List<PocketSize>>([]);
  final _selectedCategory = Rx<PackageCategory?>(null);
  final _selectedIndex = Rx<int>(-1);
  final _charityPhoneNumber = Rx<String>("");
  final _helpCenterUrl = Rx<String>("");
  final _user = Rx<User?>(null);

  List<PocketSize> get pocketSizes => _pocketSizes.value;

  int get selectedIndex => _selectedIndex.value;

  bool get isLoadingName => _isLoadingName.value;

  String get charityId => _charityId.value;

  String get notes => _note.value;

  String get receiverName => _receiverName.value;

  String get charityOrg => _charityOrg.value;

  String get getPocketPrice => FormatHelper.formatCurrency(selectedIndex == -1 ? 0 : pocketSizes[selectedIndex].pricing?.sendingPrice ?? 0);

  bool get isSubmitable => selectedIndex >= 0 && charityId.isNotEmpty && selectedCategory != null;

  String get charityPhoneNumber => _charityPhoneNumber.value;

  String get helpCenterUrl => _helpCenterUrl.value;

  User? get user => _user.value;

  void setSelectedIndex(int index) {
    if ((pocketSizes[index].availablePocketsCount ?? 0) > 0) {
      _selectedIndex.value = index;
    }
  }

  PackageCategory? get selectedCategory => _selectedCategory.value;

  void onSelectCategory(PackageCategory itemSelect) => _selectedCategory(itemSelect);

  void setPhone(String phone) => _charityId(phone.removeWhitespaces());

  void setNote(String note) => _note(note);

  String gratefulMessage = "";

  @override
  void initState() {
    _onInit();
    super.initState();
  }

  Future<Unit> _onInit() async {
    await showLoading();
    await _getUserProfile();
    await _checkAgreeToTermAndCondition();
    await _getPocketSizes();
    assignCharity();
    await getUserNameByPhoneNumber();
    await _getSetting();
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
    String termsAndConditionsUrl = '';
    String privacyPolicyUrl = '';
    final locale = FormatHelper.getPlatformLocaleName();

    await showLoading();
    await run(() async {
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

  Unit assignCharity() {
    setPhone(charity.id);
    _isLoadingName(true);
    _charityPhoneNumber(charity.user?.phoneNumber);
    _receiverName(charity.user?.name);
    _charityOrg(charity.name);
    _isLoadingName(false);
    invalidPhone = true;
    return unit;
  }

  Future<Unit> getUserNameByPhoneNumber() async {
    if (charityId.trim().isNotEmpty) {
      _receiverName("");
      _isLoadingName(true);
      await run(
        () async {
          try {
            final charityInfo = await _getCharityByIdUsecase.run(charityId);
            _charityPhoneNumber(charityInfo.user?.phoneNumber);
            _receiverName(charityInfo.user?.name);
            _charityOrg(charityInfo.name);
            _isLoadingName(false);
            gratefulMessage = charityInfo.gratefulMessage ?? "";
            invalidPhone = true;
          } catch (error) {
            _receiverName(LocaleKeys.charity_unknown.trans());
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
      showToast(LocaleKeys.charity_must_select_pocket_sentence.trans());
    } else if (charityId == "") {
      showToast(LocaleKeys.charity_must_fill_phone_sentence.trans());
    } else if (selectedCategory == null) {
      showToast(LocaleKeys.charity_please_choose_category.trans());
    } else if (invalidPhone) {
      if (phoneNumberInSystem) {
        await _handleSendPackage();
      }
    } else {
      showToast(LocaleKeys.charity_invalid_phone_number.trans());
    }

    return unit;
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
      () async => delivery = await _donateForCharityUsecase.run(
        cabinetId: cabinetInfo.id,
        pocketSizeId: pocketSizes[selectedIndex].id,
        id: charityCampaign!.id,
        note: notes,
        packageCategory: selectedCategory?.toValue() ?? "",
      ),
    );
    await hideLoading();
    if (success) {
      await Get.to(
        () => CharitySendPocketStatePage(
          deliveryId: delivery.id,
          cabinetInfo: cabinetInfo,
          gratefulMessage: gratefulMessage,
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

  Future<Unit> _getSetting() async {
    late String helpCenterUrlFetch;
    final success = await run(() async {
      if (user != null) {
        final locale = user?.locale ?? FormatHelper.getPlatformLocaleName();
        helpCenterUrlFetch =
            (await _getSettingUsecase.run(locale == Language.vi.getValue() ? Constants.charityInstructionUrlVi : Constants.charityInstructionUrlEn))
                    .value ??
                "";
      }
    });
    if (success) {
      _helpCenterUrl.value = helpCenterUrlFetch;
    }
    return unit;
  }

  Future<Unit> _getUserProfile() async {
    User? userFetch;
    await showLoading();
    final success = await run(
      () async {
        userFetch = await _getProfileUsecase.run();
      },
    );
    await hideLoading();
    if (success) {
      _user.value = userFetch;
    }
    return unit;
  }
}
