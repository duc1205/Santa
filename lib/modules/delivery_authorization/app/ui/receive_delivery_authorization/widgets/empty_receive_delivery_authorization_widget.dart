import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class EmptyReceiveDeliveryAuthorizationWidget extends StatelessWidget {
  final String cabinetName;

  const EmptyReceiveDeliveryAuthorizationWidget({Key? key, required this.cabinetName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Assets.images.imgAuthorizedPackageEmptyBackground.image(
          width: 238.w,
          height: 128.h,
        ),
        SizedBox(
          height: 18.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 85.w),
          child: Text(
            LocaleKeys.delivery_authorization_empty_authorized_package.trans(
              namedArgs: {
                "cabinetName": cabinetName,
              },
            ),
            textAlign: TextAlign.center,
            style: AppTheme.blackDark_16w400,
          ),
        ),
      ],
    );
  }
}
