import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class ComingSoonServicePage extends StatelessWidget {
  const ComingSoonServicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.goldishOrange,
        leading: GestureDetector(onTap: () => Get.back(), child: Assets.icons.icLogoWebview.image()),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 140.h,
            width: double.infinity,
          ),
          Assets.images.imgHomeComingSoon.image(width: 260.w, height: 130.h),
        ],
      ),
    );
  }
}
