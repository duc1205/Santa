import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/firebase/fcm_manager.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/user/app/ui/wizard/wizard_profile_page_viewmodel.dart';
import 'package:santapocket/modules/user/domain/enums/user_type.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class WizardProfileSelectTypePage extends StatefulWidget {
  final bool isFirstLogin;
  const WizardProfileSelectTypePage({Key? key, required this.isFirstLogin}) : super(key: key);

  @override
  State<WizardProfileSelectTypePage> createState() => _WizardProfileSelectTypePageState();
}

class _WizardProfileSelectTypePageState extends BaseViewState<WizardProfileSelectTypePage, WizardProfilePageViewModel> {
  int selectedIndex = 0;

  @override
  WizardProfilePageViewModel createViewModel() => locator<WizardProfilePageViewModel>();

  @override
  void initState() {
    locator<FCMManager>().config(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.images.imgBackground.path),
                fit: BoxFit.fill,
              ),
              color: AppTheme.radiantGlow,
            ),
          ),
          Positioned(
            top: 150.h,
            left: 86.w,
            child: Assets.images.imgStarsBackground.image(
              height: 140.h,
              width: 214.w,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 67.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.images.imgAppWithoutSlogan.image(
                        height: 54.h,
                        width: 126.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 115.h,
                  ),
                  Assets.icons.icWizardCabinet.image(
                    height: 100.h,
                    width: 100.w,
                  ),
                  SizedBox(
                    height: 58.h,
                  ),
                  Text(
                    LocaleKeys.user_you_are.trans(),
                    style: AppTheme.black_20w600,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 37.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = 1;
                              viewModel.onChangeUserType(UserType.shipper);
                            });
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: 140.h,
                                width: 140.h,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.sp),
                                  ),
                                  border: selectedIndex == 1 ? Border.all(color: Colors.white, width: 2.sp) : null,
                                  boxShadow: [
                                    selectedIndex == 1
                                        ? BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 2,
                                          )
                                        : const BoxShadow(),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    selectedIndex == 1
                                        ? Padding(
                                            padding: EdgeInsets.only(top: 8.h, right: 8.w),
                                            child: const Align(
                                              alignment: Alignment.topRight,
                                              child: Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 32.h,
                                          ),
                                    Assets.icons.icWizardShipper.image(),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(
                                      LocaleKeys.user_shipper.trans().toUpperCase(),
                                      style: AppTheme.orange_16w600,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = 2;
                              viewModel.onChangeUserType(UserType.receiver);
                            });
                          },
                          child: Container(
                            height: 140.h,
                            width: 140.h,
                            decoration: BoxDecoration(
                              color: AppTheme.orange,
                              border: selectedIndex == 2 ? Border.all(color: Colors.white, width: 2.sp) : null,
                              boxShadow: [
                                selectedIndex == 2
                                    ? BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                      )
                                    : const BoxShadow(),
                              ],
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.sp),
                              ),
                            ),
                            child: Column(
                              children: [
                                selectedIndex == 2
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 8.h, right: 8.w),
                                        child: const Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 32.h,
                                      ),
                                Assets.icons.icWizardReceiver.image(),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Text(
                                  LocaleKeys.user_receiver.trans().toUpperCase(),
                                  style: AppTheme.blackDark_16w700,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 162.h,
                  ),
                  Container(
                    height: 50.h,
                    width: 300.w,
                    margin: EdgeInsets.symmetric(horizontal: 37.5.w),
                    child: SizedBox.expand(
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedIndex != 0) {
                            viewModel.updateUserType();
                          } else {
                            showToast(LocaleKeys.user_please_choose_user_type.trans());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedIndex == 0 ? AppTheme.ignitingOrange : AppTheme.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            LocaleKeys.user_let_go.trans(),
                            style: AppTheme.white_16w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.isFirstLogin,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Padding(
                padding: EdgeInsets.only(top: 44.h, left: 14.w),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
