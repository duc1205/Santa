import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class EmptyCharityDeliveriesPage extends StatelessWidget {
  const EmptyCharityDeliveriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 54.h,
        ),
        SizedBox(
          width: 159.w,
          height: 137.h,
          child: Assets.images.imgEmptyDonation.image(
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Text(
          LocaleKeys.charity_you_have_no_donation.trans(),
          style: AppTheme.black_16,
        ),
      ],
    );
  }
}
