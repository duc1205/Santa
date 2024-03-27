import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/location_helper.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_detail/cabinet_detail_page.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_map/cabinet_map_page_viewmodel.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class CabinetMapPage extends StatefulWidget {
  const CabinetMapPage({Key? key, required this.position, required this.listCabinet}) : super(key: key);

  final Position? position;
  final List<Cabinet> listCabinet;

  @override
  State<CabinetMapPage> createState() => _CabinetMapPageState();
}

class _CabinetMapPageState extends BaseViewState<CabinetMapPage, CabinetMapPageViewModel> {
  @override
  CabinetMapPageViewModel createViewModel() => locator<CabinetMapPageViewModel>();

  @override
  void loadArguments() {
    viewModel.setPosition(widget.position);
    viewModel.setCabinet(widget.listCabinet);
    super.loadArguments();
  }

  @override
  void initState() {
    final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadData(MediaQuery.of(context).devicePixelRatio.round() * 24);
    });
  }

  Future<Unit> loadData(int width) async {
    await viewModel.initDataMap(width);
    setState(() {});
    return unit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Obx(
              () => GoogleMap(
                onMapCreated: viewModel.onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    viewModel.getCabinetLat(),
                    viewModel.getCabinetLong(),
                  ),
                  zoom: LocationHelper.radiusToZoom(5),
                ),
                markers: viewModel.markers,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                compassEnabled: false,
              ),
            ),
            IconButton(
              icon: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Get.back(),
            ),
            Obx(
              () => Visibility(
                visible: viewModel.currentCabinet != null,
                child: Positioned(
                  bottom: 60.0,
                  child: InkWell(
                    onTap: () => Get.to(() => CabinetDetailPage(cabinetId: viewModel.currentCabinet!.id)),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 32,
                      padding: EdgeInsets.all(
                        16.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(
                          16.r,
                        ),
                      ),
                      margin: EdgeInsets.only(
                        left: 16.w,
                        top: 16.h,
                        right: 16.w,
                      ),
                      child: Row(
                        children: [
                          Assets.icons.icCabinetLocation.image(
                            width: 32.w,
                            height: 32.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    viewModel.currentCabinet?.name ?? "",
                                    style: AppTheme.white_16w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    viewModel.currentCabinet?.location?.address ?? "",
                                    style: AppTheme.white_14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
