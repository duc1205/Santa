import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/location_helper.dart';
import 'package:santapocket/helpers/utils.dart' as utils;
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CabinetMapPageViewModel extends AppViewModel {
  final Completer<GoogleMapController> _controller = Completer();

  final _defaultLocation = const LatLng(10.762622, 106.660172);
  final double radius = 5;
  String? mapStyle;
  Uint8List? markerIcon;

  final _markers = Rx<List<Marker>>([]);
  final _currentCabinet = Rx<Cabinet?>(null);
  final _position = Rx<Position?>(null);
  final _cabinets = Rx<List<Cabinet>>([]);

  Cabinet? get currentCabinet => _currentCabinet.value;

  List<Cabinet> get cabinets => _cabinets.value;

  Set<Marker> get markers => _markers.value.toSet();

  Position? get position => _position.value;

  Position? setPosition(Position? currentPosition) => _position.value = currentPosition;

  List<Cabinet> setCabinet(List<Cabinet> listCabinet) => _cabinets.value = listCabinet;

  double getCabinetLat() => position?.latitude ?? _defaultLocation.latitude;

  double getCabinetLong() => position?.longitude ?? _defaultLocation.longitude;

  Future<Unit> initDataMap(int width) async {
    // set customMarker
    markerIcon = await utils.getBytesFromAsset(Assets.icons.icCabinetMaker.path, width);
    await _initResource();
    await _initMarker();
    await _movePositionCamera();
    return unit;
  }

  Future<Unit> _initResource() async {
    mapStyle = await rootBundle.loadString("assets/map_style.txt");
    return unit;
  }

  Future _initMarker() async {
    if (cabinets.isEmpty) return;
    _markers.value.addAll(
      cabinets.where((cabinet) => cabinet.location?.latitude != null && cabinet.location?.longitude != null).map(
            (cabinet) => Marker(
              icon: BitmapDescriptor.fromBytes(markerIcon!),
              position: LatLng(cabinet.location!.latitude!, cabinet.location!.longitude!),
              markerId: MarkerId('marker_${cabinet.id}'),
              infoWindow: InfoWindow(title: cabinet.name),
              onTap: () => _currentCabinet.value = cabinet,
            ),
          ),
    );
  }

  Future<Unit> _movePositionCamera() async {
    final GoogleMapController controller = await _controller.future;
    await controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            position?.latitude ?? _defaultLocation.latitude,
            position?.longitude ?? _defaultLocation.longitude,
          ),
          zoom: LocationHelper.radiusToZoom(radius),
        ),
      ),
    );
    return unit;
  }

  void onMapCreated(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      controller.setMapStyle(mapStyle);
      _controller.complete(controller);
    }
  }
}
