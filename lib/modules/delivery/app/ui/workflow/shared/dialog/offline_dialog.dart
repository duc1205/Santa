import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class OfflineDialog extends StatefulWidget {
  final CabinetInfo cabinetInfo;
  final Function() onConfirm;

  const OfflineDialog({
    required this.cabinetInfo,
    required this.onConfirm,
    Key? key,
  }) : super(key: key);

  @override
  State<OfflineDialog> createState() => _OfflineDialogState();
}

class _OfflineDialogState extends State<OfflineDialog> {
  static const int countDownTime = 10; // seconds
  int _remainTime = 0;

  bool _canResend = false;

  Timer? _countDownTimer;

  void _startTimer({int? remainTime}) {
    _remainTime = remainTime ?? countDownTime;
    _countDownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_remainTime <= 0) {
          setState(() {
            _canResend = true;
            timer.cancel();
          });
        } else {
          setState(() {
            --_remainTime;
          });
        }
      },
    );
  }

  void _cancelTimer() {
    _countDownTimer?.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 41.h,
            ),
            Assets.images.imgCabinetOffline.image(
              width: 168.w,
              height: 82.h,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 26.h,
            ),
            SizedBox(
              height: 13.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                LocaleKeys.delivery_offline_dialog_message.trans(),
                style: AppTheme.black_16w600,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: SizedBox(
                height: 50.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => backPageOrHome(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.sp),
                            color: AppTheme.border,
                          ),
                          child: Center(
                            child: Text(
                              LocaleKeys.delivery_back_home.trans(),
                              style: AppTheme.white_14w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Expanded(
                      child: _canResend
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.sp),
                                color: AppTheme.orange,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Get.back();
                                  widget.onConfirm();
                                },
                                child: Center(
                                  child: Text(
                                    _remainTime == 0 ? LocaleKeys.delivery_retry.trans() : "${LocaleKeys.delivery_retry.trans()} ($_remainTime)",
                                    style: AppTheme.white_14w600,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.sp),
                                color: AppTheme.goldishOrange.withOpacity(0.4),
                              ),
                              child: Center(
                                child: Text(
                                  _remainTime == 0 ? LocaleKeys.delivery_retry.trans() : "${LocaleKeys.delivery_retry.trans()} ($_remainTime)",
                                  style: AppTheme.white_14w600,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
