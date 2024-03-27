import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/charity/domain/models/charity_donation.dart';
import 'package:santapocket/modules/charity/domain/usecases/get_charity_donations_usecase.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CharityDonorsPageViewModel extends AppViewModel {
  final GetProfileUsecase _getProfileUsecase;
  final GetCharityDonationsUsecase _getCharityDonationsUsecase;
  final GetSettingUsecase _getSettingUsecase;

  CharityDonorsPageViewModel(
    this._getProfileUsecase,
    this._getCharityDonationsUsecase,
    this._getSettingUsecase,
  );

  late final String charityCampaignId;

  TextEditingController textEditingController = TextEditingController();
  final scrollController = ScrollController();

  final _user = Rx<User?>(null);
  final _query = Rx<String>("");
  final _canLoadMore = Rx<bool>(false);
  final _charityDonors = Rx<List<CharityDonation>>([]);
  final _helpCenterUrl = Rx<String>("");
  final _isLoadingMore = false.obs;

  User? get user => _user.value;

  String get query => _query.value;

  bool get canLoadMore => _canLoadMore.value;

  List<CharityDonation> get charityDonors => _charityDonors.value;

  String get helpCenterUrl => _helpCenterUrl.value;

  bool get isLoadingMore => _isLoadingMore.value;

  int _page = 1;
  final int _limit = 15;
  final String _sort = "created_at";
  final String _dir = "desc";
  int endReachedThreshold = 40;

  bool isEmptySearch = true;
  bool isEmptyList = true;

  @override
  void initState() {
    _initListener();
    fetchAndSearchData(isShouldShowLoading: true);
    super.initState();
  }

  void _initListener() {
    scrollController.addListener(() {
      onListViewScroll();
    });
  }

  @override
  void disposeState() {
    scrollController.dispose();
    super.disposeState();
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
    return fetchAndSearchData(isShouldShowLoading: false);
  }

  Future<Unit> fetchAndSearchData({String? query, required bool isShouldShowLoading}) async {
    late User userFetch;
    late List<CharityDonation> charityDonationsFetched;
    final sortParams = SortParams(attribute: _sort, direction: _dir);
    if (isShouldShowLoading) await showLoading();
    final success = await run(
      () async {
        charityDonationsFetched =
            await _getCharityDonationsUsecase.run(id: charityCampaignId, page: _page, limit: _limit, sortParams: sortParams, query: query);
        userFetch = await _getProfileUsecase.run();
      },
    );
    if (isShouldShowLoading) await hideLoading();
    if (success) {
      _user.value = userFetch;
      await _getSetting();
      if (_page == 1) {
        _charityDonors.value = [];
      }
      _charityDonors.value += charityDonationsFetched;
      _canLoadMore.value = charityDonationsFetched.isNotEmpty;
      _page++;
      if (_charityDonors.value.isEmpty) {
        isEmptyList = query == null;
        isEmptySearch = query != null;
      } else {
        isEmptySearch = false;
        isEmptyList = false;
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

  Future<Unit> onListViewScroll() async {
    if (!scrollController.hasClients || isLoadingMore) {
      return unit;
    }
    if (!canLoadMore) {
      return unit;
    }
    if (scrollController.position.atEdge) {
      bool isTop = scrollController.position.pixels == 0;
      if (!isTop) {
        await _onLoadMore();
      }
    }
    return unit;
  }

  Future<Unit> _onLoadMore() async {
    _isLoadingMore.value = true;
    await fetchAndSearchData(isShouldShowLoading: false);
    _isLoadingMore.value = false;
    return unit;
  }
}
