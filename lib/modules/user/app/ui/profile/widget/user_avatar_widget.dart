import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/modules/user/domain/enums/user_type.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/extensions/string_ext.dart';

class UserAvatarWidget extends StatelessWidget {
  final User? user;
  const UserAvatarWidget({super.key, required this.user});

  Widget userAvatar() {
    switch (user?.type?.toUserType()) {
      case UserType.shipper:
        return Center(
          child: Assets.icons.icProfileShipper.image(
            height: 70.w,
            width: 70.w,
            fit: BoxFit.fill,
          ),
        );
      case UserType.receiver:
        return Center(
          child: Assets.icons.icProfileReceiver.image(
            height: 70.w,
            width: 70.w,
            fit: BoxFit.fill,
          ),
        );
      default:
        return Center(
          child: Assets.icons.icUserIdentity.image(
            height: 70.w,
            width: 70.w,
            color: Colors.amber.shade600,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvatar();
  }
}
