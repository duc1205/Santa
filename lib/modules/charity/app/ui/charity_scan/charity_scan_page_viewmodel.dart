import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/deeplink/qr_code_manager.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_maintenance/cabinet_maintenance_page.dart';
import 'package:santapocket/modules/cabinet/domain/enums/cabinet_status.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_cabinet_info_usecase.dart';
import 'package:santapocket/modules/charity/app/ui/charity_organization_detail/charity_organization_detail_page.dart';
import 'package:santapocket/modules/charity/app/ui/workflow/send/charity_send_package_info_page.dart';
import 'package:santapocket/modules/charity/domain/models/charity.dart';
import 'package:santapocket/modules/charity/domain/usecases/get_charities_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CharityScanPageViewModel extends AppViewModel {
  final GetProfileUsecase _getProfileUsecase;
  final GetCharitiesUsecase _getCharitiesusecase;
  final GetCabinetInfoUsecase _getCabinetInfoUsecase;

  CharityScanPageViewModel(
    this._getProfileUsecase,
    this._getCharitiesusecase,
    this._getCabinetInfoUsecase,
  );

  final ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();

  final _user = Rx<User?>(null);
  final _query = Rx<String>("");
  final _charities = Rx<List<Charity>>([]);
  final _canLoadMore = Rx<bool>(false);

  User? get user => _user.value;

  bool get isEnglish => (user?.locale ?? "en") == "en";

  String get query => _query.value;

  List<Charity> get charities => _charities.value;

  bool get canLoadMore => _canLoadMore.value;

  int _page = 1;
  final int _limit = 10;

  bool isEmptySearch = true;
  bool isEmptyList = true;

  @override
  void initState() {
    _fetchAndSearchData(isShouldShowLoading: true);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset && charities.length % 10 == 0 && _canLoadMore.value) {
        _fetchAndSearchData(isShouldShowLoading: true);
      }
    });
    super.initState();
  }

  Future<void> onClickButton(Charity charity) async {
    await Get.to(() => CharityOrganizationDetailPage(
          charity: charity,
        ));
  }

  Future<Unit> handleQrCodeData({required String barcode, required Charity charity}) async {
    final status = await QrCodeManager.instance.parseQrData(barcode);
    if (status is ValidQrStatus) {
      final CabinetInfo? cabinetInfo = await getCabinetInfo(status.uuid!, status.otp);
      if (cabinetInfo != null) {
        if (cabinetInfo.isOnline) {
          switch (cabinetInfo.status) {
            case CabinetStatus.unknown:
            case CabinetStatus.inStock:
              showToast(LocaleKeys.charity_cabinet_can_not_use.trans());
              break;
            case CabinetStatus.production:
              await _handleActionScan(cabinetInfo: cabinetInfo, charity: charity);
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

  Future<Unit> filterCabinets(String textQuery) async {
    _query.value = textQuery.trim();
    _canLoadMore.value = false;
    _page = 1;
    return _fetchAndSearchData(query: textQuery, isShouldShowLoading: false);
  }

  Future<Unit> refreshCharities() async {
    textEditingController.clear();
    _query.value = "";
    _page = 1;
    return _fetchAndSearchData(isShouldShowLoading: false);
  }

  Future<Unit> _fetchAndSearchData({String? query, required bool isShouldShowLoading}) async {
    late List<Charity> currentCabinet;
    late User userFetch;
    if (isShouldShowLoading) await showLoading();
    final success = await run(
      () async {
        currentCabinet = await _getCharitiesusecase.run(page: _page, limit: _limit, query: query);
        userFetch = await _getProfileUsecase.run();
      },
    );
    if (isShouldShowLoading) await hideLoading();
    if (success) {
      _user.value = userFetch;
      if (_page == 1) {
        _charities.value.clear();
      }
      _charities.value += currentCabinet;
      _canLoadMore.value = currentCabinet.isNotEmpty;
      if (_charities.value.length >= _limit) _page++;
      if (_charities.value.isEmpty) {
        isEmptyList = query == null;
        isEmptySearch = query != null;
      } else {
        isEmptySearch = false;
        isEmptyList = false;
      }
    }
    return unit;
  }
}
