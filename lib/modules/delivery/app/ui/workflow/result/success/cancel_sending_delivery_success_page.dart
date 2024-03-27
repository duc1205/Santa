import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/charity/app/ui/charity_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class CancelSendingDeliverySuccessPage extends StatelessWidget {
  const CancelSendingDeliverySuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 0.14.sh,
                ),
                Assets.images.imgThankyouBackground.image(),
                SizedBox(
                  height: 32.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    LocaleKeys.delivery_thank_you_description.trans(),
                    style: AppTheme.black_16w600,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 0.2.sh,
                ),
                SizedBox(
                  width: 300.w,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () => backPageOrHome(pageName: CharityPage.routeName),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        LocaleKeys.delivery_back_home.trans(),
                        style: AppTheme.white_16w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
