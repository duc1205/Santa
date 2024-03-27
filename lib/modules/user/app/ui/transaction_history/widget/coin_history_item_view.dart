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

class CoinHistoryItemView extends StatelessWidget {
  final VoidCallback? onItemClick;
  final BalanceLog balanceLog;
  final User? currentUser;

  const CoinHistoryItemView({Key? key, required this.balanceLog, this.onItemClick, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.radioBorder),
        ),
      ),
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h, top: 16.h),
      child: Row(
        children: [
          Container(
            height: 36.w,
            width: 36.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36.r),
              color: _isTopUp(balanceLog) ? AppTheme.yellow4 : AppTheme.christmasSilver,
            ),
            child: Center(
              child: _isTopUp(balanceLog)
                  ? const Icon(
                      Icons.arrow_upward,
                      color: AppTheme.foxTailOrange,
                    )
                  : const Icon(
                      Icons.arrow_downward,
                      color: AppTheme.greyIcon,
                    ),
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getLabel(balanceLog),
                  style: AppTheme.blackDark_16,
                ),
                _detailTransactionWidget(balanceLog),
                SizedBox(
                  height: 6.h,
                ),
                Text(
                  FormatHelper.formatDate("dd/MM/yyyy, kk:mm", balanceLog.createdAt),
                  style: AppTheme.blackDark_13a60,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 14.w,
          ),
          Text(
            _getBalanceFluctuation(balanceLog),
            style: _isTopUp(balanceLog) ? AppTheme.yellow1_14w600 : AppTheme.blackDark_14w600,
          ),
        ],
      ),
    );
  }

  Widget _detailTransactionWidget(BalanceLog balanceLog) {
    if ((_isTopUp(balanceLog) && balanceLog.type != UserBalanceChangingType.adminTransfer) || balanceLog.type == UserBalanceChangingType.unknown) {
      return Container();
    }
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
    final roundValue = FormatHelper.roundSantaXu(delta);
    return "${delta > 0 ? "+" : ""}${FormatHelper.formatCurrency(roundValue, unit: "")}";
  }

  Widget userInfoWidget(BalanceLog balanceLog) {
    if ((balanceLog.extra?["sender"]?["phone_number"] ?? "") == "") return Container();
    return currentUser?.phoneNumber == balanceLog.extra?["sender"]["phone_number"]
        ? Wrap(children: [
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
          ])
        : Wrap(children: [
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
          ]);
  }

  String getLabel(BalanceLog balanceLog) {
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
        return (_isTopUp(balanceLog)) ? LocaleKeys.user_bonus_xu.trans() : LocaleKeys.user_deduction_xu.trans();
    }
  }
}
