import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/charity/app/ui/charity_campaign_detail/charity_campaign_detail_page.dart';
import 'package:santapocket/modules/charity/domain/models/charity.dart';
import 'package:santapocket/modules/charity/domain/models/charity_campaign.dart';
import 'package:santapocket/modules/charity/domain/usecases/get_available_charity_campaigns_usecase.dart';
import 'package:santapocket/modules/charity/domain/usecases/get_charity_by_id_usecase.dart';
import 'package:santapocket/modules/connection/domain/enums/connection_status.dart';
import 'package:santapocket/modules/connection/domain/events/connection_status_changed_event.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CharityOrganizationDetailPageViewModel extends AppViewModel {
  final GetAvailableCharityCampaignsUsecase _getAvailbleCharityCampaignsUsecase;
  final GetSettingUsecase _getSettingUsecase;
  final GetCharityByIdUsecase _getCharityByIdUsecase;
  final GetProfileUsecase _getProfileUsecase;

  CharityOrganizationDetailPageViewModel(
    this._getAvailbleCharityCampaignsUsecase,
    this._getSettingUsecase,
    this._getCharityByIdUsecase,
    this._getProfileUsecase,
  );

  late TextPainter textPainter;
  late String charityId;

  final _canViewMore = Rx<bool>(false);

  final _charityCampaigns = Rx<List<CharityCampaign>>([]);

  final _canLoadMore = Rx<bool>(false);

  final _helpCenterUrl = Rx<String>("");

  final _charity = Rx<Charity?>(null);

  final _user = Rx<User?>(null);

  bool get canViewMore => _canViewMore.value;

  List<CharityCampaign> get charities => _charityCampaigns.value;

  bool get canLoadMore => _canLoadMore.value;

  String get helpCenterUrl => _helpCenterUrl.value;

  Charity? get charity => _charity.value;

  User? get user => _user.value;

  Unit setCharityId(Charity charity) {
    charityId = (charity.id);
    return unit;
  }

  int _page = 1;
  final int _limit = 10;
  final String _sort = "created_at";
  final String _dir = "desc";
  bool isEmptyList = true;

  StreamSubscription? _listenInternetConnection;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    registerEvent();
    fetchData(isShouldShowLoading: true);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset && charities.length % 10 == 0 && _canLoadMore.value) {
        fetchData(isShouldShowLoading: false);
      }
    });
  }

  @override
  void disposeState() {
    _listenInternetConnection?.cancel();
    super.disposeState();
  }

  void registerEvent() {
    _listenInternetConnection = locator<EventBus>().on<ConnectionStatusChangedEvent>().listen((event) {
      if (event.status == ConnectionStatus.connected) {
        _charityCampaigns.value.clear();
        fetchData(isShouldShowLoading: true);
      }
    });
  }

  Future<Unit> refreshIndicator() async {
    _page = 1;
    return fetchData(isShouldShowLoading: false);
  }

  Unit setCanViewMore() {
    _canViewMore.value = (!canViewMore);
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

  Future<Unit> fetchData({String? query, required bool isShouldShowLoading}) async {
    late List<CharityCampaign> charityCampaigns;
    late Charity charity;
    late User userFetch;
    final sortParams = SortParams(attribute: _sort, direction: _dir);
    if (isShouldShowLoading) await showLoading();
    final success = await run(
      () async {
        charityCampaigns =
            await _getAvailbleCharityCampaignsUsecase.run(id: charityId, sortParams: sortParams, page: _page, limit: _limit, query: query);
        charity = await _getCharityByIdUsecase.run(charityId);
        userFetch = await _getProfileUsecase.run();
      },
    );
    if (isShouldShowLoading) await hideLoading();
    if (success) {
      _user.value = userFetch;
      await _getSetting();
      if (_page == 1) {
        _charityCampaigns.value.clear();
      }
      _charity.value = null;
      _charity.value = charity;
      _charityCampaigns.value += charityCampaigns;
      _canLoadMore.value = charityCampaigns.isNotEmpty;
      _page++;
      isEmptyList = _charityCampaigns.value.isEmpty ? query == null : false;
    }
    return unit;
  }

  void navigateToCharityCampaignDetailPage(int index) {
    Get.to(
      () => CharityCampaignDetailPage(
        charityCampaignId: charities.elementAt(index).id,
      ),
    );
  }
}
