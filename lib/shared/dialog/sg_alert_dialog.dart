import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

// ignore: must_be_immutable
class SGAlertDialog extends StatelessWidget {
  final String? title;
  final VoidCallback? onConfirmButtonClicked;
  final VoidCallback? onCancelButtonClicked;
  final Widget? bodyView;
  final Widget? confirmButton;
  final Widget? cancelButton;
  bool _isHideTitle = false;
  final double bodyViewDistance;

  SGAlertDialog({
    Key? key,
    this.title,
    this.confirmButton,
    this.cancelButton,
    this.onConfirmButtonClicked,
    this.onCancelButtonClicked,
    this.bodyView,
    this.bodyViewDistance = 48,
  }) : super(key: key);

  void hideTitle() => _isHideTitle = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 16.h,
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: <Widget>[
                  if (!_isHideTitle)
                    Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                            title ?? "",
                            style: AppTheme.blackDark_20w600,
                          ),
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                      ],
                    )
                  else
                    Container(),
                  bodyView ?? Container(),
                  SizedBox(
                    height: bodyViewDistance,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: cancelButton ??
                        SizedBox(
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: () {
                              if (onCancelButtonClicked != null) {
                                onCancelButtonClicked!();
                              } else {
                                Get.back();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.r),
                                ),
                              ),
                            ),
                            child: Text(
                              LocaleKeys.shared_cancel.trans(),
                              style: AppTheme.blackDark_16w600,
                            ),
                          ),
                        ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Expanded(
                    child: confirmButton ??
                        SizedBox(
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: () {
                              onConfirmButtonClicked?.call();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20.r),
                                ),
                              ),
                            ),
                            child: Text(
                              LocaleKeys.shared_save.trans(),
                              style: AppTheme.orange_16w600,
                            ),
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
