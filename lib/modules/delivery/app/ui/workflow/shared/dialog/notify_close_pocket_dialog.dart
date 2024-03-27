import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/delivery/domain/enums/pocket_close_type.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class NotifyClosePocketDialog extends StatelessWidget {
  final PocketCloseType pocketCloseType;
  final bool isDismissable;

  const NotifyClosePocketDialog({required this.pocketCloseType, required this.isDismissable, Key? key}) : super(key: key);

  getCloseTextWidget() {
    switch (pocketCloseType) {
      case PocketCloseType.finish:
        return EasyRichText(
          LocaleKeys.delivery_notify_close_pocket_process.trans(),
          defaultStyle: AppTheme.black_16,
          patternList: [
            EasyRichTextPattern(
              targetString: LocaleKeys.delivery_close.trans(),
              style: AppTheme.blackDark_16w600,
            ),
          ],
        );
      case PocketCloseType.changePocketSize:
        return EasyRichText(
          LocaleKeys.delivery_notify_close_change_pocket.trans(),
          defaultStyle: AppTheme.black_16,
          patternList: [
            EasyRichTextPattern(
              targetString: LocaleKeys.delivery_close.trans(),
              style: AppTheme.blackDark_16w600,
            ),
            EasyRichTextPattern(
              targetString: LocaleKeys.delivery_new_keyword.trans(),
              style: AppTheme.blackDark_16w600,
            ),
          ],
        );
      case PocketCloseType.cancel:
        return EasyRichText(
          LocaleKeys.delivery_notify_close_pocket.trans(),
          defaultStyle: AppTheme.black_16,
          patternList: [
            EasyRichTextPattern(
              targetString: LocaleKeys.delivery_close.trans(),
              style: AppTheme.blackDark_16w600,
            ),
          ],
        );
      default:
    }
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
        child: Padding(
          padding: EdgeInsets.only(
            top: 16.h,
            left: 16.w,
            right: 16.w,
            bottom: 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isDismissable
                  ? Row(
                      children: [
                        const Spacer(),
                        InkWell(
                          onTap: Get.back,
                          child: Icon(
                            Icons.clear,
                            color: Colors.grey,
                            size: 20.sp,
                          ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Assets.icons.icCabinetWarningYellow.image(
                    width: 26.w,
                    height: 26.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    width: 13.w,
                  ),
                  Expanded(child: getCloseTextWidget()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
