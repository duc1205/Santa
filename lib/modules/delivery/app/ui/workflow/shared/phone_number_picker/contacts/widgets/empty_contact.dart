import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class EmptyContact extends StatelessWidget {
  const EmptyContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 100.h,
          ),
          Assets.images.imgEmptyContactBackground.image(
            width: 228.w,
            height: 136.h,
          ),
          SizedBox(
            height: 40.h,
          ),
          Text(
            LocaleKeys.delivery_no_contact_found.trans(),
            style: AppTheme.black_14,
          ),
        ],
      ),
    );
  }
}
