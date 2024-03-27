import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/modules/charity/domain/models/charity_donation.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class CharityDonationListViewItem extends StatelessWidget {
  final CharityDonation charityDonation;
  const CharityDonationListViewItem({super.key, required this.charityDonation});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    charityDonation.donor?.displayName ?? "",
                    style: AppTheme.blackDark_14w600,
                  ),
                  Text(FormatHelper.formatPrivatePhoneNumber(charityDonation.donor?.phoneNumber ?? ""), style: AppTheme.blackDark_14w400),
                ],
              ),
            ),
            Text(
              FormatHelper.formatCreatedDate(charityDonation.createdAt),
              style: AppTheme.blackDark_14w400,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Container(
            color: AppTheme.superSilver,
            width: double.infinity,
            height: 1.h,
          ),
        ),
      ],
    );
  }
}
