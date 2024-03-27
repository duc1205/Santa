import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/user/domain/enums/user_cone_changing_type.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/models/user_cone_log.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class ConeHistoryItemView extends StatelessWidget {
  final VoidCallback? onItemClick;
  final UserConeLog userConeLog;
  final User? currentUser;

  const ConeHistoryItemView({
    Key? key,
    required this.userConeLog,
    this.onItemClick,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderLight),
      ),
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h, top: 16.h),
      child: Row(
        children: [
          _isTopUp(userConeLog)
              ? Assets.icons.icConeBonus.image(
                  width: 36.w,
                  height: 36.w,
                )
              : Assets.icons.icConeDeduction.image(
                  width: 36.w,
                  height: 36.w,
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
                  getLabel(userConeLog),
                  style: AppTheme.blackDark_16,
                ),
                _detailTransactionWidget(userConeLog),
                SizedBox(
                  height: 6.h,
                ),
                Text(
                  FormatHelper.formatDate("dd/MM/yyyy, kk:mm", userConeLog.createdAt),
                  style: AppTheme.blackDark_13a60,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 14.w,
          ),
          Text(
            _getBalanceFluctuation(userConeLog),
            style: _isTopUp(userConeLog) ? AppTheme.yellow1_14w600 : AppTheme.blackDark_14w600,
          ),
        ],
      ),
    );
  }

  Widget _detailTransactionWidget(UserConeLog log) {
    if ((!_isTopUp(log))) {
      return Container();
    }
    return Visibility(
      visible: log.extra?['delivery_id'] != null,
      child: Padding(
        padding: EdgeInsets.only(top: 6.h),
        child: Text(
          "${LocaleKeys.user_delivery_id.trans()} ${log.extra?['delivery_id'] != null ? FormatHelper.formatId(int.parse(log.extra!['delivery_id'].toString())) : ""}",
          style: AppTheme.blackDark_13a60,
        ),
      ),
    );
  }

  bool _isTopUp(UserConeLog log) {
    return log.cone - log.oldCone > 0;
  }

  String _getBalanceFluctuation(UserConeLog log) {
    final delta = log.cone - log.oldCone;
    return "${delta > 0 ? "+" : ""}${FormatHelper.formatCurrency(delta, unit: "")}";
  }

  Widget userInfoWidget(UserConeLog log) {
    if ((log.extra?["sender"]?["phone_number"] ?? "") == "") return Container();
    return currentUser?.phoneNumber == log.extra?["sender"]["phone_number"]
        ? SizedBox(
            width: 145.w,
            child: Wrap(children: [
              Text(
                "${log.extra?["receiver"]["phone_number"] ?? ""} ",
                style: AppTheme.blackDark_13a60,
              ),
              Text(
                (log.extra?["receiver"]["name"] == null || (log.extra?["receiver"]["name"] as String).removeAllWhitespace.isEmpty)
                    ? ""
                    : "(${log.extra?["receiver"]["name"]})",
                style: AppTheme.blackDark_13a60,
              ),
            ]),
          )
        : SizedBox(
            width: 145.w,
            child: Wrap(children: [
              Text(
                "${log.extra?["sender"]["phone_number"] ?? ""} ",
                style: AppTheme.blackDark_13a60,
              ),
              Text(
                (log.extra?["sender"]["name"] == null || (log.extra?["sender"]["name"] as String).removeAllWhitespace.isEmpty)
                    ? ""
                    : "(${log.extra?["sender"]["name"]})",
                style: AppTheme.blackDark_13a60,
              ),
            ]),
          );
  }

  String getLabel(UserConeLog log) {
    switch (log.type) {
      case UserConeChangingType.deliveryReceivingReward:
      case UserConeChangingType.referReward:
      case UserConeChangingType.referredReward:
        return LocaleKeys.user_bonus_cone.trans();
      default:
        return (_isTopUp(log)) ? LocaleKeys.user_bonus_cone.trans() : LocaleKeys.user_deduction_cone.trans();
    }
  }
}
