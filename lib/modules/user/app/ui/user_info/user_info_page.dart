import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/user/app/ui/profile/widget/user_balance_widget.dart';
import 'package:santapocket/modules/user/app/ui/user_info/user_info_page_view_model.dart';
import 'package:santapocket/modules/user/domain/enums/user_type.dart';
import 'package:santapocket/shared/dialog/sg_alert_dialog.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends BaseViewState<UserInfoPage, UserInfoPageViewModel> {
  final TextEditingController _controller = TextEditingController();

  @override
  UserInfoPageViewModel createViewModel() => locator<UserInfoPageViewModel>();

  Widget userAvatar() {
    switch (viewModel.userType) {
      case UserType.shipper:
        return Center(
          child: Assets.icons.icProfileShipper.image(
            height: 100.w,
            width: 100.w,
            fit: BoxFit.fill,
          ),
        );
      case UserType.receiver:
        return Center(
          child: Assets.icons.icProfileReceiver.image(
            height: 100.w,
            width: 100.w,
            fit: BoxFit.fill,
          ),
        );
      default:
        return Center(
          child: Assets.icons.icUserIdentity.image(
            height: 100.w,
            width: 100.w,
            color: Colors.amber.shade600,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          LocaleKeys.user_user_info.trans().toUpperCase(),
          style: AppTheme.blackDark_16,
        ),
        iconTheme: const IconThemeData(color: AppTheme.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 36.h,
                ),
                Obx(() => userAvatar()),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 26.h, 15.w, 63.h),
                  child: Obx(
                    () => UserBalanceWidget(
                      coin: viewModel.user?.gem ?? 0,
                      freeUsage: viewModel.user?.freeUsage ?? 0,
                      cone: viewModel.user?.cone ?? 0,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Assets.icons.icUserInfoIdentify.image(
                        height: 20.h,
                        width: 18.w,
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Obx(
                        () => Expanded(
                          child: viewModel.getUserName() != ""
                              ? Text(
                                  viewModel.getUserName(),
                                  style: AppTheme.black_16,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Text(
                                  LocaleKeys.user_enter_name.trans(),
                                  style: AppTheme.grey_16,
                                ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _onEditNameClicked(viewModel);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                          child: Assets.icons.icUserInfoEdit.image(
                            width: 15.w,
                            height: 14.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: AppTheme.border,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Row(
                    children: [
                      Assets.icons.icPhone.image(
                        height: 20.h,
                        width: 18.w,
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Obx(
                        () => Text(
                          viewModel.user?.phoneNumber ?? "0",
                          style: AppTheme.black_16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  const Divider(
                    color: AppTheme.border,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Row(
                    children: [
                      Assets.icons.icUserInfoType.image(
                        height: 20.h,
                        width: 18.w,
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Obx(
                        () => Expanded(
                          child: Text(
                            viewModel.userType.getName(),
                            style: AppTheme.black_16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          viewModel.onChangeUserType();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                          child: Assets.icons.icUserInfoEdit.image(
                            width: 15.w,
                            height: 14.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  const Divider(
                    color: AppTheme.border,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Unit> _onEditNameClicked(UserInfoPageViewModel viewModel) async {
    _controller.text = viewModel.getUserName();
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final SGAlertDialog alertDialog = SGAlertDialog(
          title: LocaleKeys.user_change_name.trans(),
          bodyViewDistance: 25.h,
          bodyView: TextField(
            autofocus: true,
            controller: _controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 10.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  8.r,
                ),
                borderSide: BorderSide(
                  color: AppTheme.lightBorder,
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  8.r,
                ),
                borderSide: BorderSide(
                  color: AppTheme.lightBorder,
                  width: 1.w,
                ),
              ),
            ),
            textAlign: TextAlign.left,
            style: AppTheme.black_16,
          ),
          confirmButton: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: 15.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              backgroundColor: AppTheme.yellow1,
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              viewModel.newName = _controller.text;
              viewModel.changeUserName();
            },
            child: Text(
              LocaleKeys.user_save.trans(),
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
        );
        return alertDialog;
      },
    );
    return unit;
  }
}
