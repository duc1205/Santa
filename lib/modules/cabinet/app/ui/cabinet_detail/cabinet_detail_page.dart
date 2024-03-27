import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/location_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_detail/cabinet_detail_page_view_model.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_detail/gallery/cabinet_gallery_item_view.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_detail/gallery/gallery_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/fill_info/pocket_sizes_widget.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class CabinetDetailPage extends StatefulWidget {
  final int cabinetId;

  const CabinetDetailPage({required this.cabinetId, Key? key}) : super(key: key);

  @override
  State<CabinetDetailPage> createState() => _CabinetDetailPageState();
}

class _CabinetDetailPageState extends BaseViewState<CabinetDetailPage, CabinetDetailPageViewModel> {
  @override
  CabinetDetailPageViewModel createViewModel() => locator<CabinetDetailPageViewModel>();

  final _contentKey = GlobalKey();
  Size? _size;

  double _getMaxChildSize(double maxHeight) {
    final calculatedHeight = _size?.height ?? maxHeight;
    final aspect = calculatedHeight > maxHeight ? 0.5 : calculatedHeight / maxHeight;
    return aspect.toDouble();
  }

  @override
  void loadArguments() {
    viewModel.cabinetId = widget.cabinetId;
    super.loadArguments();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData(MediaQuery.of(context).devicePixelRatio.round() * 48);
      setState(() {
        _size = _contentKey.currentContext?.size;
      });
    });
  }

  Future<Unit> _loadData(int width) async {
    await viewModel.loadMap(width);
    setState(() {});
    return unit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          LocaleKeys.cabinet_detail_title.trans().toUpperCase(),
          style: AppTheme.black_16w600,
        ),
        backgroundColor: AppTheme.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: GestureDetector(
          onTap: () => viewModel.disposeGoogleMap(),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Visibility(
                    visible: viewModel.isMapReady,
                    child: Expanded(
                      child: GoogleMap(
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: viewModel.isMapReady,
                child: LayoutBuilder(
                  builder: (context, constraints) => DraggableScrollableSheet(
                    initialChildSize: 0.150,
                    minChildSize: 0.150,
                    maxChildSize: _getMaxChildSize(constraints.maxHeight),
                    builder: (BuildContext context, ScrollController scrollController) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                          key: _contentKey,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              Center(child: Assets.icons.icCabinetDetailScrollBar.image()),
                              SizedBox(
                                height: 14.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(viewModel.getCabinetName(), style: AppTheme.black_25w600),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          SizedBox(child: Text(viewModel.getCabinetAddress(), style: AppTheme.black_14w400)),
                                        ],
                                      ),
                                    ),
                                    viewModel.isOnline
                                        ? Assets.icons.icCabinetDetailWifiConnect.image()
                                        : Assets.icons.icCabinetDetailWifiDisconnect.image(),
                                  ],
                                ),
                              ),
                              Obx(
                                () => PocketSizesWidget(
                                  pocketSizes: viewModel.pocketSizes,
                                  selectedPocketSizeIndex: -1,
                                  onSelectPocket: (_) {},
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Obx(
                                () => Visibility(
                                  visible: viewModel.getPhotosLength() != 0,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 16.w,
                                        ),
                                        child: Text(
                                          LocaleKeys.cabinet_detail_gallery.trans(),
                                          style: AppTheme.black_16w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6.h,
                                      ),
                                      SizedBox(
                                        height: 150.h,
                                        child: ListView.separated(
                                          separatorBuilder: (context, index) => SizedBox(
                                            width: 8.w,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                          ),
                                          physics: const ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: viewModel.getPhotosLength(),
                                          itemBuilder: (BuildContext context, int index) {
                                            return CabinetGalleryItemView(
                                              linkImage: viewModel.getPhotoUrl(index),
                                              onItemClick: () => Get.to(() => GalleryPage(index: index, sources: viewModel.getGalleryList())),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
