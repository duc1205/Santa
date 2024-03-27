import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/delivery/app/ui/helper/pocket_helper.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class CharityPocketInfoWidget extends StatelessWidget {
  final Delivery? delivery;
  final bool pocketIsOpen;
  final CabinetInfo cabinetInfo;
  final int? receivePrice;
  final int? receiveCoin;

  const CharityPocketInfoWidget({
    required this.delivery,
    required this.pocketIsOpen,
    required this.cabinetInfo,
    this.receivePrice,
    this.receiveCoin,
    Key? key,
  }) : super(key: key);

  String get pocketName => "${LocaleKeys.charity_pocket.trans()} ${delivery?.extra?.pocketExtra?.localId ?? ""}";

  String get pocketSize => "Size ${delivery?.pocket?.size?.name ?? ""}";

  Color get getPocketColor => pocketColor(delivery?.pocket?.size?.uuid);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.light13,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.delivery_pocket_status.trans(),
                  style: AppTheme.blackDark_14w400,
                ),
                Container(
                  height: 26.h,
                  width: 56.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: pocketIsOpen ? AppTheme.red : AppTheme.blue,
                  ),
                  child: Center(
                    child: Text(
                      pocketIsOpen ? LocaleKeys.delivery_opened.trans() : LocaleKeys.delivery_closed.trans(),
                      style: AppTheme.white_14w400,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.delivery_pocket.trans(),
                  style: AppTheme.blackDark_14w400,
                ),
                Container(
                  padding: EdgeInsets.all(5.sp),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Text(
                    delivery?.extra?.pocketExtra?.localId.toString() ?? "",
                    style: AppTheme.white_14w600,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Size",
                  style: AppTheme.blackDark_14w400,
                ),
                Text(
                  delivery?.pocket?.size?.name ?? "",
                  style: AppTheme.black_16bold,
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Service fee",
                  style: AppTheme.blackDark_14w400,
                ),
                ((receivePrice == 0 && receiveCoin == null) || (receivePrice == 0 && receiveCoin == 0))
                    ? Text(
                        LocaleKeys.delivery_free_usage_promo.trans(),
                        style: AppTheme.black_16bold,
                      )
                    : Container(
                        child: (receivePrice == null && receiveCoin == null)
                            ? SizedBox(
                                height: 24.h,
                                width: 24.h,
                                child: const FittedBox(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.orange),
                                  ),
                                ),
                              )
                            : Text(
                                FormatHelper.formatCurrencyV2(
                                  FormatHelper.roundSantaXu(receivePrice ?? 0),
                                  unit: "Xu",
                                ),
                                style: AppTheme.black_16bold,
                              ),
                      ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
