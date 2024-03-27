import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/user/app/ui/delete_account/delete_account_page_view_model.dart';
import 'package:santapocket/modules/user/app/ui/delete_account/widgets/delete_account_dialog.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends BaseViewState<DeleteAccountPage, DeleteAccountPageViewModel> {
  @override
  DeleteAccountPageViewModel createViewModel() => locator<DeleteAccountPageViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          LocaleKeys.user_delete_account.trans().toUpperCase(),
          style: AppTheme.blackDark_16,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 151.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 27.w),
            child: Column(
              children: [
                Assets.images.imgDeleteAccountBackground.image(),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  LocaleKeys.user_delete_account_title.trans(),
                  style: AppTheme.red_14w600,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  LocaleKeys.user_delete_account_message.trans(),
                  style: AppTheme.black_14w400,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.all(15.sp),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.5.h),
                      backgroundColor: AppTheme.white,
                      disabledBackgroundColor: AppTheme.cyan.withOpacity(0.4),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                      side: BorderSide(width: 1.w, color: AppTheme.red),
                    ),
                    onPressed: () {
                      Get.dialog(DeleteAccountDialog(confirmLogOut: () => viewModel.confirmDeleteAccount()));
                    },
                    child: Text(
                      LocaleKeys.user_delete_account.trans(),
                      style: AppTheme.red_14w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
