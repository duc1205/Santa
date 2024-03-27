import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/user/domain/enums/user_type.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class EditUserTypeDialog extends StatelessWidget {
  final UserType userType;
  final Function(UserType) onChangeUserType;

  const EditUserTypeDialog({required this.userType, required this.onChangeUserType, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 32.w, right: 16.w),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onChangeUserType(UserType.shipper),
            child: Row(
              children: [
                Text(
                  LocaleKeys.user_shipper.trans(),
                  style: AppTheme.black_14,
                ),
                const Spacer(),
                Radio(
                  value: UserType.shipper,
                  groupValue: userType,
                  activeColor: AppTheme.orange,
                  onChanged: (value) {
                    onChangeUserType(UserType.shipper);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onChangeUserType(UserType.receiver),
            child: Row(
              children: [
                Text(
                  LocaleKeys.user_receiver.trans(),
                  style: AppTheme.black_14,
                ),
                const Spacer(),
                Radio(
                  value: UserType.receiver,
                  groupValue: userType,
                  activeColor: AppTheme.orange,
                  onChanged: (value) => onChangeUserType(UserType.receiver),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
