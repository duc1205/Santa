import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class RecentReceiverItem extends StatelessWidget {
  const RecentReceiverItem({Key? key, required this.user, required this.selected, required this.onItemClick}) : super(key: key);

  final User user;
  final bool selected;
  final VoidCallback onItemClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onItemClick(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Container(
              padding: EdgeInsets.only(top: 24.h, left: 11.w, bottom: 24.h),
              decoration: BoxDecoration(
                color: selected ? AppTheme.orange.withOpacity(0.1) : Colors.white,
                border: Border(bottom: BorderSide(color: AppTheme.grey.withOpacity(0.3), width: 1.w)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 14.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: selected ? Colors.orange : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? Colors.orange.withOpacity(0.5) : AppTheme.grey.withOpacity(0.5),
                        width: 1.w,
                      ),
                    ),
                    child: Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 6.sp,
                    ),
                  ),
                  SizedBox(
                    width: 32.w,
                  ),
                  Assets.icons.icRecent.image(
                    width: 38.w,
                    height: 38.h,
                  ),
                  SizedBox(
                    width: 17.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.phoneNumber,
                          style: AppTheme.blackDark_14,
                        ),
                        if (user.name != null)
                          SizedBox(
                            height: 4.h,
                          ),
                        if (user.name != null)
                          Text(
                            user.name!,
                            style: AppTheme.grey_14w600,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
