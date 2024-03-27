import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class EmptyDeliveriesPage extends StatelessWidget {
  const EmptyDeliveriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 54.h,
        ),
        SizedBox(
          width: 223.w,
          height: 122.h,
          child: Assets.images.imgEmptyDeliveries.image(
            height: 50.h,
            width: 50.h,
          ),
        ),
        SizedBox(
          height: 36.h,
        ),
        Text(
          LocaleKeys.delivery_you_have_no_delivery.trans(),
          style: AppTheme.black_16,
        ),
      ],
    );
  }
}
