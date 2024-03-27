import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class HelpSpeedDial extends StatelessWidget {
  final void Function() onZaloTap;
  final void Function() onPhoneTap;
  HelpSpeedDial({super.key, required this.onZaloTap, required this.onPhoneTap});

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (tap) {
        isDialOpen.value = false;
      },
      child: SpeedDial(
        elevation: 0,
        activeChild: const Icon(Icons.close, color: Colors.white),
        activeBackgroundColor: AppTheme.goldishOrange,
        backgroundColor: Colors.transparent,
        visible: true,
        curve: Curves.bounceInOut,
        buttonSize: Size(57.w, 57.w),
        childrenButtonSize: Size(57.w, 57.w),
        renderOverlay: false,
        openCloseDial: isDialOpen,
        children: [
          SpeedDialChild(
            child: Assets.icons.icHomeZalo.image(color: Colors.white),
            backgroundColor: AppTheme.goldishOrange,
            onTap: onZaloTap,
            labelBackgroundColor: Colors.white,
          ),
          SpeedDialChild(
            child: Assets.icons.icPhone.image(color: Colors.white),
            backgroundColor: AppTheme.goldishOrange,
            onTap: onPhoneTap,
            labelBackgroundColor: Colors.white,
          ),
        ],
        child: Assets.icons.icHomeQuickDial.image(),
      ),
    );
  }
}
