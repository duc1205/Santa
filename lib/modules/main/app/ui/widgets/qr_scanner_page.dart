import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/main/app/ui/widgets/scanner_animation_widget.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

import 'qr_scanner_overlay_shape.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isFlashToggle = false;
  bool animationStopped = false;
  bool isSkippingFrame = true;

  @override
  void initState() {
    _animationController = AnimationController(duration: const Duration(seconds: 3), vsync: this);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(reverse: true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(reverse: false);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_setSkipFrames());
    });
    super.initState();
  }

  Future<Unit> _setSkipFrames() async {
    await Future.delayed(const Duration(seconds: 1));
    isSkippingFrame = false;
    return unit;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animateScanAnimation({required bool reverse}) {
    if (reverse) {
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    animateScanAnimation(reverse: false);
    bool isFirstCallback = true;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 90.h,
            right: 19.w,
            child: SizedBox(
              width: 336.w,
              height: 600.h,
              child: Stack(
                children: [
                  QrCamera(
                    onError: (context, error) {
                      return Container(
                        color: AppTheme.black,
                      );
                    },
                    notStartedBuilder: (context) => Center(
                      child: SizedBox(
                        height: 35.h,
                        width: 35.h,
                        child: const FittedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.orange),
                          ),
                        ),
                      ),
                    ),
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: QrScannerOverlayShape(
                          borderColor: Colors.white,
                          borderWidth: 3,
                        ),
                      ),
                    ),
                    qrCodeCallback: (qrCode) {
                      if (isSkippingFrame || !isFirstCallback || qrCode == null) {
                        return;
                      }
                      isFirstCallback = false;
                      Get.back(result: qrCode);
                    },
                  ),
                  ScannerAnimationWidget(
                    animation: _animationController,
                    stopped: animationStopped,
                    width: 336.w,
                  ),
                ],
              ),
            ),
          ),
          Assets.images.imgQrScanBackground.image(
            width: 375.w,
            height: 812.h,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.only(top: 62.h),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                LocaleKeys.main_scan_qr.trans().toUpperCase(),
                style: AppTheme.white_18bold,
              ),
            ),
          ),
          Positioned(
            top: 100.h,
            right: 18.w,
            child: IconButton(
              onPressed: () async {
                setState(() {
                  isFlashToggle = !isFlashToggle;
                });
              },
              icon: isFlashToggle
                  ? Assets.icons.icFlashOn.image(
                      color: Colors.white,
                      width: 30.w,
                      height: 30.h,
                    )
                  : Assets.icons.icFlashOff.image(
                      color: Colors.white,
                      width: 30.w,
                      height: 30.h,
                    ),
            ),
          ),
          Positioned(
            bottom: 65.h,
            left: 29.w,
            right: 29.w,
            child: SizedBox(
              height: 50.h,
              width: 300.w,
              child: SizedBox.expand(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.orangeFade,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      LocaleKeys.main_cancel.trans(),
                      style: AppTheme.black_20w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 205.h,
            left: 93.w,
            right: 93.w,
            child: Text(
              LocaleKeys.main_scan_qr_hint.trans(),
              style: AppTheme.white_14w400,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
