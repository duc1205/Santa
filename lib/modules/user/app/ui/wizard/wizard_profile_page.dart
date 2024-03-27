import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/firebase/fcm_manager.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/user/app/ui/wizard/wizard_profile_page_viewmodel.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class WizardProfilePage extends StatefulWidget {
  final String? username;

  const WizardProfilePage({Key? key, this.username}) : super(key: key);

  @override
  State<WizardProfilePage> createState() => _WizardProfilePageState();
}

class _WizardProfilePageState extends BaseViewState<WizardProfilePage, WizardProfilePageViewModel> {
  final TextEditingController _controller = TextEditingController();

  @override
  WizardProfilePageViewModel createViewModel() => locator<WizardProfilePageViewModel>();

  @override
  void initState() {
    locator<FCMManager>().config(context);
    _controller.text = widget.username ?? "";
    super.initState();
  }

  @override
  void loadArguments() {
    viewModel.userName = widget.username ?? "";
    super.loadArguments();
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
                    LocaleKeys.user_full_name.trans(),
                    style: AppTheme.black_20w600,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 38.w),
                    child: TextField(
                      scrollPadding: EdgeInsets.only(bottom: 150.h),
                      onChanged: viewModel.onChangeUserName,
                      textCapitalization: TextCapitalization.words,
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.user_please_enter_full_name.trans(),
                        hintStyle: AppTheme.grey_16w600,
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.only(left: 17.w),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.w),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.r),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.w),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 37.w),
                    child: Text(
                      LocaleKeys.user_enter_full_name_reminder.trans(),
                      style: AppTheme.green_14w400,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 182.h,
                  ),
                  Container(
                    height: 50.h,
                    width: 300.w,
                    margin: EdgeInsets.symmetric(horizontal: 37.5.w),
                    child: SizedBox.expand(
                      child: ElevatedButton(
                        onPressed: () => viewModel.updateUserName(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            LocaleKeys.user_next.trans(),
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
        ],
      ),
    );
  }
}
