import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/user/domain/models/user_cone_log.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class UserConeRewardWidget extends StatelessWidget {
  final UserConeLog userConeLog;

  const UserConeRewardWidget({super.key, required this.userConeLog});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Assets.images.imgUserCoinRewardBackgroundV2.image(fit: BoxFit.fill),
            ),
            SizedBox(
              height: 16.h,
            ),
            Center(
              child: Text(
                "+${FormatHelper.formatCurrency(userConeLog.cone - userConeLog.oldCone, unit: LocaleKeys.user_santa_cones.trans())}",
                style: AppTheme.black_14w400,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.sp),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.r),
                            ),
                          ),
                        ),
                        child: Text(
                          LocaleKeys.user_collect_now.trans(),
                          style: AppTheme.white_14w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
