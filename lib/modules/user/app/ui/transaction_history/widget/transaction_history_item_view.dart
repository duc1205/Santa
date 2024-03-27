import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/user/domain/enums/user_balance_changing_type.dart';
import 'package:santapocket/modules/user/domain/models/balance_log.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class TransactionHistoryItemView extends StatelessWidget {
  final VoidCallback? onItemClick;
  final BalanceLog balanceLog;
  final User? currentUser;

  const TransactionHistoryItemView({Key? key, required this.balanceLog, this.onItemClick, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: AppTheme.borderLight),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Row(
            children: [
              Container(
                height: 36.w,
                width: 36.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36.r),
                  color: AppTheme.silverLight,
                ),
                child: Center(
                  child: _isTopUp(balanceLog)
                      ? const Icon(
                          Icons.arrow_upward,
                          color: AppTheme.greenLight,
                        )
                      : const Icon(
                          Icons.arrow_downward,
                          color: AppTheme.orange,
                        ),
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: _isAlignCenter() ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getLabelV2(balanceLog),
                          style: AppTheme.blackDark_16,
                        ),
                        _detailTransactionWidget(balanceLog),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _getBalanceFluctuation(balanceLog),
                          style: _isTopUp(balanceLog) ? AppTheme.greenLight_16w600 : AppTheme.orange_16w600,
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        Text(
                          FormatHelper.formatDate("dd/MM/yyyy, kk:mm", balanceLog.createdAt),
                          style: AppTheme.blackDark_13a60,
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
    );
  }

  bool _isAlignCenter() => balanceLog.type != UserBalanceChangingType.adminTransfer;

  Widget _detailTransactionWidget(BalanceLog balanceLog) {
    if ((_isTopUp(balanceLog) && balanceLog.type != UserBalanceChangingType.adminTransfer)) return Container();
    return balanceLog.type == UserBalanceChangingType.adminTransfer
        ? Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: userInfoWidget(balanceLog),
          )
        : Visibility(
            visible: balanceLog.type != UserBalanceChangingType.adminAdding,
            child: Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Text(
                "${LocaleKeys.user_delivery_id.trans()} ${balanceLog.extra?['delivery_id'] != null ? FormatHelper.formatId(int.parse(balanceLog.extra!['delivery_id'].toString())) : ""}",
                style: AppTheme.blackDark_13a60,
              ),
            ),
          );
  }

  bool _isTopUp(BalanceLog balanceLog) {
    return balanceLog.balance - balanceLog.oldBalance > 0;
  }

  String _getBalanceFluctuation(BalanceLog balanceLog) {
    final delta = balanceLog.balance - balanceLog.oldBalance;
    return "${delta > 0 ? "+" : ""}${FormatHelper.formatCurrencyV2(delta)}";
  }

  Widget userInfoWidget(BalanceLog balanceLog) {
    if ((balanceLog.extra?["sender"]?["phone_number"] ?? "") == "") return Container();
    return currentUser?.phoneNumber == balanceLog.extra?["sender"]["phone_number"]
        ? SizedBox(
            width: 145.w,
            child: Wrap(children: [
              Text(
                "${balanceLog.extra?["receiver"]["phone_number"] ?? ""} ",
                style: AppTheme.blackDark_13a60,
              ),
              Text(
                (balanceLog.extra?["receiver"]["name"] == null || (balanceLog.extra?["receiver"]["name"] as String).removeAllWhitespace.isEmpty)
                    ? ""
                    : "(${balanceLog.extra?["receiver"]["name"]})",
                style: AppTheme.blackDark_13a60,
              ),
            ]),
          )
        : SizedBox(
            width: 145.w,
            child: Wrap(children: [
              Text(
                "${balanceLog.extra?["sender"]["phone_number"] ?? ""} ",
                style: AppTheme.blackDark_13a60,
              ),
              Text(
                (balanceLog.extra?["sender"]["name"] == null || (balanceLog.extra?["sender"]["name"] as String).removeAllWhitespace.isEmpty)
                    ? ""
                    : "(${balanceLog.extra?["sender"]["name"]})",
                style: AppTheme.blackDark_13a60,
              ),
            ]),
          );
  }

  String getLabelV2(BalanceLog balanceLog) {
    switch (balanceLog.type) {
      case UserBalanceChangingType.newUser:
      case UserBalanceChangingType.adminAdding:
        return (!_isTopUp(balanceLog)) ? LocaleKeys.user_deduction_xu.trans() : LocaleKeys.user_bonus_xu.trans();
      case UserBalanceChangingType.topUp:
        return LocaleKeys.user_top_up_xu.trans();
      case UserBalanceChangingType.deliveryReceiving:
      case UserBalanceChangingType.deliverySending:
      case UserBalanceChangingType.deliveryRent:
        return LocaleKeys.user_spent.trans();
      case UserBalanceChangingType.deliveryRefund:
        return LocaleKeys.user_refund_xu.trans();
      case UserBalanceChangingType.deliveryCharge:
        return LocaleKeys.user_delivery_charged.trans();
      case UserBalanceChangingType.adminTransfer:
        return LocaleKeys.user_transferred_xu.trans();
      default:
        return '';
    }
  }
}
