import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_maintenance/cabinet_maintenance_page_viewmodel.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class CabinetMaintenancePage extends StatefulWidget {
  final String cabinetName;

  const CabinetMaintenancePage({Key? key, required this.cabinetName}) : super(key: key);

  @override
  State<CabinetMaintenancePage> createState() => _CabinetMaintenancePageState();
}

class _CabinetMaintenancePageState extends BaseViewState<CabinetMaintenancePage, CabinetMaintenancePageViewModel> {
  @override
  CabinetMaintenancePageViewModel createViewModel() => locator<CabinetMaintenancePageViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 175.h,
          ),
          Assets.images.imgCabinetMaintenanceBackground.image(
            width: 286.w,
            height: 124.h,
          ),
          SizedBox(
            height: 24.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Text(
              LocaleKeys.cabinet_maintenance_title.trans(namedArgs: {"cabinetName": widget.cabinetName}),
              textAlign: TextAlign.center,
              style: AppTheme.black_14w400,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => callHotLine(viewModel.bankTransferInfo["contacts"]["call"]["value"]),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Container(
                    width: 130.w,
                    padding: EdgeInsets.only(
                      top: 4.h,
                      bottom: 10.h,
                    ),
                    child: Column(
                      children: [
                        Assets.icons.icPhone.image(),
                        SizedBox(
                          height: 6.h,
                        ),
                        Text(
                          LocaleKeys.cabinet_maintenance_call_hotline.trans(),
                          style: AppTheme.black_14w600,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15.w,
              ),
              GestureDetector(
                onTap: () {
                  launchUri("http://zalo.me/${viewModel.bankTransferInfo["contacts"]["zalo"]["value"]}");
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Container(
                    width: 130.w,
                    padding: EdgeInsets.only(
                      top: 4.h,
                      bottom: 10.h,
                    ),
                    child: Column(
                      children: [
                        Assets.icons.icHomeZalo.image(),
                        SizedBox(
                          height: 6.h,
                        ),
                        Text(
                          LocaleKeys.cabinet_maintenance_chat_zalo.trans(),
                          style: AppTheme.black_14w600,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 50.h,
            width: 300.w,
            margin: EdgeInsets.symmetric(horizontal: 37.5.w, vertical: 30.h),
            child: SizedBox.expand(
              child: ElevatedButton(
                onPressed: () => Get.until((route) => Get.currentRoute == '/MainPage'),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppTheme.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    LocaleKeys.cabinet_maintenance_back_home.trans(),
                    style: AppTheme.white_16w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
