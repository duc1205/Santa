import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/referral_campaign/domain/models/referral_campaign.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class ReferralBlockWidget extends StatelessWidget {
  final Function() onPressDetailButton;
  final ReferralCampaign? referralCampaign;
  final String? locale;
  const ReferralBlockWidget({super.key, required this.onPressDetailButton, required this.referralCampaign, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.superSilver,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 4.w,
            ),
            Assets.icons.icReferralRedPresent.image(),
            SizedBox(
              width: 6.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${FormatHelper.formatDate("dd MMM", referralCampaign?.startedAt, locale: locale)} - ${FormatHelper.formatDate("dd MMM", referralCampaign?.endedAt, locale: locale)}",
                    style: AppTheme.black_12,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  SizedBox(
                    width: 195.w,
                    child: Text(LocaleKeys.user_referral_banner_title.trans(), style: AppTheme.blackDark_14w700),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  SizedBox(
                    width: 195.w,
                    child: Text(
                      LocaleKeys.user_referral_new_user_reward_title.trans(),
                      style: AppTheme.black_12,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onPressDetailButton,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppTheme.gluttonyOrange,
                  borderRadius: BorderRadius.all(Radius.circular(15.r)),
                ),
                child: Text(
                  LocaleKeys.user_detail.trans(),
                  style: AppTheme.white_14w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
