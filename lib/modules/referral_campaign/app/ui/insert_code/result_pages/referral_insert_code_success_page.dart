import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/referral_campaign/app/ui/insert_code/referral_insert_code_page_viewmodel.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class ReferralInsertCodeSuccessPage extends StatefulWidget {
  final bool isRewared;
  const ReferralInsertCodeSuccessPage({super.key, required this.isRewared});

  @override
  State<ReferralInsertCodeSuccessPage> createState() => _ReferralInsertCodeSuccessPageState();
}

class _ReferralInsertCodeSuccessPageState extends BaseViewState<ReferralInsertCodeSuccessPage, ReferralInsertCodePageViewModel> {
  @override
  ReferralInsertCodePageViewModel createViewModel() => locator<ReferralInsertCodePageViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 140.h,
            ),
            Assets.icons.icReferralSantaCoinPresent.image(),
            SizedBox(
              height: 25.h,
            ),
            Text(
              LocaleKeys.referral_campaign_insert_coin_successful_title.trans(),
              style: AppTheme.green_24w600,
            ),
            SizedBox(
              height: 10.h,
            ),
            Visibility(
              visible: widget.isRewared,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: Text(
                  LocaleKeys.referral_campaign_insert_coin_successful_message.trans(),
                  style: AppTheme.blackDark_14w400,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const Spacer(),
            Container(
              height: 50.h,
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              child: SizedBox.expand(
                child: TextButton(
                  onPressed: viewModel.navigateToHomePage,
                  style: TextButton.styleFrom(
                    backgroundColor: AppTheme.gluttonyOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      LocaleKeys.referral_campaign_collect_now.trans(),
                      style: AppTheme.white_14w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
          ],
        ),
      ),
    );
  }
}
