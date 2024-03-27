import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class NoResultFound extends StatelessWidget {
  const NoResultFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 54.h,
        ),
        Container(
          width: 223.w,
          height: 122.h,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(Assets.images.imgStarGreyBackground.path)),
          ),
          child: Assets.icons.icEmptySearchGrey.image(
            height: 50.h,
            width: 50.h,
          ),
        ),
        SizedBox(
          height: 36.h,
        ),
        Text(
          LocaleKeys.delivery_no_result_found.trans(),
          style: AppTheme.black_16,
        ),
        SizedBox(
          height: 16.h,
        ),
        Text(
          LocaleKeys.delivery_try_different_keyword.trans(),
          style: AppTheme.blackDark_20w600,
        ),
      ],
    );
  }
}
