import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/charity/domain/enums/charity_campaign_status.dart';
import 'package:santapocket/modules/charity/domain/models/charity_campaign.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class CharityCampaignsListViewItem extends StatelessWidget {
  final CharityCampaign charityCampaign;
  final VoidCallback onClickDonateNow;

  const CharityCampaignsListViewItem({super.key, required this.charityCampaign, required this.onClickDonateNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16.r),
        ),
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
            child: charityCampaign.imageUrl != null
                ? Image.network(
                    charityCampaign.imageUrl!,
                    fit: BoxFit.fill,
                    height: 192.h,
                    width: double.infinity,
                  )
                : Assets.icons.icCharityDefaultContract.image(
                    height: 192.h,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
          ),
          SizedBox(
            height: 6.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  charityCampaign.name,
                  style: AppTheme.blackDark_16w600,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Visibility(
                  visible: charityCampaign.giftType != null,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      EasyRichText(
                        "${LocaleKeys.charity_donation_items.trans()}: ${charityCampaign.giftType}",
                        maxLines: 2,
                        defaultStyle: AppTheme.blackDark_14w400,
                        overflow: TextOverflow.ellipsis,
                        patternList: [
                          EasyRichTextPattern(
                            targetString: LocaleKeys.charity_donation_items.trans(),
                            style: AppTheme.black_14w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: charityCampaign.beneficiary != null,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      EasyRichText(
                        "${LocaleKeys.charity_beneficiary.trans()}: ${charityCampaign.beneficiary}",
                        maxLines: 2,
                        defaultStyle: AppTheme.blackDark_14w400,
                        overflow: TextOverflow.ellipsis,
                        patternList: [
                          EasyRichTextPattern(
                            targetString: LocaleKeys.charity_beneficiary.trans(),
                            style: AppTheme.black_14w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${LocaleKeys.charity_time_to_donate.trans()}:", style: AppTheme.blackDark_14w600),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "${FormatHelper.formatDate("dd/MM/yyyy", charityCampaign.startedAt)} - ${FormatHelper.formatDate("dd/MM/yyyy", charityCampaign.endedAt)}",
                            style: AppTheme.blackDark_14w400,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppTheme.red1),
                        color: charityCampaign.status == CharityCampaignStatus.finished ? AppTheme.white : AppTheme.red1,
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => onClickDonateNow(),
                        child: Text(
                          charityCampaign.status == CharityCampaignStatus.finished
                              ? LocaleKeys.charity_view_detail.trans()
                              : LocaleKeys.charity_donate_now.trans(),
                          style: charityCampaign.status == CharityCampaignStatus.finished ? AppTheme.red_14w600 : AppTheme.white_14w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}
