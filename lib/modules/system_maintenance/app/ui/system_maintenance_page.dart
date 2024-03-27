import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/system_maintenance/app/ui/system_maintenance_page_view_model.dart';
import 'package:santapocket/modules/system_maintenance/domain/models/system_maintenance.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class SystemMaintenancePage extends StatefulWidget {
  final SystemMaintenance runningSystemMaintenance;

  const SystemMaintenancePage({
    Key? key,
    required this.runningSystemMaintenance,
  }) : super(key: key);

  @override
  State<SystemMaintenancePage> createState() => _SystemMaintenancePageState();
}

class _SystemMaintenancePageState extends BaseViewState<SystemMaintenancePage, SystemMaintenancePageViewModel> {
  @override
  SystemMaintenancePageViewModel createViewModel() => locator<SystemMaintenancePageViewModel>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 13.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 250.h,
              ),
              Image.asset(
                Assets.images.imgSystemMaintenanceBackground.path,
                height: 196.h,
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                LocaleKeys.system_maintenance_title.trans(),
                style: AppTheme.blackDark_20w600,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 6.h,
              ),
              Text(
                LocaleKeys.system_maintenance_content.trans(namedArgs: {
                  "time": FormatHelper.formatDate(
                    "kk:mm a",
                    widget.runningSystemMaintenance.endedAt,
                  ),
                }),
                style: AppTheme.black_14,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Obx(() => Visibility(
                    visible: viewModel.isShowReload,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: TextButton(
                        onPressed: viewModel.onCLickCheckSystemMaintenanceStatus,
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: AppTheme.orange),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          backgroundColor: AppTheme.white,
                          minimumSize: Size(300.w, 50.h),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: Text(
                          LocaleKeys.system_maintenance_check_again.trans(),
                          style: AppTheme.orange_14w600,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
