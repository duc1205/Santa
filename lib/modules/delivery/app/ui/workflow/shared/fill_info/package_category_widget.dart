import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/delivery/domain/enums/package_category.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class PackageCategoryWidget extends StatelessWidget {
  final PackageCategory? selectedCategory;
  final Function(PackageCategory) onSelectCategory;

  const PackageCategoryWidget({Key? key, required this.selectedCategory, required this.onSelectCategory}) : super(key: key);

  static final List<PackageCategory> categories = [
    PackageCategory.food,
    PackageCategory.others,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          categories.length,
          (index) => _category(
            categories[index],
          ),
        ),
      ),
    );
  }

  Widget _category(PackageCategory categoryType) {
    switch (categoryType) {
      case PackageCategory.food:
        return _categoryItem(
          imagePath: Assets.icons.icPackageCategoryFood.path,
          text: LocaleKeys.delivery_food.trans(),
          selected: selectedCategory == categoryType,
          onTap: () => onSelectCategory(categoryType),
        );
      case PackageCategory.others:
      default:
        return _categoryItem(
          imagePath: Assets.icons.icPackageCategoryOthers.path,
          text: LocaleKeys.delivery_others.trans(),
          selected: selectedCategory == categoryType,
          onTap: () => onSelectCategory(categoryType),
        );
    }
  }

  Widget _categoryItem({required String imagePath, required String text, required bool selected, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 164.w,
            height: 66.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(18.r),
              ),
              color: AppTheme.radiantGlowOrange,
              border: Border.all(color: selected ? AppTheme.green : Colors.white, width: 2.sp),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            text,
            style: selected ? AppTheme.green_14w600 : AppTheme.black_14w600,
          ),
        ],
      ),
    );
  }
}
