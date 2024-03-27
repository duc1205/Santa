import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/utils.dart' as utils;
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class CabinetEmptyPocketDialog extends StatelessWidget {
  final String cabinetName;

  const CabinetEmptyPocketDialog({Key? key, required this.cabinetName}) : super(key: key);

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
            Padding(
              padding: EdgeInsets.only(
                top: 33.h,
                left: 24.w,
                right: 24.w,
              ),
              child: Row(
                children: [
                  Assets.icons.icCabinetWarningYellow.image(
                    width: 24.w,
                    height: 24.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Flexible(
                    child: Text(
                      LocaleKeys.delivery_empty_pocket.trans(namedArgs: {"cabinetName": cabinetName}),
                      style: AppTheme.blackDark_16w400,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 26.h,
            ),
            Divider(
              height: 1.w,
              thickness: 1.w,
              color: AppTheme.grey,
            ),
            TextButton(
              onPressed: () => utils.backPageOrHome(),
              child: Text(
                LocaleKeys.delivery_back_home.trans(),
                style: AppTheme.orange_16w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
