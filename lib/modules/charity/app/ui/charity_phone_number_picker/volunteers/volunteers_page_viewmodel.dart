import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/charity/domain/models/volunteer.dart';
import 'package:santapocket/modules/charity/domain/usecases/get_charity_volunteers_usecase.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class VolunteersPageViewModel extends AppViewModel {
  final GetCharityVolunteersUsecase _getCharityVolunteersUsecase;

  VolunteersPageViewModel(this._getCharityVolunteersUsecase);

  late TextEditingController controller;

  int _page = 1;
  final int _limit = 10;
  final String _sort = "name";
  final String _dir = "asc";

  bool isFirstInit = true;

  late Delivery delivery;

  final _listVolunteers = Rx<List<Volunteer>>([]);
  final _selectedIndex = Rx<int>(-1);
  final _query = Rx<String>("");
  final _canLoadMore = Rx<bool>(false);

  int get selectedIndex => _selectedIndex.value;

  String get query => _query.value;

  bool get canLoadMore => _canLoadMore.value;

  List<Volunteer> get listVolunteers => _listVolunteers.value;

  Future<Unit> onLoadMore() async => _fetchAndSearchData(isShouldShowLoading: false);

  @override
  void initState() {
    controller = TextEditingController();
    _fetchAndSearchData(isShouldShowLoading: true);
    isFirstInit = false;
    super.initState();
  }

  @override
  void disposeState() {
    //controller.dispose();
    super.initState();
  }

  void onClearQueryText() {
    controller.clear();
    _query("");
    _fetchAndSearchData(isShouldShowLoading: false);
  }

  Future<Unit> filterCabinets(String textQuery) async {
    _query.value = textQuery.trim();
    _canLoadMore.value = false;
    _selectedIndex(-1);
    _page = 1;
    return _fetchAndSearchData(query: textQuery, isShouldShowLoading: false);
  }

  Future<Unit> refreshCharities(bool isShouldShowLoading) async {
    controller.clear();
    _query.value = "";
    _page = 1;
    return _fetchAndSearchData(isShouldShowLoading: isShouldShowLoading);
  }

  Future<Unit> _fetchAndSearchData({String? query, required bool isShouldShowLoading}) async {
    late List<Volunteer> listVolunteersLoaded;
    final sortParams = SortParams(attribute: _sort, direction: _dir);
    if (isShouldShowLoading && !isFirstInit) await showLoading();
    final success = await run(
      () async {
        listVolunteersLoaded =
            await _getCharityVolunteersUsecase.run(sortParams: sortParams, page: _page, limit: _limit, query: query, id: delivery.charity!.id);
      },
    );
    if (success) {
      if (_page == 1) {
        _listVolunteers.value.clear();
      }
      _listVolunteers.value += listVolunteersLoaded;
      _canLoadMore.value = listVolunteersLoaded.isNotEmpty;
      _page++;
    }
    if (isShouldShowLoading && !isFirstInit) await hideLoading();
    return unit;
  }

  void onItemClick(int index) => _selectedIndex(index);
}
