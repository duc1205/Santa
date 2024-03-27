import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/location_helper.dart';
import 'package:santapocket/helpers/permission_helper.dart';
import 'package:santapocket/helpers/utils.dart' as utils;
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket_size.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_cabinet_usecase.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_pocket_sizes_usecase.dart';
import 'package:santapocket/modules/delivery/app/ui/helper/pocket_helper.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CabinetDetailPageViewModel extends AppViewModel {
  final GetPocketSizesUsecase _getPocketSizesUsecase;
  final GetCabinetUsecase _getCabinetUsecase;

  CabinetDetailPageViewModel(this._getCabinetUsecase, this._getPocketSizesUsecase);

  final Completer<GoogleMapController> _controller = Completer();

  late int cabinetId;

  final _markerIcon = Rx<Uint8List?>(null);
  final _defaultLocation = const LatLng(10.762622, 106.660172);
  final _cabinet = Rx<Cabinet?>(null);
  final _pocketSizes = Rx<List<PocketSize>>([]);
  final _position = Rx<Position?>(null);
  final _mapStyle = Rx<String?>(null);
  final _markers = Rx<List<Marker>>([]);
  final _isMapReady = Rx<bool>(false);

  bool get isMapReady => _isMapReady.value;

  Uint8List? get markerIcon => _markerIcon.value;

  Cabinet? get cabinet => _cabinet.value;

  List<PocketSize> get pocketSizes => _pocketSizes.value;

  Position? get position => _position.value;

  String? get mapStyle => _mapStyle.value;

  Set<Marker> get markers => _markers.value.toSet();

  String getCabinetName() => cabinet?.name ?? '';

  String getCabinetAddress() => cabinet?.location?.address ?? '';

  int getPhotosLength() => cabinet?.photos?.length ?? 0;

  String getPhotoUrl(int index) => cabinet?.photos?.elementAt(index).url ?? '';

  int get getPocketSizesLength => pocketSizes.length;

  List<String> getGalleryList() => _cabinet.value?.photos?.map((e) => e.url).toList() ?? [];

  bool get isOnline => cabinet?.isOnline ?? false;

  String getPocketHeight(int index) => pocketSizes[index].height.toString();

  String getPocketWidth(int index) => pocketSizes[index].width.toString();

  Color getPocketColor(int index) => pocketColor(pocketSizes[index].uuid);

  String getPocketFirstCharacterName(int index) => pocketSizes[index].name[0];

  bool isAvailable(int index) => (pocketSizes[index].availablePocketsCount) != 0;

  String getPocketCount(int index) => pocketSizes[index].availablePocketsCount.toString();

  double getUserLat() => position?.latitude ?? _defaultLocation.latitude;

  double getUserLong() => position?.longitude ?? _defaultLocation.longitude;

  double getCabinetLat() => cabinet?.location?.latitude ?? _defaultLocation.latitude;

  double getCabinetLong() => cabinet?.location?.longitude ?? _defaultLocation.longitude;

  bool isLocationUndefined() => cabinet?.location?.latitude == null || cabinet?.location?.longitude == null;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<Unit> _fetchData() async {
    late List<PocketSize> pocketSizes;
    late Cabinet cabinet;

    await showLoading();
    final success = await run(
      () async {
        pocketSizes = await _getPocketSizesUsecase.run(cabinetId);
        cabinet = await _getCabinetUsecase.run(cabinetId);
      },
    );

    if (success) {
      _pocketSizes.value = pocketSizes;
      _cabinet.value = cabinet;
      _isMapReady.value = true;
    }
    await hideLoading();

    return unit;
  }

  Future<Unit> loadMap(int width) async {
    final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
    await _setCustomMarker(width);
    await _initMap();
    //wait for initMap done for getting marker
    await Future.delayed(const Duration(milliseconds: 1000));
    await _initMarker();
    await _movePositionCamera();
    return unit;
  }

  Future<Unit> _setCustomMarker(int width) async {
    _markerIcon.value = await utils.getBytesFromAsset(Assets.icons.icCabinetMaker.path, width);
    return unit;
  }

  void onMapCreated(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      controller.setMapStyle(mapStyle);
      _controller.complete(controller);
    }
  }

  Future<Unit> _initMap() async {
    final isLocationPermissionGranted = await PermissionHelper.instance.checkPermission(Permission.location, forceRequest: false);

    if (isLocationPermissionGranted) {
      try {
        _position.value = await Geolocator.getPositionStream().first;
      } catch (_) {}
    }

    _mapStyle.value = await rootBundle.loadString("assets/map_style.txt");
    return unit;
  }

  Future<Unit> _initMarker() async {
    if (isLocationUndefined()) return unit;
    _markers.value.add(
      Marker(
        icon: BitmapDescriptor.fromBytes(markerIcon!),
        position: LatLng(getCabinetLat(), getCabinetLong()),
        markerId: MarkerId('marker_ $cabinetId'),
        infoWindow: InfoWindow(title: getCabinetName()),
      ),
    );
    return unit;
  }

  Future<Unit> _movePositionCamera() async {
    final GoogleMapController controller = await _controller.future;
    await controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            getCabinetLat(),
            getCabinetLong(),
          ),
          zoom: LocationHelper.radiusToZoom(5),
        ),
      ),
    );
    return unit;
  }

  Future<Unit> disposeGoogleMap() async {
    await showLoading();
    final GoogleMapController controller = await _controller.future;
    _isMapReady.value = false;
    controller.dispose();
    await Future.delayed(const Duration(milliseconds: 500));
    await hideLoading();
    Get.back();
    return unit;
  }
}
