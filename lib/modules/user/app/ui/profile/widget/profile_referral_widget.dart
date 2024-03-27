import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/user/app/ui/profile/widget/user_avatar_widget.dart';
import 'package:santapocket/modules/user/app/ui/user_info/user_info_page.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class ProfileReferralWidget extends StatelessWidget {
  final User? user;
  final String? shareUrl;

  const ProfileReferralWidget({
    super.key,
    required this.user,
    required this.shareUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppTheme.coffeeOrange,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Get.to(() => const UserInfoPage());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  ),
                  child: Row(
                    children: [
                      UserAvatarWidget(
                        user: user,
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.displayName ?? "",
                              style: AppTheme.blackDark_16w600,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            Text(
                              user?.phoneNumber.replaceAll("+", '') ?? "",
                              style: AppTheme.blackDark_14w400,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppTheme.grey,
                        size: 15.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.coffeeOrange,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r), bottomRight: Radius.circular(20.r)),
                  ),
                  child: Assets.images.imgBackgroundProfileWidget.image(fit: BoxFit.fill),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 18.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Text(
                        LocaleKeys.user_your_referral_code.trans(),
                        style: AppTheme.blackDark_14w600,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 14.w),
                      width: double.infinity,
                      decoration: BoxDecoration(color: AppTheme.radiantGlow, borderRadius: BorderRadius.all(Radius.circular(15.r))),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 14.w),
                            child: Text(user?.referralCode ?? "", style: AppTheme.goldishOrange_20w600),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () async {
                              await Clipboard.setData(ClipboardData(text: user?.referralCode ?? ""));
                              showToast(LocaleKeys.user_copy_successful.trans());
                            },
                            child: Assets.icons.icReferralCopy.image(color: AppTheme.goldishOrange),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          TapDebouncer(
                            onTap: () async {
                              await Share.share(shareUrl ?? "");
                              await Future.delayed(const Duration(milliseconds: 1000));
                            },
                            builder: (BuildContext context, TapDebouncerFunc? onTap) {
                              return GestureDetector(
                                onTap: onTap,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Assets.icons.icReferralShare.image(),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
