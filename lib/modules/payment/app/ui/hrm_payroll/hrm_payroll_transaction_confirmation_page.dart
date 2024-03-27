import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/payment/app/ui/hrm_payroll/hrm_payroll_transaction_confirmation_page_viewmodel.dart';
import 'package:santapocket/modules/payment/domain/models/payment_product.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class HrmPayrollTransactionConfirmationPage extends StatefulWidget {
  final PaymentProduct paymentProduct;
  final String locale;
  final int getCoinAmount;
  final int getCoinPromo;
  final int getPrice;
  const HrmPayrollTransactionConfirmationPage({
    super.key,
    required this.paymentProduct,
    required this.locale,
    required this.getCoinAmount,
    required this.getCoinPromo,
    required this.getPrice,
  });

  @override
  State<HrmPayrollTransactionConfirmationPage> createState() => _HrmPayrollTransactionConfirmationPageState();
}

class _HrmPayrollTransactionConfirmationPageState
    extends BaseViewState<HrmPayrollTransactionConfirmationPage, HrmPayrollTransactionConfirmationPageViewmodel> {
  @override
  HrmPayrollTransactionConfirmationPageViewmodel createViewModel() => locator<HrmPayrollTransactionConfirmationPageViewmodel>();

  @override
  void loadArguments() {
    super.loadArguments();
    viewModel.locale = widget.locale;
    viewModel.paymentProduct = widget.paymentProduct;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.payment_confirm_transaction.trans(),
          style: AppTheme.black_16w600,
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 14.h,
                ),
                Text(LocaleKeys.payment_payment_by.trans(), style: AppTheme.black_14w600),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: AppTheme.light5,
                    border: Border.all(color: AppTheme.samoanSunOrange),
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(height: 38.w, width: 38.w, child: Assets.icons.icHrmTopupPayroll.image(fit: BoxFit.fill)),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                        onTap: () => viewModel.onRevealWalletClicked(),
                        child: Container(
                          padding: EdgeInsets.only(top: 5.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(LocaleKeys.payment_santa_payroll.trans(), style: AppTheme.black_14w600),
                              SizedBox(
                                height: 2.h,
                              ),
                              Row(
                                children: [
                                  Obx(
                                    () => Text(
                                      viewModel.isRevealWallet
                                          ? "**********"
                                          : FormatHelper.formatCurrency(
                                              viewModel.userSalary,
                                            ).removeWhitespaces(),
                                      style: AppTheme.windsorGrey_12w400,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Obx(
                                    () => Icon(
                                      viewModel.isRevealWallet ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                      color: AppTheme.windsorGrey,
                                      size: 16.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          LocaleKeys.payment_change.trans(),
                          style: AppTheme.goldishOrange_14w600,
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Text(
                    LocaleKeys.payment_transaction_details.trans(),
                    style: AppTheme.black_14w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(14.sp),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.border),
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.payment_description.trans(),
                            style: AppTheme.windsorGrey_14w400,
                          ),
                          Text(
                            LocaleKeys.payment_description_message.trans(),
                            style: AppTheme.black_14w400,
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
                            LocaleKeys.payment_coin_amount.trans(),
                            style: AppTheme.windsorGrey_14w400,
                          ),
                          Text(
                            FormatHelper.formatCurrencyV2(widget.getCoinAmount),
                            style: AppTheme.black_14w400,
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
                            LocaleKeys.payment_coin_promotion.trans(),
                            style: AppTheme.windsorGrey_14w400,
                          ),
                          Text(
                            FormatHelper.formatCurrencyV2(widget.getCoinPromo),
                            style: AppTheme.black_14w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w).copyWith(top: 4.h),
                      child: SizedBox(
                        width: 14.w,
                        height: 14.w,
                        child: Obx(
                          () => Checkbox(
                            fillColor: MaterialStateProperty.resolveWith((states) {
                              if (!states.contains(MaterialState.selected)) {
                                return AppTheme.radioBorder;
                              }
                              return AppTheme.yellow1;
                            }),
                            value: viewModel.isAcceptTos,
                            onChanged: (value) => viewModel.setIsAcceptTos(value ?? false),
                            side: BorderSide(
                              color: AppTheme.radioBorder,
                              width: 1.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      child: EasyRichText(
                        LocaleKeys.payment_policy_message.trans(),
                        defaultStyle: AppTheme.blackDark_14w400.copyWith(height: 1.25.h),
                        patternList: [
                          EasyRichTextPattern(
                            targetString: LocaleKeys.payment_here.trans(),
                            style: AppTheme.blueDark_14w400U,
                            recognizer: TapGestureRecognizer()..onTap = () => viewModel.launchPoliciesUrl(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Divider(thickness: 1.sp),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.payment_total_payroll_amt.trans(),
                  style: AppTheme.black_18w400,
                ),
                Text(
                  FormatHelper.formatCurrency(widget.getPrice).removeWhitespaces(),
                  style: AppTheme.red1_20w600,
                ),
              ],
            ),
          ),
          Divider(thickness: 1.sp),
          Obx(
            () => Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: GestureDetector(
                onTap: viewModel.isAcceptTos ? () => viewModel.topupPayroll() : null,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: viewModel.isAcceptTos ? AppTheme.yellow1 : AppTheme.yellow4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline, color: Colors.white),
                      SizedBox(
                        width: 12.w,
                      ),
                      Text(LocaleKeys.payment_confirm.trans(), style: AppTheme.white_14w600),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
