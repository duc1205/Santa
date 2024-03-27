import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class EmptyReceiveOwnerPackageWidget extends StatelessWidget {
  final CabinetInfo cabinetInfo;
  final Map<String, dynamic>? bankTransferInfo;
  final String userPhoneNumber;
  final Function() sendEmail;

  const EmptyReceiveOwnerPackageWidget({
    required this.cabinetInfo,
    required this.bankTransferInfo,
    required this.userPhoneNumber,
    required this.sendEmail,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Assets.images.imgEmptyPackageBackground.image(
          width: 238.w,
          height: 116.h,
        ),
        SizedBox(
          height: 30.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 55.w),
          child: EasyRichText(
            LocaleKeys.delivery_no_package.trans(namedArgs: {"userPhoneNumber": userPhoneNumber, "cabinetName": cabinetInfo.name}),
            defaultStyle: AppTheme.black_16,
            textAlign: TextAlign.center,
            patternList: [
              EasyRichTextPattern(
                targetString: LocaleKeys.delivery_have_no.trans(),
                style: AppTheme.blackDark_16w600,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => callHotLine(bankTransferInfo?["contacts"]["call"]["value"]),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Container(
                  width: 130.w,
                  padding: EdgeInsets.only(
                    top: 4.h,
                    bottom: 10.h,
                  ),
                  child: Column(
                    children: [
                      Assets.icons.icPhone.image(),
                      SizedBox(
                        height: 6.h,
                      ),
                      Text(
                        LocaleKeys.delivery_call_hotline.trans(),
                        style: AppTheme.black_14w600,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
            GestureDetector(
              onTap: () {
                launchUri("http://zalo.me/${bankTransferInfo?["contacts"]["zalo"]["value"]}");
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Container(
                  width: 130.w,
                  padding: EdgeInsets.only(
                    top: 4.h,
                    bottom: 10.h,
                  ),
                  child: Column(
                    children: [
                      Assets.icons.icHomeZalo.image(),
                      SizedBox(
                        height: 6.h,
                      ),
                      Text(
                        LocaleKeys.delivery_chat_zalo.trans(),
                        style: AppTheme.black_14w600,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
