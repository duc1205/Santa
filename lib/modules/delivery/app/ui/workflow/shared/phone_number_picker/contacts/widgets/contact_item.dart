import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/modules/delivery/domain/models/person.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class ContactItem extends StatelessWidget {
  const ContactItem({Key? key, required this.person, required this.isSelected, required this.itemClick}) : super(key: key);

  final Person person;
  final bool isSelected;
  final VoidCallback itemClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: itemClick,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Container(
              padding: EdgeInsets.only(top: 24.h, left: 11.w, bottom: 24.h),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.orange.withOpacity(0.1) : Colors.white,
                border: Border(bottom: BorderSide(color: AppTheme.grey.withOpacity(0.3), width: 1.w)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 14.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.orange.withOpacity(0.5) : AppTheme.grey.withOpacity(0.5),
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
                  Assets.icons.icContact.image(
                    width: 38.w,
                    height: 38.h,
                  ),
                  SizedBox(
                    width: 17.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (person.name != null)
                        Text(
                          person.name!,
                          style: AppTheme.orange_16w600,
                        ),
                      if (person.name != null)
                        SizedBox(
                          height: 4.h,
                        ),
                      Text(
                        person.phoneNumber,
                        style: AppTheme.blackDark_14,
                      ),
                    ],
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
