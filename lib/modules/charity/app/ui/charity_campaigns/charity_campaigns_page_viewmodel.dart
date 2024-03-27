import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/charity/domain/models/charity_campaign.dart';
import 'package:santapocket/modules/charity/domain/usecases/get_charity_campaigns_usecase.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CharityCampaignsPageViewModel extends AppViewModel {
  final GetCharityCampaignsUsecase _getCharityCampaignsUsecase;
  final GetSettingUsecase _getSettingUsecase;
  final GetProfileUsecase _getProfileUsecase;

  CharityCampaignsPageViewModel(
    this._getCharityCampaignsUsecase,
    this._getSettingUsecase,
    this._getProfileUsecase,
  );

  final ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();

  late String charityCampaignId;

  final _user = Rx<User?>(null);
  final _query = Rx<String>("");
  final _charityCampaigns = Rx<List<CharityCampaign>>([]);
  final _canLoadMore = Rx<bool>(false);
  final _helpCenterUrl = Rx<String>("");

  User? get user => _user.value;

  String get query => _query.value;

  List<CharityCampaign> get charityCampaigns => _charityCampaigns.value;

  bool get canLoadMore => _canLoadMore.value;

  String get helpCenterUrl => _helpCenterUrl.value;

  int _page = 1;
  final int _limit = 10;
  final String _sort = "created_at";
  final String _dir = "desc";

  bool isEmptySearch = true;
  bool isEmptyList = true;

  @override
  void initState() {
    fetchAndSearchData(isShouldShowLoading: true);
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
    return fetchAndSearchData(query: textQuery, isShouldShowLoading: false);
  }

  Future<Unit> refreshCharities() async {
    textEditingController.clear();
    _query.value = "";
    _page = 1;
    return fetchAndSearchData(isShouldShowLoading: true);
  }

  Future<Unit> fetchAndSearchData({String? query, required bool isShouldShowLoading}) async {
    late List<CharityCampaign> charityCampaignsFetch;
    late User userFetch;
    final sortParams = SortParams(attribute: _sort, direction: _dir);
    if (isShouldShowLoading) await showLoading();
    final success = await run(
      () async {
        userFetch = await _getProfileUsecase.run();
        charityCampaignsFetch =
            await _getCharityCampaignsUsecase.run(id: charityCampaignId, sortParams: sortParams, page: _page, limit: _limit, query: query);
      },
    );
    if (isShouldShowLoading) await hideLoading();
    if (success) {
      _user.value = userFetch;
      await _getSetting();
      if (_page == 1) {
        _charityCampaigns.value.clear();
      }
      _charityCampaigns.value += charityCampaignsFetch;
      _canLoadMore.value = charityCampaignsFetch.isNotEmpty;
      _page++;
      if (_charityCampaigns.value.isEmpty) {
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
