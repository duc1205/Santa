import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/deeplink/qr_code_manager.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_maintenance/cabinet_maintenance_page.dart';
import 'package:santapocket/modules/cabinet/domain/enums/cabinet_status.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_cabinet_info_usecase.dart';
import 'package:santapocket/modules/charity/app/ui/workflow/send/charity_send_package_info_page.dart';
import 'package:santapocket/modules/charity/domain/models/charity.dart';
import 'package:santapocket/modules/charity/domain/models/charity_campaign.dart';
import 'package:santapocket/modules/charity/domain/models/charity_campaign_image.dart';
import 'package:santapocket/modules/charity/domain/models/charity_donation.dart';
import 'package:santapocket/modules/charity/domain/usecases/check_if_donatable_usecase.dart';
import 'package:santapocket/modules/charity/domain/usecases/get_charity_by_id_usecase.dart';
import 'package:santapocket/modules/charity/domain/usecases/get_charity_campaign_detail_usecase.dart';
import 'package:santapocket/modules/charity/domain/usecases/get_charity_campaign_images_usecase.dart';
import 'package:santapocket/modules/charity/domain/usecases/get_charity_donations_usecase.dart';
import 'package:santapocket/modules/main/app/ui/widgets/qr_scanner_page.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CharityCampaignDetailPageViewModel extends AppViewModel {
  final GetProfileUsecase _getProfileUsecase;
  final GetCharityCampaignDetailUsecase _getCharityCampaignDetailUsecase;
  final GetCharityDonationsUsecase _getCharityDonationsUsecase;
  final GetCharityCampaignImagesUsecase _getCharityCampaignImagesUsecase;
  final GetCabinetInfoUsecase _getCabinetInfoUsecase;
  final GetCharityByIdUsecase _getCharityByIdUsecase;
  final GetSettingUsecase _getSettingUsecase;
  final CheckIfDonatableUsecase _checkIfDonatableUsecase;

  CharityCampaignDetailPageViewModel(
    this._getProfileUsecase,
    this._getCharityCampaignDetailUsecase,
    this._getCharityDonationsUsecase,
    this._getCharityCampaignImagesUsecase,
    this._getCabinetInfoUsecase,
    this._getCharityByIdUsecase,
    this._getSettingUsecase,
    this._checkIfDonatableUsecase,
  );

  final ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();

  late final String charityCampaignId;

  final _user = Rx<User?>(null);
  final _query = Rx<String>("");
  final _charities = Rx<List<Charity>>([]);
  final _canLoadMore = Rx<bool>(false);
  final _charityCampaign = Rx<CharityCampaign?>(null);
  final _charityDonors = Rx<List<CharityDonation>>([]);
  final _charityCampaignImages = Rx<List<CharityCampaignImage>>([]);
  final _helpCenterUrl = Rx<String>("");
  final _isFirstInit = Rx<bool>(true);
  final _isDonatable = Rx<bool>(false);

  User? get user => _user.value;

  String get query => _query.value;

  List<Charity> get charities => _charities.value;

  bool get canLoadMore => _canLoadMore.value;

  CharityCampaign? get charityCampaign => _charityCampaign.value;

  List<CharityDonation> get charityDonors => _charityDonors.value;

  List<CharityCampaignImage> get charityCampaignImages => _charityCampaignImages.value;

  String get helpCenterUrl => _helpCenterUrl.value;

  bool get isFirstInit => _isFirstInit.value;

  bool get isShouldGiftType => (charityCampaign?.giftType ?? "").isNotEmpty;

  bool get isShouldCharityBeneficiary => (charityCampaign?.beneficiary ?? "").isNotEmpty;

  bool get isDonatable => _isDonatable.value;

  int _page = 1;
  final int _limit = 5;
  final String _sort = "created_at";
  final String _dir = "desc";

  bool isEmptySearch = true;
  bool isEmptyList = true;

  @override
  void initState() {
    _fetchData(isShouldShowLoading: true);

    super.initState();
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

  Future<Unit> filterCabinets(String textQuery) async {
    _query.value = textQuery.trim();
    _canLoadMore.value = false;
    _page = 1;
    return _fetchData(query: textQuery, isShouldShowLoading: false);
  }

  Future<Unit> refreshCharities() async {
    textEditingController.clear();
    _query.value = "";
    _page = 1;
    await _checkIfDonatable();
    return _fetchData(isShouldShowLoading: false);
  }

  void emptyValuesBeforeFetch() {
    _user.value = null;
    _charityCampaign.value = null;
    _charityDonors.value = [];
    _charityCampaignImages.value = [];
  }

  Future<Unit> _fetchData({String? query, required bool isShouldShowLoading}) async {
    late User userFetch;
    late CharityCampaign charityCampaignFetch;
    late List<CharityDonation> charityDonationsFetched;
    late List<CharityCampaignImage> charityCampaignImagesFetch;
    final sortParams = SortParams(attribute: _sort, direction: _dir);
    if (isShouldShowLoading) await showLoading();
    final success = await run(
      () async {
        userFetch = await _getProfileUsecase.run();
        charityCampaignFetch = await _getCharityCampaignDetailUsecase.run(charityCampaignId);
        charityDonationsFetched = await _getCharityDonationsUsecase.run(id: charityCampaignId, page: _page, limit: _limit, sortParams: sortParams);
        charityCampaignImagesFetch = await _getCharityCampaignImagesUsecase.run(id: charityCampaignId, sortParams: sortParams);
      },
    );
    if (isShouldShowLoading) await hideLoading();
    if (success) {
      emptyValuesBeforeFetch();
      _user.value = userFetch;
      await _getSetting();
      _charityCampaign.value = charityCampaignFetch;
      _charityDonors.value = charityDonationsFetched;
      _charityCampaignImages.value = charityCampaignImagesFetch;
      _isFirstInit.value = false;
      await _checkIfDonatable();
    }
    return unit;
  }

  Future<Unit> handleQrCodeData({required String barcode}) async {
    final status = await QrCodeManager.instance.parseQrData(barcode);
    if (status is ValidQrStatus) {
      final CabinetInfo? cabinetInfo = await getCabinetInfo(status.uuid!, status.otp);
      final Charity? charity = await getCharityById();
      if (cabinetInfo != null) {
        if (cabinetInfo.isOnline) {
          switch (cabinetInfo.status) {
            case CabinetStatus.unknown:
            case CabinetStatus.inStock:
              showToast(LocaleKeys.charity_cabinet_can_not_use.trans());
              break;
            case CabinetStatus.production:
              if (charity != null) {
                await _handleActionScan(cabinetInfo: cabinetInfo, charity: charity);
              }
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
      showToast(LocaleKeys.charity_wrong_qr_code.trans());
    }
    return unit;
  }

  Future<Unit> _handleActionScan({required CabinetInfo cabinetInfo, required Charity charity}) async {
    await Get.to(
      () => CharitySendPackageInfoPage(
        cabinetInfo: cabinetInfo,
        charity: charity,
        charityCampaign: charityCampaign,
      ),
    );
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

  Future<Charity?> getCharityById() async {
    if (charityCampaign?.charityId == null) return null;
    late Charity? charity;
    final bool isSuccess = await run(
      () async => charity = await _getCharityByIdUsecase.run(charityCampaign!.charityId),
    );
    if (isSuccess) {
      return charity;
    }
    return null;
  }

  Future<void> onDonateNowClickButton() async {
    final barcode = await Get.to(
      () => const QRScannerPage(),
    );
    if (barcode != null) {
      await handleQrCodeData(barcode: barcode as String);
    }
  }

  Future<Unit> _checkIfDonatable() async {
    if (charityCampaign == null) return unit;
    bool isDonatableFetched = false;
    final success = await run(
      () async {
        isDonatableFetched = await _checkIfDonatableUsecase.run(id: charityCampaign!.id);
      },
    );
    if (success) {
      _isDonatable.value = isDonatableFetched;
    }
    return unit;
  }
}
