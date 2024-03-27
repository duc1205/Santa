import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class AuthorizedPersonWidget extends StatelessWidget {
  final String textAuthorizedPerson;

  const AuthorizedPersonWidget({Key? key, required this.textAuthorizedPerson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: AppTheme.celestialGreen, width: 0.5),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            width: 55.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: AppTheme.celestialGreen,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(5.r),
              ),
            ),
            child: Center(
              child: Assets.icons.icAuthorizeInfoWhite.image(
                width: 22.w,
                height: 22.h,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              child: Text(
                textAuthorizedPerson,
                style: AppTheme.blackDarkOp50Percent_14w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
