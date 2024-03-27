import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:santapocket/modules/permission/app/ui/permission_dialog.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class PermissionHelper {
  static final PermissionHelper instance = PermissionHelper._internal();

  PermissionHelper._internal();

  Future<bool> _handlePermission(Permission permission) async {
    final isSuccess = await checkForStatus(permission);
    return isSuccess ? true : await _requestPermission(permission);
  }

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    if (status.isGranted) {
      return true;
    }
    return false;
  }

  Future<bool> checkForStatus(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      return true;
    }
    return false;
  }

  Future<bool> checkPermission(
    Permission permission, {
    required bool forceRequest,
    bool? isFirstStartup,
  }) async {
    if (permission != Permission.notification) {
      await _handlePermission(permission);
    }
    final status = await permission.status;
    if (!status.isGranted && (forceRequest || !status.isPermanentlyDenied) && permission == Permission.notification) {
      await Get.dialog(PermissionDialog(isFirstStartUp: isFirstStartup ?? false, permission: permission), barrierColor: AppTheme.blackDark);
      await Future.delayed(const Duration(milliseconds: 500));
      return (await permission.status).isGranted;
    }
    return status.isGranted;
  }
}
