import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/modules/payment/domain/models/payment_product.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class PaymentProductsWidget extends StatelessWidget {
  final List<PaymentProduct> paymentProducts;
  final int selectedIndex;
  final int Function(int) onSelectItem;
  final int Function(int) getCoinAmount;
  final int Function(int) getCoinPromo;
  final int Function(int) getPrice;

  const PaymentProductsWidget({
    required this.paymentProducts,
    required this.selectedIndex,
    required this.onSelectItem,
    required this.getCoinAmount,
    required this.getCoinPromo,
    required this.getPrice,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 20.h),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.43,
        crossAxisSpacing: 8,
        mainAxisSpacing: 6,
      ),
      itemBuilder: (context, index) => _buildItemProduct(
        index,
        index == selectedIndex,
        () => onSelectItem(index),
      ),
      itemCount: paymentProducts.length,
    );
  }

  Widget _buildItemProduct(int index, bool isSelected, VoidCallback onItemClick) {
    return GestureDetector(
      onTap: onItemClick,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isSelected ? AppTheme.orange.withOpacity(0.8) : AppTheme.grey.withOpacity(0.1), width: 1.w),
          color: isSelected ? AppTheme.sweetFrostingOrange : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: getPrice(index) > 0
                  ? Text(
                      FormatHelper.formatCurrency(getPrice(index)).removeWhitespaces(),
                      style: AppTheme.yellow1_14w700,
                      textAlign: TextAlign.center,
                    )
                  : Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  FormatHelper.formatCurrency(getCoinAmount(index), unit: ""),
                  style: AppTheme.black_14w400,
                  textAlign: TextAlign.center,
                ),
                Assets.icons.icSantaCoin.image(height: 16.w, width: 16.w),
              ],
            ),
            SizedBox(
              height: 7.h,
            ),
            getCoinPromo(index) > 0
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 23.h,
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppTheme.yellow1,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(6.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("+ ${getCoinPromo(index)}", style: AppTheme.white_12w400),
                          SizedBox(
                            width: 4.w,
                          ),
                          Assets.icons.icSantaCoin.image(height: 16.w, width: 16.w),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    height: 16.h,
                  ),
          ],
        ),
      ),
    );
  }
}
