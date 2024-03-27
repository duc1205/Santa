import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/hrm_payroll/domain/enums/payroll_status_type.dart';
import 'package:santapocket/modules/payment/domain/enums/payment_method.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class PaymentMethodWidget extends StatelessWidget {
  final PaymentMethod? defaultPaymentMethod;
  final Function(PaymentMethod) onSelectPaymentMethod;
  final bool isAppBankTransferEnable;
  final Map<String, dynamic>? bankTransferInfo;
  final String? bankTransferMessage;
  final VoidCallback onVnpayHelpClick;
  final PayrollStatusType payrollStatus;

  const PaymentMethodWidget({
    required this.defaultPaymentMethod,
    required this.onSelectPaymentMethod,
    required this.isAppBankTransferEnable,
    this.bankTransferInfo,
    required this.bankTransferMessage,
    required this.onVnpayHelpClick,
    Key? key,
    required this.payrollStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => onSelectPaymentMethod(PaymentMethod.moMo),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 17.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: defaultPaymentMethod == PaymentMethod.moMo ? AppTheme.orange.withOpacity(0.2) : Colors.white,
              border: Border.all(
                color: defaultPaymentMethod == PaymentMethod.moMo ? AppTheme.orange : AppTheme.grey,
                width: 0.5.w,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 14.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: defaultPaymentMethod == PaymentMethod.moMo ? AppTheme.yellow1 : AppTheme.grey.withOpacity(0.5),
                      width: 1.w,
                    ),
                  ),
                  child: Icon(
                    Icons.circle,
                    color: defaultPaymentMethod == PaymentMethod.moMo ? AppTheme.yellow1 : Colors.white,
                    size: 9.sp,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Assets.icons.icTopupMomo.image(
                  height: 20.h,
                  width: 20.w,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  LocaleKeys.payment_momo_wallet.trans(),
                  style: AppTheme.blackDark_14bold,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 14.h,
        ),
        InkWell(
          onTap: () => onSelectPaymentMethod(PaymentMethod.vnPay),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: defaultPaymentMethod == PaymentMethod.vnPay ? AppTheme.orange : AppTheme.grey,
                width: 0.5.w,
              ),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
                    color: defaultPaymentMethod == PaymentMethod.vnPay ? AppTheme.light5 : Colors.white,
                  ),
                  padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 16.h),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 3.w,
                          ),
                          Container(
                            width: 14.w,
                            height: 14.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: defaultPaymentMethod == PaymentMethod.vnPay ? AppTheme.yellow1 : AppTheme.grey.withOpacity(0.5),
                                width: 1.w,
                              ),
                            ),
                            child: Icon(
                              Icons.circle,
                              color: defaultPaymentMethod == PaymentMethod.vnPay ? AppTheme.yellow1 : Colors.white,
                              size: 9.sp,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Assets.icons.icTopupVnpayWallet.image(
                            height: 20.h,
                            width: 20.w,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "VNPAY",
                                style: AppTheme.blackDark_14bold,
                              ),
                              GestureDetector(
                                onTap: onVnpayHelpClick,
                                child: Row(
                                  children: [
                                    Text(
                                      LocaleKeys.payment_vnpay_info.trans(),
                                      style: AppTheme.windsorGrey_12w400,
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Assets.icons.icTopupVnpayInfo.image(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Divider(
                        thickness: 0.5.w,
                        height: 1.h,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r), bottomRight: Radius.circular(10.r)),
                    color: AppTheme.light6,
                  ),
                  padding: EdgeInsets.only(left: 24.w, top: 8.h, bottom: 18.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Assets.icons.icTopupAtm.image(
                            height: 31.h,
                            width: 29.w,
                          ),
                          SizedBox(
                            width: 17.w,
                          ),
                          Text(
                            LocaleKeys.payment_atm.trans(),
                            style: AppTheme.black_14,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Row(
                        children: [
                          Assets.icons.icTopupVisa.image(
                            height: 29.h,
                            width: 34.w,
                          ),
                          SizedBox(
                            width: 13.w,
                          ),
                          Text(
                            LocaleKeys.payment_visa.trans(),
                            style: AppTheme.black_14,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Row(
                        children: [
                          Assets.icons.icTopupVnpay.image(
                            height: 26.h,
                            width: 28.w,
                          ),
                          SizedBox(
                            width: 17.w,
                          ),
                          Text(
                            LocaleKeys.payment_vnpay_wallet.trans(),
                            style: AppTheme.black_14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 14.h,
        ),
        Visibility(
          visible: isAppBankTransferEnable,
          child: InkWell(
            onTap: () => onSelectPaymentMethod(PaymentMethod.bankTransfer),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: defaultPaymentMethod == PaymentMethod.bankTransfer ? AppTheme.orange : AppTheme.grey,
                  width: 0.5.w,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      color: defaultPaymentMethod == PaymentMethod.bankTransfer ? AppTheme.light5 : Colors.white,
                    ),
                    padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 16.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 3.w,
                            ),
                            Container(
                              width: 14.w,
                              height: 14.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: defaultPaymentMethod == PaymentMethod.bankTransfer ? AppTheme.yellow1 : AppTheme.grey.withOpacity(0.5),
                                  width: 1.w,
                                ),
                              ),
                              child: Icon(
                                Icons.circle,
                                color: defaultPaymentMethod == PaymentMethod.bankTransfer ? AppTheme.yellow1 : Colors.white,
                                size: 9.sp,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              LocaleKeys.payment_bank_transfer.trans(),
                              style: AppTheme.blackDark_14w600,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 18.h,
                        ),
                        Visibility(
                          visible: defaultPaymentMethod == PaymentMethod.bankTransfer,
                          child: Divider(
                            thickness: 0.5.w,
                            height: 1.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: defaultPaymentMethod == PaymentMethod.bankTransfer,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r), bottomRight: Radius.circular(10.r)),
                        color: AppTheme.light6,
                      ),
                      padding: EdgeInsets.only(left: 14.w, right: 4.w, top: 14.h, bottom: 18.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${LocaleKeys.payment_account_number.trans()}: ",
                                style: AppTheme.grey_14w400,
                              ),
                              Text(
                                "${bankTransferInfo?["bank"]?["name"] ?? ""} - ${bankTransferInfo?["bank"]?["account_number"] ?? ""}",
                                style: AppTheme.blackDark_14,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              InkWell(
                                onTap: () async {
                                  await Clipboard.setData(ClipboardData(
                                    text: bankTransferInfo?["bank"]?["account_number"] ?? "",
                                  )).then((value) {
                                    showToast(LocaleKeys.payment_copy_successful.trans());
                                  });
                                },
                                child: Image.asset(Assets.icons.icTopupCopy.path, color: AppTheme.red1),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              Text(
                                "${LocaleKeys.payment_account_name.trans()}: ",
                                style: AppTheme.grey_14w400,
                              ),
                              Text(
                                bankTransferInfo?["bank"]?["account_name"] ?? "",
                                style: AppTheme.blackDark_14,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "${LocaleKeys.payment_transfer_contents.trans()}: ",
                            style: AppTheme.grey_14w400,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.h, right: 9.w),
                            padding: EdgeInsets.symmetric(
                              vertical: 15.h,
                              horizontal: 15.w,
                            ),
                            decoration: BoxDecoration(color: AppTheme.light9, borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    bankTransferMessage ?? "",
                                    style: AppTheme.blackDark_14bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await Clipboard.setData(
                                      ClipboardData(text: bankTransferMessage),
                                    ).then((value) {
                                      showToast(LocaleKeys.payment_copy_successful.trans());
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                                    decoration: BoxDecoration(
                                      color: AppTheme.light5,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: AppTheme.orange3),
                                    ),
                                    child: Text(
                                      LocaleKeys.payment_copy.trans(),
                                      style: AppTheme.blackDark_14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(LocaleKeys.payment_bank_transfer_hint.trans(), style: AppTheme.goldishOrange_12w400),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(LocaleKeys.payment_support.trans(), style: AppTheme.windsorGrey_14w400),
                          Container(
                            margin: EdgeInsets.only(right: 9.w, top: 9.h),
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.commercialWhite,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      LocaleKeys.payment_call_hotline.trans(),
                                      style: AppTheme.black_14w400,
                                    ),
                                    const Spacer(),
                                    Text(
                                      bankTransferInfo?["hotline"]?[0]["phone_number"] ?? "",
                                      style: AppTheme.blueDark_14w400,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await Clipboard.setData(ClipboardData(text: bankTransferInfo?["hotline"]?[0]["phone_number"] ?? ""))
                                            .then((value) {
                                          showToast(LocaleKeys.payment_copy_successful.trans());
                                        });
                                      },
                                      child: Image.asset(Assets.icons.icTopupCopy.path, color: AppTheme.red1),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                GestureDetector(
                                  onTap: () => launchUri("http://zalo.me/${bankTransferInfo?["contacts"]?["zalo"]?["value"] ?? ""}"),
                                  child: Row(
                                    children: [
                                      Text(
                                        LocaleKeys.payment_chat.trans(),
                                        style: AppTheme.black_14w400,
                                      ),
                                      Expanded(
                                        child: Text(
                                          bankTransferInfo?["contacts"]?["zalo"]?["label"] ?? "",
                                          style: AppTheme.blueDark_14w400,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 14.h,
        ),
        Visibility(
          visible: payrollStatus == PayrollStatusType.registered,
          child: InkWell(
            onTap: () => onSelectPaymentMethod(PaymentMethod.santaPayroll),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 17.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: defaultPaymentMethod == PaymentMethod.santaPayroll ? AppTheme.orange.withOpacity(0.2) : Colors.white,
                border: Border.all(
                  color: defaultPaymentMethod == PaymentMethod.santaPayroll ? AppTheme.orange : AppTheme.grey,
                  width: 0.5.w,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 14.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: defaultPaymentMethod == PaymentMethod.santaPayroll ? AppTheme.yellow1 : AppTheme.grey.withOpacity(0.5),
                        width: 1.w,
                      ),
                    ),
                    child: Icon(
                      Icons.circle,
                      color: defaultPaymentMethod == PaymentMethod.santaPayroll ? AppTheme.yellow1 : Colors.white,
                      size: 9.sp,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    LocaleKeys.payment_santa_payroll.trans(),
                    style: AppTheme.blackDark_14bold,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
