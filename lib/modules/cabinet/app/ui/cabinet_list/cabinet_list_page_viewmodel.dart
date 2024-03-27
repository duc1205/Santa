import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/helpers/loading_helper.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/helpers/location_helper.dart';
import 'package:santapocket/helpers/pagination_params.dart';
import 'package:santapocket/helpers/permission_helper.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_map/cabinet_map_page.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_cabinets_usecase.dart';
import 'package:santapocket/shared/dialog/request_location_service_dialog.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CabinetListPageViewModel extends AppViewModel {
  final GetCabinetsUsecase _getCabinetsUseCase;
  TextEditingController textEditingController = TextEditingController();

  CabinetListPageViewModel(this._getCabinetsUseCase);

  bool isFirstLoadedPublicLobby = true;
  bool isFirstLoadedinternalLobby = true;

  final _cabinets = Rx<List<Cabinet>>([]);
  final _position = Rx<Position?>(null);
  final _query = Rx<String>("");
  final _canLoadMore = Rx<bool>(false);
  final _filterCity = Rx<String>("");
  final _filterDistrict = Rx<String>("");
  final _filterAppliedCount = 0.obs;
  final _tabIndex = 0.obs;

  List<Cabinet> get cabinets => _cabinets.value;

  Position? get position => _position.value;

  String get query => _query.value;

  bool get canLoadMore => _canLoadMore.value;

  String get filterCity => _filterCity.value;

  String get filterDistrict => _filterDistrict.value;

  int get filterAppliedCount => _filterAppliedCount.value;

  int get tabIndex => _tabIndex.value;

  int _page = 1;
  final int _limit = 10;
  final String _sort = "name";
  final String _dir = "asc";

  @override
  void initState() {
    _onInit();
    super.initState();
  }

  @override
  void disposeState() {
    textEditingController.dispose();
    super.disposeState();
  }

  Future<Unit> _onInit() async {
    await showLoading();
    await _getLocation();
    await _fetchData();
    await hideLoading();
    return unit;
  }

  Future<Unit> _fetchData({
    bool showShowLoading = true,
  }) async {
    late List<Cabinet> currentCabinet;
    final listParams = ListParams(
      paginationParams: PaginationParams(page: _page, limit: _limit),
      sortParams: SortParams(attribute: _sort, direction: _dir),
    );
    if (showShowLoading) await showLoading();
    final success = await run(
      () async {
        currentCabinet = await _getCabinetsUseCase.run(
          listParams,
          query: _query.value.isNotEmpty ? query : null,
          nearBy: position != null ? _dir : null,
          latitude: position?.latitude,
          longitude: position?.longitude,
          city: filterCity.isNotEmpty ? filterCity : null,
          district: filterDistrict.isNotEmpty ? filterDistrict : null,
        );
      },
    );
    await hideLoading();
    if (success) {
      assignCabinets(currentCabinet);
    }
    return unit;
  }

  Future<Unit> _getLocation() async {
    final isLocationPermissionGranted = await PermissionHelper.instance.checkPermission(Permission.location, forceRequest: false);
    if (isLocationPermissionGranted) {
      final locationServiceEnable = await _checkLocationService();
      if (locationServiceEnable) {
        await run(
          () async => _position.value = await Geolocator.getPositionStream().first,
        );
      }
    }
    return unit;
  }

  Future<bool> _checkLocationService() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      await locator<LoadingHelper>().clear();
      await showRequestToEnableLocationService();
      return false;
    }
    return true;
  }

  Future<void> showRequestToEnableLocationService() async {
    final context = Get.context;
    if (context != null) {
      await showDialog(
        context: context,
        builder: (dialogContext) => const RequestLocationServiceDialog(),
      );
    }
  }

  Future<Unit> refreshCabinets() async {
    _position.value = null;
    textEditingController.clear();
    _query.value = "";
    _page = 1;
    _cabinets.value.clear();
    await showLoading();
    await _getLocation();
    await _fetchData(showShowLoading: false);
    await hideLoading();
    return unit;
  }

  Future<Unit> filterCabinets(String textQuery) async {
    _query.value = textQuery.trim();
    _canLoadMore.value = false;
    _page = 1;
    return _fetchData();
  }

  Future<Unit> onLoadMore() async => _fetchData(showShowLoading: false);

  double? getDistance(Cabinet cabinet) {
    final unwrapPosition = _position.value;
    if (cabinet.location == null || cabinet.location!.latitude == null || position == null || unwrapPosition == null) {
      return null;
    } else {
      final currentLocation = LatLng(unwrapPosition.latitude, unwrapPosition.longitude);
      final cabinetLat = cabinet.location?.latitude;
      final cabinetLong = cabinet.location?.longitude;
      final cabinetLatLng = LatLng(cabinetLat!, cabinetLong!);
      return LocationHelper.distance(currentLocation, cabinetLatLng);
    }
  }

  void navigateToCabinetMapPage() => Get.to(() => CabinetMapPage(position: position, listCabinet: cabinets));

  void onApplyFilter(String city, String district) {
    int count = 0;
    _filterCity.value = city;
    if (city.isNotEmpty) {
      count++;
    }
    _filterDistrict.value = district;
    if (district.isNotEmpty) {
      count++;
    }
    _filterAppliedCount.value = count;
    refreshCabinets();
  }

  void onChangeTap(int index) {
    _tabIndex.value = index;
    bool shouldRefresh = false;
    switch (index) {
      case 0:
        shouldRefresh = isFirstLoadedPublicLobby;
        break;
      case 1:
        shouldRefresh = isFirstLoadedinternalLobby;
        break;
      default:
        shouldRefresh = isFirstLoadedPublicLobby;
        break;
    }
    if (shouldRefresh) {
      refreshCabinets();
    }
  }

  void assignCabinets(List<Cabinet> currentCabinets) {
    if (_page == 1) {
      _cabinets.value = [];
    }
    _cabinets.value += currentCabinets;
    _canLoadMore.value = currentCabinets.isNotEmpty;
    isFirstLoadedinternalLobby = false;
    _page++;
  }
}
