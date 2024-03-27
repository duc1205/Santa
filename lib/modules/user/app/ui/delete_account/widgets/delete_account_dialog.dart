import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/dialog/sg_alert_dialog.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class DeleteAccountDialog extends StatelessWidget {
  final Function() confirmLogOut;

  const DeleteAccountDialog({Key? key, required this.confirmLogOut}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SGAlertDialog alertDialog = SGAlertDialog(
      confirmButton: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          backgroundColor: AppTheme.red,
        ),
        onPressed: confirmLogOut,
        child: Text(
          LocaleKeys.user_yes_im_sure.trans(),
          style: AppTheme.white_14w600,
        ),
      ),
      cancelButton: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          backgroundColor: AppTheme.border,
        ),
        onPressed: () => Get.back(),
        child: Text(
          LocaleKeys.user_cancel.trans(),
          style: AppTheme.white_14w600,
        ),
      ),
      bodyViewDistance: 0,
      bodyView: Column(
        children: [
          SizedBox(
            height: 28.h,
          ),
          Assets.icons.icDeleteAccountRed.image(),
          SizedBox(
            height: 30.h,
          ),
          Text(
            LocaleKeys.user_delete_account_confirm_message.trans(),
            style: AppTheme.black_14,
          ),
        ],
      ),
    );
    alertDialog.hideTitle();
    return alertDialog;
  }
}
