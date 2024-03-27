import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/payment/domain/enums/payment_method.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class PaymentProcessing extends StatelessWidget {
  const PaymentProcessing({required this.amount, required this.paymentMethod, Key? key}) : super(key: key);
  final int amount;
  final PaymentMethod paymentMethod;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(top: 206.h),
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 30.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppTheme.grey.withOpacity(0.3),
                          width: 0.5.w,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 38.h,
                          ),
                          Text(
                            LocaleKeys.payment_payment_processing.trans(),
                            style: AppTheme.blue_14W600,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            FormatHelper.formatCurrency(amount),
                            style: AppTheme.blackDark_20w600,
                          ),
                          SizedBox(
                            height: 19.h,
                          ),
                          DottedLine(
                            dashColor: AppTheme.grey.withOpacity(0.5),
                          ),
                          SizedBox(
                            height: 28.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.payment_payment_time.trans(),
                              ),
                              Text(
                                FormatHelper.formatDate("dd/MM/yyyy, HH:mm", DateTime.now()),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 13.h,
                          ),
                          Divider(
                            color: AppTheme.grey.withOpacity(0.5),
                            thickness: 0.5.w,
                          ),
                          SizedBox(
                            height: 13.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.payment_price.trans(),
                              ),
                              Text(FormatHelper.formatCurrency(amount)),
                            ],
                          ),
                          SizedBox(
                            height: 13.h,
                          ),
                          Divider(
                            color: AppTheme.grey.withOpacity(0.5),
                            thickness: 0.5.w,
                          ),
                          SizedBox(
                            height: 13.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.payment_payment_by.trans(),
                              ),
                              Text(
                                paymentMethod.toValue(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 29.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.only(left: 11.w, right: 10.w),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Assets.icons.icPaymentProcessing.image(
                        height: 60.h,
                        width: 65.w,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(
                  left: 32.w,
                  right: 32.w,
                  bottom: 30.h,
                ),
                child: ElevatedButton(
                  onPressed: () => backPageOrHome(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: SizedBox(
                    height: 50.h,
                    child: Center(
                      child: Text(
                        LocaleKeys.payment_back_home.trans(),
                        style: AppTheme.white_16w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
