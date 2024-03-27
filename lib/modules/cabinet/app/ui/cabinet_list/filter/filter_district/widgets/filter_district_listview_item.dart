import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class FilterDistrictListViewItem extends StatelessWidget {
  final String city;
  final bool isSelected;

  const FilterDistrictListViewItem({Key? key, required this.city, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.light5 : AppTheme.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Assets.icons.icCabinetLocationRed.image(),
            SizedBox(
              width: 16.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city,
                    style: AppTheme.black_16w600,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            isSelected ? Assets.icons.icDeliveryCheckRed.image() : Container(),
          ],
        ),
      ),
    );
  }
}
