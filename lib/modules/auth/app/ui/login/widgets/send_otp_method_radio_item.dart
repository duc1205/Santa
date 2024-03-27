import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class SendOTPMethodRadioItem extends StatelessWidget {
  final int value;
  final bool isSelected;
  final String label;
  final Function(int?) onSelectItem;

  const SendOTPMethodRadioItem({
    Key? key,
    required this.value,
    required this.isSelected,
    required this.label,
    required this.onSelectItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelectItem(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? AppTheme.orange6 : AppTheme.grey4,
        ),
        child: Row(
          children: [
            isSelected
                ? Assets.icons.icRadioSelected.image(width: 20.w, height: 20.w)
                : Assets.icons.icRadioUnselected.image(width: 20.w, height: 20.w),
            SizedBox(
              width: 14.w,
            ),
            Text(
              label,
              style: AppTheme.blackDark_14,
            ),
          ],
        ),
      ),
    );
  }
}
