import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class PermissionDialog extends StatelessWidget {
  final Permission permission;
  final bool isFirstStartUp;

  static final _data = <Permission, _PermissionInfo>{
    Permission.notification: _PermissionInfo(
      title: LocaleKeys.permission_notifications_permission_title.trans(),
      body: LocaleKeys.permission_notifications_permission_body.trans(),
      icon: Assets.images.imgNotificationsPermissionBackground.image(),
    ),
    Permission.camera: _PermissionInfo(
      title: LocaleKeys.permission_camera_permission_title.trans(),
      body: LocaleKeys.permission_camera_permission_body.trans(),
      icon: Assets.images.imgCameraPermissionBackground.image(),
    ),
    Permission.location: _PermissionInfo(
      title: LocaleKeys.permission_location_permission_title.trans(),
      body: LocaleKeys.permission_location_permission_body.trans(),
      icon: Assets.images.imgLocationPermissionBackground.image(),
    ),
    Permission.contacts: _PermissionInfo(
      title: LocaleKeys.permission_contacts_permission_title.trans(),
      body: LocaleKeys.permission_contacts_permission_body.trans(),
      icon: Assets.images.imgContactsPermission.image(),
    ),
  };

  const PermissionDialog({
    super.key,
    required this.permission,
    required this.isFirstStartUp,
  });

  Future<Unit> _requestPermission(Permission permission) async {
    final PermissionStatus status = await permission.request();
    if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
    return unit;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 56.h,
              ),
              SizedBox(height: 190.h, width: 190.w, child: _data[permission]!.icon),
              SizedBox(
                height: 19.h,
              ),
              Text(
                _data[permission]!.title,
                style: AppTheme.blackDark_16w700,
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 23.w),
                child: Text(
                  _data[permission]!.body,
                  style: AppTheme.blackDark_14w400,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 35.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: SizedBox(
                  height: 50.h,
                  width: 300.w,
                  child: SizedBox.expand(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _requestPermission(permission);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.yellow1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          isFirstStartUp ? LocaleKeys.permission_let_go.trans() : LocaleKeys.permission_allow_permission.trans(),
                          style: AppTheme.white_14w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 23.w),
                child: SizedBox(
                  height: 20.h,
                  // width: 300.w,
                  child: SizedBox.expand(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          LocaleKeys.permission_later.trans(),
                          style: AppTheme.yellow_14w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class _PermissionInfo {
  final String title;
  final String body;
  final Image icon;

  const _PermissionInfo({
    required this.title,
    required this.body,
    required this.icon,
  });
}
