import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/helpers/location_helper.dart';
import 'package:santapocket/helpers/pagination_params.dart';
import 'package:santapocket/helpers/permission_helper.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_cabinets_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class FilterCabinetsViewModel extends AppViewModel {
  final GetCabinetsUsecase _getCabinetsUseCase;

  FilterCabinetsViewModel(this._getCabinetsUseCase);

  final _cabinets = RxList<Cabinet>([]);
  final _canLoadMore = Rx<bool>(false);
  final _position = Rx<Position?>(null);
  final _filterCabinet = Rx<Cabinet?>(null);
  final _isCanClearSearch = false.obs;

  int _page = 1;
  final int _limit = 10;
  final String _sort = "name";
  final String _dir = "asc";

  final searchTextController = TextEditingController();

  Position? get position => _position.value;

  List<Cabinet> get cabinets => _cabinets.toList();

  Cabinet? get selectedCabinet => _filterCabinet.value;

  bool get canLoadMore => _canLoadMore.value;

  bool get isCanClearSearch => _isCanClearSearch.value;

  void setSelectedCabinet(Cabinet? cabinet) {
    _filterCabinet.value = _filterCabinet.value?.id != cabinet?.id ? cabinet : null;
  }

  @override
  void initState() {
    searchTextController.addListener(() => _isCanClearSearch.value = searchTextController.text.trim().isNotEmpty);
    _initData();
    super.initState();
  }

  Future<Unit> _initData() async {
    await showLoading();
    await _getLocation();
    await _fetchData();
    await hideLoading();
    return unit;
  }

  Future<Unit> _fetchData() async {
    late List<Cabinet> currentCabinet;
    final listParams = ListParams(
      paginationParams: PaginationParams(page: _page, limit: _limit),
      sortParams: SortParams(attribute: _sort, direction: _dir),
    );
    final query = searchTextController.text.isNotEmpty ? searchTextController.text : null;
    await showLoading();
    final success = await run(
      () async {
        currentCabinet = await _getCabinetsUseCase.run(
          listParams,
          query: query,
        );
      },
    );
    await hideLoading();
    if (success) {
      if (_page == 1) {
        _cabinets.value = [];
      }
      _cabinets.value += currentCabinet;
      _canLoadMore.value = currentCabinet.isNotEmpty;
      _page++;
    }
    return unit;
  }

  Future<Unit> _getLocation() async {
    if (position == null) {
      final isLocationPermissionGranted = await PermissionHelper.instance.checkPermission(Permission.location, forceRequest: false);
      if (isLocationPermissionGranted) {
        try {
          _position.value = await Geolocator.getPositionStream().first;
        } catch (_) {}
      }
    }
    return unit;
  }

  double getDistance(Cabinet cabinet) {
    if (cabinet.location == null || cabinet.location!.latitude == null || position == null) {
      return 0.0;
    }
    final currentLocation = LatLng(position!.latitude, position!.longitude);
    final cabinetLat = cabinet.location?.latitude;
    final cabinetLong = cabinet.location?.longitude;
    final cabinetLatLng = LatLng(cabinetLat!, cabinetLong!);
    return LocationHelper.distance(currentLocation, cabinetLatLng);
  }

  void onRefresh() {
    _canLoadMore.value = false;
    _page = 1;
    _fetchData();
  }

  void onClearSearch() {
    searchTextController.clear();
    onRefresh();
  }

  void onLoadMore() {
    _fetchData();
  }
}
